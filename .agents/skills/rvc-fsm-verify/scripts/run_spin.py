#!/usr/bin/env python3
"""Run one self-contained SPIN check; preserve logs and fail closed on incomplete searches."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
from datetime import datetime, timezone


def executable(value, default, fallback=None):
    candidate = value or shutil.which(default)
    if not candidate and fallback and fallback.is_file():
        candidate = str(fallback)
    if not candidate:
        raise ValueError(f"Cannot find {default}; supply an explicit path")
    resolved = shutil.which(candidate) or candidate
    path = Path(resolved).resolve()
    if not path.is_file():
        raise ValueError(f"Executable not found: {path}")
    return str(path)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--model', type=Path, required=True)
    parser.add_argument('--out', type=Path, required=True)
    parser.add_argument('--spin')
    parser.add_argument('--cc')
    parser.add_argument('--ltl', help='Named inline LTL claim; checked with acceptance-cycle search')
    parser.add_argument('--depth', type=int, default=100000)
    parser.add_argument('--timeout', type=int, default=120, help='Seconds per subprocess')
    args = parser.parse_args()
    result = {'status': 'inconclusive', 'started_utc': datetime.now(timezone.utc).isoformat(),
              'commands': [], 'scope': 'one property/check on the supplied model only',
              'ltl': args.ltl, 'depth': args.depth, 'fairness': 'none', 'search': 'full-state'}
    out = args.out.resolve()
    ready = False

    def run(stage, command):
        record = {'stage': stage, 'argv': command, 'cwd': str(out)}
        result['commands'].append(record)
        try:
            proc = subprocess.run(command, cwd=out, env=env, stdout=subprocess.PIPE,
                                  stderr=subprocess.STDOUT, timeout=args.timeout)
            text = proc.stdout.decode('utf-8', errors='replace')
            record['exit_code'] = proc.returncode
        except subprocess.TimeoutExpired as exc:
            text = (exc.stdout or b'').decode('utf-8', errors='replace')
            record['timeout'] = True
            (out / f'{stage}.log').write_text(text, encoding='utf-8')
            raise RuntimeError(f'{stage} timed out; search result is not a pass') from exc
        (out / f'{stage}.log').write_text(text, encoding='utf-8')
        return proc.returncode, text

    try:
        if args.depth <= 0 or args.timeout <= 0:
            raise ValueError('depth and timeout must be positive')
        model = args.model.resolve(strict=True)
        raw = model.read_bytes()
        source = raw.decode('utf-8-sig')
        if re.search(r'^\s*#\s*include\b', source, re.M):
            raise ValueError('Use a self-contained model; includes are not captured by this runner')
        if re.search(r'\bnever\s*\{', source):
            raise ValueError('Use named inline LTL rather than an anonymous never claim')
        claims = re.findall(r'\bltl\s+(\w+)\s*\{', source)
        if claims and not args.ltl:
            raise ValueError('Model has LTL claims; select one explicitly with --ltl')
        if args.ltl and args.ltl not in claims:
            raise ValueError(f'Named LTL claim not found: {args.ltl}')
        spin = executable(args.spin, 'spin', Path.home() / '.local/bin/spin.exe')
        cc = executable(args.cc, 'gcc')
        if out.exists() and (not out.is_dir() or any(out.iterdir())):
            raise ValueError('Output directory must be new or empty; previous runs are preserved')
        out.mkdir(parents=True, exist_ok=True)
        ready = True
        (out / 'model.pml').write_bytes(raw)
        result.update(model_source=str(model), model_sha256=hashlib.sha256(raw).hexdigest(),
                      spin=spin, compiler=cc)
        env = os.environ.copy()
        env['PATH'] = str(Path(cc).parent) + os.pathsep + env.get('PATH', '')
        for stage, command in [('spin-version', [spin, '-V']), ('compiler-version', [cc, '--version'])]:
            code, _ = run(stage, command)
            if code:
                raise RuntimeError(f'{stage} failed; inspect log')
        code, _ = run('generate', [spin, '-a', 'model.pml'])
        if code or not (out / 'pan.c').is_file():
            raise RuntimeError('Model generation failed; inspect generate.log')
        binary = out / ('pan.exe' if os.name == 'nt' else 'pan')
        code, _ = run('compile', [cc, '-O2', '-o', str(binary), 'pan.c'])
        if code:
            raise RuntimeError('Verifier compilation failed; inspect compile.log')
        command = [str(binary), f'-m{args.depth}']
        if args.ltl:
            command += ['-a', '-N', args.ltl]
        code, text = run('search', command)
        errors = re.search(r'\berrors:\s*(\d+)', text)
        incomplete = re.search(r'max search depth too small|out of memory|search not completed|'
                               r'VECTORSZ.*too small|cannot allocate', text, re.I)
        if errors:
            result['errors'] = int(errors.group(1))
        for name, pattern in [('stored_states', r'([\d.e+]+)\s+states, stored'),
                              ('transitions', r'([\d.e+]+)\s+transitions')]:
            match = re.search(pattern, text, re.I)
            if match:
                result[name] = match.group(1)
        if errors and int(errors.group(1)) > 0:
            result['status'] = 'failed'
            result['reason'] = 'SPIN found a counterexample; classify against model and source requirements'
            trails = sorted(out.glob('*.trail'))
            result['trails'] = [p.name for p in trails]
            if trails:
                try:
                    replay_code, _ = run('replay', [spin, '-t', '-p', '-g', '-l', '-k', trails[0].name, 'model.pml'])
                    result['replay_ok'] = replay_code == 0
                except RuntimeError as exc:
                    result['replay_ok'] = False
                    result['replay_note'] = str(exc)
        elif code or not errors or incomplete:
            result['reason'] = 'Nonzero exit, missing summary or incomplete search; inspect search.log'
        else:
            result['status'] = 'passed'
            result['reason'] = 'Configured check completed with zero reported errors; model fidelity is separate'
    except (ValueError, OSError, RuntimeError, UnicodeError) as exc:
        result['reason'] = str(exc)
    if ready:
        result['finished_utc'] = datetime.now(timezone.utc).isoformat()
        (out / 'result.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return {'passed': 0, 'failed': 1, 'inconclusive': 2}[result['status']]


if __name__ == '__main__':
    sys.exit(main())
