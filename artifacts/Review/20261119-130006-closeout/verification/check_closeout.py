from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,re,hashlib,subprocess
ROOT=Path(__file__).resolve().parents[4];RUN=Path(__file__).resolve().parents[1]
def read(p):return p.read_text(encoding='utf-8-sig')
def load(p):return json.loads(read(p))
def dump(p,v):p.write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
allowed=['artifacts/SA/DFD/dfd_level_3.md','artifacts/SA/process_specification.md']
baseline=load(ROOT/'artifacts/Review/20261119-115842-phase6-final/baseline.json')
changed=[e['path'] for e in baseline['inputs'] if hashlib.sha256((ROOT/e['path']).read_bytes()).hexdigest()!=e['sha256']]
assert sorted(changed)==allowed,changed
pspec=read(ROOT/allowed[1]);before=read(RUN/'before/process_specification.md')
old='- B2, B3, B4, C1, C2, C4, C5, C6, C7, C8, C9, C16'
new='- B2, B3, B4, C1, C2, C4, C5, C6, C7, C8, C9, C12, C13, C16'
assert before.count(old)==1 and before.replace(old,new)==pspec
dfd=read(ROOT/allowed[0]);old_dfd=read(RUN/'before/dfd_level_3.md')
old='| 3.2.1 | Signal Obstacle Situation | Data | Converts the Obstacle Situation data from 3.1 into a Situation Signal control flow for the Controller. | B3, B4, C1 |'
assert old_dfd.replace(old,old.replace('B3, B4, C1 |','B3, B4, C1, C9 |'))==dfd
assert re.findall(r'```mermaid(.*?)```',dfd,re.S)==re.findall(r'```mermaid(.*?)```',old_dfd,re.S)
section=pspec.split('## Process 3.2.2:',1)[1].split('## Process 3.2.3:',1)[0]
assert 'Initial sensor sampling precedes the first Tick (C12)' in section and 'without output (C13)' in section
assert 'Front Blocked + Side Situation; C9' in pspec
evals=load(RUN/'system/evaluations.json');summary=load(RUN/'system/browser-summary.json')
assert len(evals)==21 and summary['pass']==21 and summary['fail']==0 and not summary['page_errors']
for row in evals:
 assert row['evaluator']=='Codex' and row['human_approval']=='pending'
 saved=load(ROOT/row['saved']);assert saved['ticks_executed']==100 and saved['result']==row['result']
 assert saved['evaluator'].startswith('Codex') and 'human approval pending' in saved['evaluator']
 assert len(saved['history'])==101
ledger=load(ROOT/'artifacts/Review/20261119-115842-phase6-final/verification/finding-ledger.json')
for row in ledger:
 if row['id']=='P2-I01':row.update(status='resolved',reason='C12/C13 added to PSPEC3.2.2 summary and C9 to DFD3 P3.2.1 summary; body/diagrams/behavior unchanged.',evidence=[{'path':allowed[1],'start':538,'end':538},{'path':allowed[0],'start':55,'end':55}])
dump(RUN/'verification/finding-ledger.json',ledger)
diff=subprocess.run(['git','diff','--check'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/diff-check.log').write_text(diff.stdout+diff.stderr,encoding='utf-8');assert diff.returncode==0
result={'checked_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'changed_baseline_inputs':changed,'unchanged_other_inputs':len(baseline['inputs'])-2,'exact_reference_only_edits':2,'diagrams_unchanged':True,'P2-I01':'resolved','scenario_evaluations':21,'agent_PASS':21,'agent_FAIL':0,'ticks_via_UI_each':100,'scenario_specific_prefix_ticks':sum(row['prefixChecks'] for row in evals),'basic_invariant_ticks':2100,'evaluator':'Codex (automated-agent)','human_approval':'pending','git_diff_check':0,'C_tests':'notRerun; production/tests unchanged vs Phase6','SPIN':'notRerun; only summary references changed'}
dump(RUN/'verification/results.json',result);print(json.dumps(result,ensure_ascii=False,indent=2))
