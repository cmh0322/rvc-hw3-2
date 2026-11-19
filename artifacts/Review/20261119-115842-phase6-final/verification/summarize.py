from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,re,hashlib,subprocess
RUN=Path(__file__).resolve().parents[1];ROOT=RUN.parents[2]
def read(p):
 b=p.read_bytes();return b.decode('utf-16' if b.startswith(b'\xff\xfe') else 'utf-8-sig')
def load(p):return json.loads(read(p))
def dump(p,v):p.write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
def loc(path,needle):
 lines=read(ROOT/path).splitlines();i=next(i for i,s in enumerate(lines,1) if needle in s)
 return {'path':path,'start':i,'end':i}
baseline=load(RUN/'baseline.json')
for entry in baseline['inputs']:
 assert hashlib.sha256((ROOT/entry['path']).read_bytes()).hexdigest()==entry['sha256'],entry['path']
commands=load(RUN/'verification/commands.json');assert all(c['exit_code']==0 for c in commands)
ctest=read(RUN/'verification/ctest.log')
m=re.search(r'100% tests passed, 0 tests failed out of (\d+)',ctest);assert m
test_count=int(m[1]);assert re.search(r'call_hierarchy[^\n]*Passed',ctest)
last=(RUN/'verification/LastTest.log').read_bytes().decode('utf-8',errors='replace');assert '31 of 31 calls' in last
coverage=read(RUN/'verification/coverage-summary.md')
total=next(l for l in coverage.splitlines() if '**Total**' in l)
sc=read(ROOT/'artifacts/SD/structure_chart.md')
table=sc.split('## 5. Module interfaces',1)[1].split('### 5.1',1)[0]
snake=lambda s:re.sub('[^a-z0-9]+','_',s.lower()).strip('_')
approved=set()
for l in table.splitlines():
 if l.startswith('| ') and not l.startswith('| Caller'):
  cols=[c.strip() for c in l.split('|')[1:-1]];approved.add((snake(cols[0]),snake(cols[1])))
