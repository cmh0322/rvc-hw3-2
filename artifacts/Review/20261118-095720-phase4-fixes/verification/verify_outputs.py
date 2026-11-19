"""Check final review records against their cited inputs and structural evidence."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
from collections import Counter
import hashlib
import json
import re
import subprocess
import sys

RUN = Path(__file__).resolve().parents[1]
ROOT = RUN.parents[2]

def read(path):
    return path.read_text(encoding='utf-8-sig')

def load(path):
    return json.loads(read(path))

def check_ref(ref):
    lines = read(ROOT / ref['path']).splitlines()
    assert 1 <= ref['start'] <= ref['end'] <= len(lines), ref

check = subprocess.run([sys.executable, str(RUN / 'verification/check_documents.py')],
                       cwd=ROOT, capture_output=True, text=True, encoding='utf-8')
(RUN / 'verification/document-checks.log').write_text(check.stdout + check.stderr, encoding='utf-8')
assert check.returncode == 0, check.stderr
matrix = load(RUN / 'traceability/matrix.json')
assert {row['id'] for row in matrix} == {f'B{i}' for i in range(1, 8)} | {f'C{i}' for i in range(1, 17)}
assert len(matrix) == 23
counts = Counter(row['SD_status'] for row in matrix)
assert counts['mapped'] == 20 and sum(counts.values()) == 23, counts
assert {row['id'] for row in matrix if row['SD_status'] != 'mapped'} == {'B6', 'B7', 'C4'}
for row in matrix:
    check_ref(row['source'])
    for ref in row['evidence']:
        check_ref(ref)
    assert row['human_approval'] == 'pending'
    assert row['executed_tests'] == 'notRun' and row['C_symbols'] == 'notChecked'
resolutions = load(RUN / 'verification/resolutions.json')
assert {row['id'] for row in resolutions} == {f'P4-{i:02}' for i in range(1, 7)}
for row in resolutions:
    assert row['status'] == 'resolved-in-documents'
    assert row['implementation_status'] == 'notChecked' and row['human_SD_approval'] == 'pending'
    for ref in row['evidence']:
        check_ref(ref)
lenses = load(RUN / 'bmad/lens-results.json')
assert len(lenses) == 3
assert {row['lens'] for row in lenses} == {'adversarial', 'edge-case-hunter', 'sasd'}
assert all(row['status'] == 'completed' and row['findings'] == [] for row in lenses)
assert load(RUN / 'bmad/findings.json') == []
inputs = load(RUN / 'input-manifest.json')['inputs']
for entry in inputs:
    assert hashlib.sha256((ROOT / entry['path']).read_bytes()).hexdigest() == entry['sha256'], entry['path']
checked_links = 0
for path in [ROOT / 'QA.md', ROOT / 'README.md', *RUN.rglob('report.md'), RUN / 'traceability/matrix.md']:
    for target in re.findall(r'\]\(([^)]+)\)', read(path)):
        if '://' in target or target.startswith('#'):
            continue
        target = target.split('#', 1)[0]
        assert (path.parent / target).exists(), (str(path), target)
        checked_links += 1
delta = load(RUN / 'verification/legacy-call-delta.json')
assert delta['legacy_only'] and delta['revised_design_only']
result = {
    'executed_at': datetime.now(timezone(timedelta(hours=9))).isoformat(),
    'document_structure_check_exit': check.returncode,
    'requirement_rows': len(matrix), 'SD_status_counts': dict(counts),
    'resolved_document_findings': len(resolutions), 'completed_independent_lenses': len(lenses),
    'review_inputs_unchanged': len(inputs), 'existing_relative_links': checked_links,
    'C_tests': 'notRun', 'SPIN': 'notRun', 'web_simulator': 'notRun',
    'human_SD_approval': 'pending',
    'scope': 'Review record completeness, references, input hashes and document structure only.'
}
(RUN / 'verification/output-checks.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(result, ensure_ascii=False, indent=2))
