from pathlib import Path
import json,re
ROOT=Path(__file__).resolve().parents[4];RUN=Path(__file__).resolve().parents[1]
paths=[ROOT/'QA.md',ROOT/'README.md',ROOT/'artifacts/SystemTest/test_results.md',RUN/'verification/report.md']
links=0
for path in paths:
 text=path.read_text(encoding='utf-8')
 for target in re.findall(r'\]\(([^)]+)\)',text):
  if '://' in target or target.startswith('#'):continue
  assert (path.parent/target.split('#',1)[0]).exists(),(str(path),target)
  links+=1
ledger=json.loads((RUN/'verification/finding-ledger.json').read_text(encoding='utf-8'))
assert len(ledger)==24 and sum(r['status'].startswith('resolved') for r in ledger)==23
assert not any(r['status']=='open-optional' for r in ledger)
(RUN/'verification/output-checks.json').write_text(json.dumps({'existing_relative_links':links,'resolved_canonical_items':23,'not_a_defect':1,'human_final_approval':'pending'},indent=2),encoding='utf-8')
print({'links':links,'resolved':23,'not_a_defect':1,'approval':'pending'})