actual_expected={tuple(l.split()) for l in read(ROOT/'tests/expected_calls.txt').splitlines() if l and not l.startswith('#')}
assert approved==actual_expected and len(approved)==31
negative=RUN/'verification/negative_expected_calls.txt'
negative.write_text('\n'.join(' '.join(e) for e in sorted(approved)[1:])+'\n',encoding='utf-8')
p=subprocess.run(['cmake',f'-DOBJECT_DIR={ROOT.as_posix()}/build/CMakeFiles',f'-DEXPECTED={negative.as_posix()}','-P','tests/check_call_hierarchy.cmake'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8',errors='replace')
(RUN/'verification/call-check-negative.log').write_text(p.stdout+p.stderr,encoding='utf-8');assert p.returncode!=0 and 'Call hierarchy differs' in p.stderr
negative_exit=p.returncode
web=load(RUN/'system/web-results.json');browser_scenarios=load(RUN/'system/browser-scenarios.json')
assert len(web['checks'])==5 and web['errors']==[] and len(browser_scenarios)==21
traces=[]
for p in sorted((RUN/'system/scenarios/traces').glob('*.json')):
 d=load(p);h=d['history'];assert len(h)==101 and h[0]['direction'] is None and h[0]['clean'] is None
 for tick,row in enumerate(h):
  assert row['tick']==tick
  if tick:assert (row['state']=='Forward') == (row['clean']!='Stop')
 traces.append(d)
assert len(traces)==21
phase3=load(ROOT/'artifacts/Review/20261118-090810-phase3-fsm/input-manifest.json')
model_inputs=[e for e in phase3['inputs'] if e['path'].startswith(('artifacts/SA/','docs/preliminary_requirements','docs/requirements_clarifications'))]
assert model_inputs
for e in model_inputs:assert hashlib.sha256((ROOT/e['path']).read_bytes()).hexdigest()==e['sha256'],e['path']
red=read(ROOT/'artifacts/Review/20261118-213657-phase5-fixes/verification/red.log');assert '4 FAILED TESTS' in red
ledger=[]
def add(identifier,status,reason,evidence):ledger.append({'id':identifier,'status':status,'reason':reason,'evidence':evidence})
p1=[('C9 record and sides-only postback',loc('artifacts/SA/process_specification.md','only the Side Situation decides')),('C10/C11/C15 resolved question propagation',loc('artifacts/SA/DFD/dfd_level_2.md','Q1-Q5 are resolved')),('D3 initial0',loc('src/power_up_timer.c','remaining_power_up_ticks = 0')),('C12 readiness',loc('src/input_events.c','while (!inputs_ready())')),('C13 no initial output',loc('src/initialize_rvc.c','acquire_initial_inputs();')),('C14 abstract cleaner meaning',loc('include/hw_interface.h','C14:')),('C15 pending OR',loc('src/sensor_store.c','dust.pending = dust.pending || value'))]
for i,(reason,evidence) in enumerate(p1,1):add(f'P1-{i:02}','resolved',reason,[evidence])
add('R1-SASD-01','resolved','Pending Dust flow crosses P4 but is internal to P0; corrected balancing text retained.',[loc('artifacts/SA/DFD/dfd_level_2.md',"Pending Dust Detection crosses Process 4's boundary")])
add('P2-A01','resolved-by-owner','Q6 resolved by C16; Forward entry uses only front.',[loc('docs/requirements_clarifications.md','| C16 |'),loc('src/movement_controller.c','if (situation_signal.front_blocked)')])
add('P2-I01','open-optional','PSPEC 3.2.2 relevant requirements summary omits C12/C13 and Level3 3.2.1 summary C9; behavior exists in body. No source correction authorized by Phase6 verify-only.',[loc('artifacts/SA/process_specification.md','Initial sensor sampling precedes'),loc('artifacts/SA/DFD/dfd_level_3.md','3.2.1')])
add('P3-D01','resolved','Initial-output mismatch resolved through P4-01/P5-01.',[loc('src/initialize_rvc.c','reset_movement_controller();')])
add('P3-N01','not-a-defect','Unconditional eventual Forward is unsupported; repeated Backing allowed under C5/C9.',[loc('docs/requirements_clarifications.md','| C5 |')])
for row in load(ROOT/'artifacts/Review/20261118-095720-phase4-fixes/verification/resolutions.json'):
 add(row['id'],'resolved',row['title']+'; SD corrected and later owner approved; C propagation checked below.',row['evidence'])
evidences=[['src/initialize_rvc.c','acquire_initial_inputs();'],['src/input_events.c','while (!inputs_ready())'],['src/power_up_timer.c','if (dust.current || dust.pending)'],['src/main.c','dispatch_input_event(receive_input_event(INPUT_RUNNING))'],['tests/test_main.cpp','ReceiptOrderBeforeAndAfterTickIsRespected'],['tests/test_requirements.cpp','C16_SideObstaclesAloneDoNotTriggerAvoidance']]
for row,(path,needle) in zip(load(ROOT/'artifacts/Review/20261118-101242-phase5-c-compliance/c-compliance/findings.json'),evidences):
 add(row['id'],'resolved',row['title']+'; current source and fresh tests/web/call graph inspected.',[loc(path,needle)])
assert len(ledger)==24
dump(RUN/'verification/finding-ledger.json',ledger)
lines=['# Consolidated finding ledger','','Historical findings remain unchanged in their original run directories. These are current source/evidence dispositions, not additional independent reviewer verdicts. Canonical IDs avoid counting repeated observations as independent defects.','','| ID | Current status | Evidence/reason |','|---|---|---|']
for e in ledger:lines.append(f"| {e['id']} | {e['status']} | {e['reason']} "+'; '.join(f"`{r['path']}:{r['start']}`" for r in e['evidence'])+' |')
lines+=['','Phase1 raw aliases: ADV-01/SASD-01→P1-01; ADV-02/SASD-02→P1-02; ADV-03/EDGE-02/SASD-03→P1-03; ADV-03/EDGE-01/SASD-04→P1-04; ADV-04→P1-05; ADV-05→P1-06; ADV-06→P1-07. Phase4 raw lens observations were triaged into P4-01–06; original JSON is preserved.','']
(RUN/'verification/finding-ledger.md').write_text('\n'.join(lines),encoding='utf-8')
for row in ledger:
 for ref in row['evidence']:
  assert 1<=ref['start']<=ref['end']<=len(read(ROOT/ref['path']).splitlines())
checked_links=0
for path in [ROOT/'QA.md',ROOT/'README.md',RUN/'verification/report.md',RUN/'system/human-evaluation.md']:
 for target in re.findall(r'\]\(([^)]+)\)',read(path)):
  if '://' in target or target.startswith('#'):continue
  assert (path.parent/target.split('#',1)[0]).exists(),(str(path),target)
  checked_links+=1
dump(RUN/'verification/output-checks.json',{'checked_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'existing_relative_links':checked_links,'ledger_reference_rows':len(ledger),'report_exists':True})
diff=subprocess.run(['git','diff','--check'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/diff-check.log').write_text(diff.stdout+diff.stderr,encoding='utf-8');assert diff.returncode==0
result={'checked_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'inputs_unchanged':len(baseline['inputs']),'ctest_entries':test_count,'google_test_cases':test_count-1,'call_graph':31,'call_checker_negative_exit':negative_exit,'coverage_total':total,'headless_scenarios':21,'ticks_per_scenario':100,'browser_scenarios_first_tick':21,'browser_regression_groups':len(web['checks']),'browser_errors':web['errors'],'canonical_findings':len(ledger),'resolved':sum(e['status'].startswith('resolved') for e in ledger),'optional_open':['P2-I01'],'not_a_defect':['P3-N01'],'new_mandatory_defects':[],'historical_SPIN_inputs_unchanged':len(model_inputs),'SPIN':'notRun-in-Phase6; historical Phase3 model results only','human_evaluation':'pending','source_changes':False,'git_diff_check':0}
dump(RUN/'verification/results.json',result)
print(json.dumps(result,ensure_ascii=False,indent=2))
