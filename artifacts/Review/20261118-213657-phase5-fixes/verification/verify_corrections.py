from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json,re,subprocess
ROOT=Path(__file__).resolve().parents[4];RUN=Path(__file__).resolve().parents[1]
def read(p):
 b=p.read_bytes();return b.decode('utf-16' if b.startswith(b'\xff\xfe') else 'utf-8-sig')
baseline=json.loads(read(RUN/'baseline.json'))
protected=[e for e in baseline['inputs'] if e['path'].startswith(('artifacts/SA/','artifacts/SD/'))]
for e in protected:assert hashlib.sha256((ROOT/e['path']).read_bytes()).hexdigest()==e['sha256'],e['path']
sc=read(ROOT/'artifacts/SD/structure_chart.md')
block=sc.split('## 5. Module interfaces',1)[1].split('### 5.1',1)[0]
snake=lambda s:re.sub('[^a-z0-9]+','_',s.lower()).strip('_')
approved=set()
for line in block.splitlines():
 if line.startswith('| ') and not line.startswith('| Caller'):
  columns=[v.strip() for v in line.split('|')[1:-1]]
  approved.add((snake(columns[0]),snake(columns[1])))
expected={tuple(l.split()) for l in read(ROOT/'tests/expected_calls.txt').splitlines() if l and not l.startswith('#')}
assert len(approved)==31 and approved==expected
coverage=read(RUN/'verification/coverage-summary.md');assert '**140 / 140 (100.0%)**' in coverage and '**62 / 62 (100.0%)**' in coverage
ctest=read(RUN/'verification/ctest.log');assert '0 tests failed out of 121' in ctest and 'call_hierarchy' in ctest
red=read(RUN/'verification/red.log');assert '4 FAILED TESTS' in red
traces=[]
for p in sorted((RUN/'verification/scenarios/traces').glob('*.json')):
 data=json.loads(read(p));h=data['history'];assert len(h)==101
 assert h[0]['direction'] is None and h[0]['clean'] is None
 for index,row in enumerate(h):assert row['tick']==index
 for row in h[1:]:
  assert row['direction'] is not None and row['clean'] is not None
  assert (row['clean']=='Stop')==(row['state']!='Forward')
 traces.append(data)
assert len(traces)==21
st14=next(t['history'] for t in traces if t['scenario']['id']=='ST-14')
assert all(st14[t]['clean']=='Power Up' for t in range(14,19))
web=json.loads(read(RUN/'verification/web-results.json'));assert len(web['checks'])==4 and not web['errors']
diff=subprocess.run(['git','diff','--check'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/diff-check.log').write_text(diff.stdout+diff.stderr,encoding='utf-8');assert diff.returncode==0
inputs=[]
for folder in ['src','include','tests','simulator']:
 for p in sorted((ROOT/folder).rglob('*')):
  if p.is_file():inputs.append({'path':p.relative_to(ROOT).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
(RUN/'final-inputs.json').write_text(json.dumps(inputs,ensure_ascii=False,indent=2),encoding='utf-8')
result={'checked_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'SA_SD_unchanged':len(protected),
 'approved_SD_calls':31,'ctest_entries_passed':121,'GoogleTest_cases':120,'red_regressions_failed_before_fix':4,
 'C_lines':'140/140','C_branch_outcomes':'62/62','headless_scenarios':21,'ticks_per_scenario':100,
 'browser_API_checks':len(web['checks']),'browser_errors':web['errors'],'git_diff_check_exit':0,
 'SPIN':'notRun; movement transition/timing logic unchanged, all existing boundary tests executed',
 'human_system_evaluation':'pending; no human verdict submitted','commit_push':'notPerformed'}
(RUN/'verification/results.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
