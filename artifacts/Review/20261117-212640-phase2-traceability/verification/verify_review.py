"""Audit review artifacts and inventories; does not prove product behavior."""
from datetime import datetime, timezone, timedelta
from pathlib import Path
import hashlib
import json
import re
import subprocess
import sys
import tomllib

ROOT = Path(__file__).resolve().parents[4]
RUN = Path(__file__).resolve().parents[1]

def read(p):
    return (ROOT / p).read_text(encoding='utf-8-sig')

def load(p):
    return json.loads(p.read_text(encoding='utf-8-sig'))

manifest = load(RUN / 'traceability/input-manifest.json')
matrix = load(RUN / 'traceability/matrix.json')
reverse = load(RUN / 'traceability/reverse-map.json')
findings = load(RUN / 'traceability/findings.json')
errors = []
process = subprocess.run([sys.executable, str(RUN / 'verification/check_documents.py')], cwd=ROOT, capture_output=True, text=True, encoding='utf-8')
(RUN / 'verification/document-checks.log').write_text(process.stdout + process.stderr, encoding='utf-8')
if process.returncode:
    errors.append('structural checker failed')
structure = load(RUN / 'verification/document-checks.json')
decision_ids = re.findall(r'^\| (C\d+) \|', read('docs/requirements_clarifications.md'), re.M)
bullets = [line for line in read('docs/preliminary_requirements.md').splitlines() if line.strip()]
required = {f'B{i}' for i in range(1, len(bullets) + 1)} | set(decision_ids)
row_ids = [row['id'] for row in matrix]
if len(row_ids) != len(set(row_ids)) or set(row_ids) != required | {'Q6'}:
    errors.append('missing/duplicate matrix requirement')
mapping = tomllib.loads(read('.specify/rvc-review-map.toml'))
if set(mapping['identifiers']['requirements']) != required:
    errors.append('stale requirement mapping')
for group in ('spec', 'plan', 'evidence_indexes', 'rules'):
    for path in mapping['roles'][group]:
        if not (ROOT / path).exists():
            errors.append('mapped path missing: ' + path)
for row in matrix:
    if not row['evidence']:
        errors.append('no SA evidence: ' + row['id'])
    for ref in [row['source'], *row['evidence']]:
        lines = read(ref['path']).splitlines()
        if not 1 <= ref['start'] <= ref['end'] <= len(lines):
            errors.append('bad citation range: ' + str(ref))
    for field in ('sd_status', 'c_status', 'unit_test_status', 'system_test_status'):
        if not row[field].startswith('notChecked'):
            errors.append('out-of-scope compliance claim: ' + row['id'])
for finding in findings:
    for ref in finding['locations']:
        if not 1 <= ref['start'] <= ref['end'] <= len(read(ref['path']).splitlines()):
            errors.append('bad finding citation')
fsm = read('artifacts/SA/DFD/dfd_level_4_fsm.md')
actual = {
    'flows': set(structure['flow_names']),
    'processes': set(structure['process_ids']),
    'stores': set(re.findall(r'^\| (D\d+) ', read('artifacts/SA/data_dictionary.md'), re.M)),
    'states': set(re.findall(r'^\| (Forward|Stopping|Backing|TurningRight|TurningLeft) \|', fsm, re.M)),
    'transitions': set(re.findall(r'^\| (T\d+) \|', fsm, re.M)),
}
for kind, expected in actual.items():
    rows = reverse[kind]
    names = [row[0] for row in rows]
    if set(names) != expected or len(names) != len(set(names)):
        errors.append('reverse inventory mismatch: ' + kind)
    for name, refs, _ in rows:
        if not set(refs.split(',')) <= required | {'Q6'}:
            errors.append('unknown requirement in reverse map: ' + name)
for path, expected in manifest['protected_files'].items():
    if hashlib.sha256((ROOT / path).read_bytes()).hexdigest() != expected:
        errors.append('source changed: ' + path)
checklist = (RUN / 'traceability/checklist.md').read_text(encoding='utf-8')
items = re.findall(r'^- \[ \] (CHK\d+)', checklist, re.M)
if len(items) != 15 or len(set(items)) != 15 or '- [x]' in checklist:
    errors.append('checklist lifecycle/count')
pending = RUN / 'verification/review-checks.json'
pending.write_text('{"status":"checking"}', encoding='utf-8')
(RUN / 'verification/checks.log').touch()
for p in [ROOT / 'QA.md', ROOT / 'README.md', *RUN.rglob('*.md')]:
    if p.name == 'source-snapshot.md':
        continue
    for target in re.findall(r'(?<!!)\[[^\]]*\]\(([^)]+)\)', p.read_text(encoding='utf-8-sig')):
        if '://' in target or target.startswith('#'):
            continue
        if not (p.parent / target.split('#', 1)[0]).exists():
            errors.append('broken link: ' + str(p) + ': ' + target)
patterns = ['TODO', 'TBD', 'TKTK', 'placeholder', 'Open:', 'remain open', 'Obstacle Situation == Clear', 'Power On / Forward']
search_hits = []
for item in manifest['inputs']:
    for i, line in enumerate(read(item['path']).splitlines(), 1):
        if any(pattern.lower() in line.lower() for pattern in patterns):
            search_hits.append({'path': item['path'], 'line': i, 'text': line})
diff = subprocess.run(['git', 'diff', '--check'], cwd=ROOT, capture_output=True, text=True, encoding='utf-8')
if diff.returncode:
    errors.append('git diff --check')
result = {
    'checked_at': datetime.now(timezone(timedelta(hours=9))).isoformat(),
    'scope': 'Review artifact integrity/inventory, not semantic or product proof',
    'structural_exit': process.returncode,
    'boundary_pairs_equal': sum(row['equal'] for row in structure['boundaries']),
    'requirement_rows': len(required), 'assumption_rows': len(matrix) - len(required),
    'reverse_counts': {key: len(rows) for key, rows in reverse.items()},
    'unchecked_checklist_items': len(items),
    'protected_files_unchanged': len(manifest['protected_files']),
    'mapped_paths_exist': len(manifest['mapped_path_existence']),
    'source_search': {'patterns': patterns, 'hits': search_hits},
    'git_diff_check_exit': diff.returncode,
    'product_tests': 'notRun', 'spin': 'notRun',
    'errors': errors,
}
output = json.dumps(result, ensure_ascii=False, indent=2)
pending.write_text(output, encoding='utf-8')
(RUN / 'verification/checks.log').write_text(output + '\n' + diff.stdout + diff.stderr, encoding='utf-8')
print(output)
raise SystemExit(bool(errors))
