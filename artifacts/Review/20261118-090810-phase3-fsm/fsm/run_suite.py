"""Execute independent finite-model checks, preserving raw evidence per check."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
import os, sys, subprocess, json, hashlib, shutil

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
SCRATCH=Path(os.environ['LOCALAPPDATA'])/'Temp'/'rvc-phase3-20261118-090810'
HELPER=ROOT/'.agents/skills/rvc-fsm-verify/scripts/run_spin.py'
CC='D:/MSYS2/mingw64/bin/cc.exe'
source=(HERE/'model.pml').read_text(encoding='utf-8')
variants=HERE/'variants'
variants.mkdir(exist_ok=True)
jobs=[]
def add(name, content, category, expected, ltl=None):
    path=variants/(name+'.pml')
    path.write_text(content,encoding='utf-8')
    jobs.append((name,path,category,expected,ltl))

add('robust-unconstrained-front',source.replace('#define ENV_STOP_FRONT 1','#define ENV_STOP_FRONT 0'),'safety','passed')
claims={
 'stop_progress':'[] ((stable && state == Stopping) -> <> (stable && state != Stopping))',
 'turn_progress':'[] ((stable && (state == TurningRight || state == TurningLeft)) -> <> (stable && state == Forward))',
 'unconditional_forward':'[] <> (stable && state == Forward)',
}
for name, formula in claims.items():
    add(name,source+f'\nltl {name} {{ {formula} }}\n','negative-experiment' if name=='unconditional_forward' else 'liveness','failed' if name=='unconditional_forward' else 'passed',name)
for i in range(15):
    add(f'reach-T{i:02}',source.replace('#define PROBE_T 255',f'#define PROBE_T {i}'),'transition-witness','failed')
for state in ['Forward','Stopping','Backing','TurningRight','TurningLeft']:
    add('reach-'+state,source.replace('#define PROBE_STATE 0',f'#define PROBE_STATE {state}'),'state-witness','failed')
mutations={
 'timer-early':('elapsed == 5 -> done','elapsed == 4 -> done'),
 'c9-front-dependent':('take(9, TurningRight, TurnRight, true)','if :: !front -> take(9, Forward, GoForward, false) :: front -> take(9, TurningRight, TurnRight, true) fi'),
 'c16-side-avoidance':('take(1, Forward, GoForward, false)','if :: left || right -> take(1, Stopping, Stop, true) :: !left && !right -> take(1, Forward, GoForward, false) fi'),
 'c13-initial-output':('state = Forward;\n        previous = Forward;','state = Forward;\n        command = GoForward;\n        previous = Forward;'),
}
for name,(old,new) in mutations.items():
    assert source.count(old)==1,(name,source.count(old))
    add('mutant-'+name,source.replace(old,new),'monitor-sensitivity','failed')

def archive(name, out):
    dest=HERE/'checks'/name
    dest.mkdir(parents=True,exist_ok=True)
    for p in out.iterdir():
        if p.is_file() and (p.suffix in ['.pml','.json','.log','.trail']):
            shutil.copyfile(p,dest/p.name)
    return dest

def execute(job):
    name,path,category,expected,ltl=job
    out=SCRATCH/name
    cmd=[sys.executable,str(HELPER),'--model',str(path),'--out',str(out),'--cc',CC]
    if ltl: cmd+=['--ltl',ltl]
    proc=subprocess.run(cmd,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=180)
    if not (out/'result.json').is_file():
        raise RuntimeError(proc.stdout.decode('utf-8',errors='replace'))
    dest=archive(name,out)
    (dest/'runner.log').write_bytes(proc.stdout)
    result=json.loads((out/'result.json').read_text(encoding='utf-8'))
    result.update(name=name,category=category,expected_status=expected,runner_exit=proc.returncode)
    result['expectation_met']=result['status']==expected and (expected=='passed' or result.get('replay_ok',False))
    print(f"{name}: {result['status']}, errors={result.get('errors')}, expected={expected}, replay={result.get('replay_ok','n/a')}",flush=True)
    return result

existing=SCRATCH/'safety'
safe=json.loads((existing/'result.json').read_text(encoding='utf-8'))
assert safe['model_sha256']==hashlib.sha256(source.encode('utf-8')).hexdigest()
archive('safety-final',existing)
safe.update(name='safety-final',category='safety',expected_status='passed',expectation_met=safe['status']=='passed')
results=[safe]
with ThreadPoolExecutor(max_workers=3) as executor:
    futures=[executor.submit(execute,job) for job in jobs]
    for future in as_completed(futures): results.append(future.result())
results.sort(key=lambda r:r['name'])
(HERE/'suite-results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8')
assert all(r['expectation_met'] for r in results), 'Unexpected result; inspect suite-results.json'
print(f'Expected outcomes observed for {len(results)} checks. Witnesses/mutants/negative experiments are not safety passes.',flush=True)
