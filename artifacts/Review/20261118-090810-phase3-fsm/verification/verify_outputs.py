"""Fresh evidence checks for Phase 3; does not execute production tests."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
import hashlib,json,re,subprocess
RUN=Path(__file__).resolve().parents[1]
ROOT=RUN.parents[2]
FSM=RUN/'fsm'
def read(p): return p.read_text(encoding='utf-8-sig')
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads(read(RUN/'input-manifest.json'))
for item in manifest['inputs']+manifest['protected']:
    assert sha(ROOT/item['path'])==item['sha256'],item['path']
model=read(FSM/'model.pml')
model_lines=model.splitlines()
spec=ROOT/'artifacts/SA/DFD/dfd_level_4_fsm.md'
rows=[]
for no,line in enumerate(read(spec).splitlines(),1):
    if re.match(r'^\| T\d+ \|',line): rows.append((no,[x.strip() for x in line.split('|')[1:-1]]))
assert len(rows)==15
guards={'not Front Blocked':'!front','Front Blocked':'front','not Step Done':'!done','Step Done':'done','Step Done and Right Open':'done && side == RightOpen','Step Done and Left Open':'done && side == LeftOpen','Step Done and Sides Blocked':'done && side == SidesBlocked'}
outputs={'Forward':'GoForward','Stop':'Stop','Backward':'GoBackward','Turn Right':'TurnRight','Turn Left':'TurnLeft'}
mapping=[]
for no,cells in rows:
    tid,old,event,condition,action,new,source=cells
    if tid=='T0':
        matches=[i for i,s in enumerate(model_lines,1) if 'state = Forward;' in s]
    else:
        number=tid[1:]
        expected_guard=f'previous == {old} && {guards[condition]}'
        action_parts=action.split(', ')
        expected=f':: {expected_guard} -> take({number}, {new}, {outputs[action_parts[0]]}, {"true" if "Start Step Timer" in action_parts else "false"})'
        matches=[i for i,s in enumerate(model_lines,1) if s.strip()==expected]
    assert len(matches)==1,(tid,matches)
    mapping.append({'id':tid,'source_line':no,'model_line':matches[0],'from':old,'guard':condition,'action':action,'to':new,'requirements':source})
(FSM/'transition-map.json').write_text(json.dumps(mapping,ensure_ascii=False,indent=2),encoding='utf-8')
results=json.loads(read(FSM/'suite-results.json'))
assert len(results)==29
expected_categories={'safety':2,'liveness':2,'transition-witness':15,'state-witness':5,'monitor-sensitivity':4,'negative-experiment':1}
counts={k:len([r for r in results if r['category']==k]) for k in expected_categories}
assert counts==expected_categories,counts
for r in results:
    d=FSM/'checks'/r['name']
    assert r['expectation_met'],r['name']
    assert sha(d/'model.pml')==r['model_sha256'],r['name']
    search=read(d/'search.log')
    assert 'Full statespace search' in search
    assert not re.search('max search depth too small|out of memory',search,re.I)
    if r['category'] in ['safety','liveness']:
        assert 'search not completed' not in search.lower()
        assert r['errors']==0 and r['status']=='passed'
    else:
        assert r['errors']==1 and r['replay_ok']
        replay=read(d/'replay.log')
        assert (d/'model.pml.trail').exists()
        if r['category']=='transition-witness':
            num=int(r['name'].split('T')[-1])
            expected='INIT T0' if num==0 else f'T{num} prev='
            assert any(s.strip().startswith(expected) for s in replay.splitlines())
            assert 'assertion violated (transition!=' in search, r['name']
        elif r['category']=='state-witness':
            state=r['name'][6:]
            assert re.search(r'(?m)^\s*(INIT T0|T\d+ prev=).*state='+state+r'\b',replay)
            assert 'assertion violated (state!=' in search,r['name']
        elif r['category']=='negative-experiment':
            assert 'acceptance cycle' in search
            assert 'START OF CYCLE' in replay and 'T8 prev=Backing' in replay
        else:
            assert 'assertion violated' in search
    if (d/'replay.log').exists():
        summary=[s.strip() for s in read(d/'replay.log').splitlines() if re.match(r'^\s*(INIT T0|T\d+ prev=|<<<<<START)',s)]
        (d/'tick-trace.txt').write_text('\n'.join(summary)+'\n',encoding='utf-8')
diff=subprocess.run(['git','diff','--check'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/diff-check.log').write_text(diff.stdout+diff.stderr,encoding='utf-8')
assert diff.returncode==0
report={'executed_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'source_transition_mapping':15,'categories':counts,'all_expected_results_and_replays_checked':True,'protected_files_unchanged':len(manifest['protected']),'source_inputs_unchanged':len(manifest['inputs']),'model_sha256':sha(FSM/'model.pml'),'git_diff_check_exit':0,'C_tests':'notRun','coverage':'notMeasured','web_simulator':'notRun','SD_C_compliance':'notChecked'}
(RUN/'verification/output-checks.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(report,ensure_ascii=False,indent=2))
