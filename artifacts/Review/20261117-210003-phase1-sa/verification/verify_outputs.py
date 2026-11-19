"""Validate this review's artifact integrity, not the correctness of RVC."""
from collections import Counter
from datetime import datetime, timedelta, timezone
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[4]
RUN = Path(__file__).resolve().parents[1]
findings = json.loads((RUN / 'bmad/findings.json').read_text(encoding='utf-8'))
errors = []
required = {'id', 'lens', 'location', 'trigger_condition', 'guard_snippet', 'potential_consequence'}
for finding in findings:
    if not required <= finding.keys():
        errors.append('missing fields: ' + str(finding))
    for path, loc in re.findall(r'((?:artifacts|docs)/[^:;\s]+\.md):([\d,\-]+)', finding['location']):
        file = ROOT / path
        if not file.exists():
            errors.append('missing citation file: ' + path)
            continue
        count = len(file.read_text(encoding='utf-8-sig').splitlines())
        if any(not 1 <= int(n) <= count for n in re.findall(r'\d+', loc)):
            errors.append('out of range citation: ' + path + ':' + loc)
counts = Counter(f['lens'] for f in findings)
if counts != {'adversarial': 6, 'edge-case-hunter': 2, 'sasd': 4}:
    errors.append('unexpected lens counts')
if len({f['id'] for f in findings}) != len(findings):
    errors.append('duplicate IDs')
files = [ROOT / 'QA.md', ROOT / 'README.md', *sorted(RUN.rglob('*.md'))]
out = RUN / 'verification/output-checks.json'
out.write_text('{"status":"checking"}', encoding='utf-8')
for file in files:
    if file.name == 'review-input.md':
        continue  # Archived source content, not authored report links.
    text = file.read_text(encoding='utf-8-sig')
    for target in re.findall(r'(?<!!)\[[^\]]*\]\(([^)]+)\)', text):
        if '://' in target or target.startswith('#'):
            continue
        target = target.split('#', 1)[0]
        if not (file.parent / target).exists():
            errors.append('missing link: ' + str(file.relative_to(ROOT)) + ': ' + target)
    if '\ufffd' in text:
        errors.append('replacement character: ' + str(file))
manifest = json.loads((RUN / 'bmad/input-manifest.json').read_text(encoding='utf-8'))
for item in manifest['inputs']:
    if hashlib.sha256((ROOT / item['path']).read_bytes()).hexdigest() != item['sha256']:
        errors.append('input changed: ' + item['path'])
result = {
    'checked_at': datetime.now(timezone(timedelta(hours=9))).isoformat(),
    'scope': 'Review file integrity, links, citation ranges and unchanged input hashes only',
    'canonical_findings': len(findings), 'lens_counts': dict(counts),
    'input_files': len(manifest['inputs']), 'errors': errors,
}
out.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(result, ensure_ascii=False, indent=2))
raise SystemExit(bool(errors))
