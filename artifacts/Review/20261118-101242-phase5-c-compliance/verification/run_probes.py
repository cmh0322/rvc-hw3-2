from pathlib import Path
from datetime import datetime, timezone, timedelta
import json, subprocess, os, re

RUN=Path(__file__).resolve().parents[1];ROOT=RUN.parents[2];OUT=RUN/'verification'
compiler_dir=Path('D:/MSYS2/mingw64/bin')
env=dict(os.environ);env['PATH']=str(compiler_dir)+os.pathsep+env['PATH']
commands=[]
def execute(args,name):
    args=[a.relative_to(ROOT) if isinstance(a,Path) and a.is_relative_to(ROOT) else a for a in args]
    p=subprocess.run([str(a) for a in args],cwd=ROOT,env=env,capture_output=True,text=True,encoding='utf-8',errors='replace')
    (OUT/(name+'.log')).write_text(p.stdout+p.stderr,encoding='utf-8')
    commands.append({'name':name,'args':[str(a) for a in args],'exit_code':p.returncode})
    return p
cc=compiler_dir/'gcc.exe'
version=execute([cc,'--version'],'gcc-version');assert version.returncode==0
flags=['-std=c11','-Wall','-Wextra','-Wpedantic','-Werror','-Iinclude']
p=execute([cc,*flags,'-Dmain=rvc_audit_main','-c','src/main.c','-o',OUT/'audit_main.o'],'probe-main-compile');assert p.returncode==0,p.stderr
sources=sorted(p for p in (ROOT/'src').glob('*.c') if p.name!='main.c')
p=execute([cc,*flags,OUT/'compliance_probe.c',OUT/'audit_main.o',*sources,'-o',OUT/'compliance_probe.exe'],'probe-link');assert p.returncode==0,p.stderr
p=execute([OUT/'compliance_probe.exe'],'compliance-probe');assert p.returncode==1
rows=[json.loads(line) for line in p.stdout.splitlines()]
assert len(rows)==10 and sum(not r['passes'] for r in rows)==6,rows
design=json.loads((ROOT/'artifacts/Review/20261118-095720-phase4-fixes/verification/design-contract.json').read_text(encoding='utf-8'))
snake=lambda s:'main' if s=='Main' else re.sub('[^a-z0-9]+','_',s.lower()).strip('_')
calls=sorted((snake(r['caller']),snake(r['callee'])) for r in design['calls'])
(OUT/'approved_expected_calls.txt').write_text('\n'.join(f'{a} {b}' for a,b in calls)+'\n',encoding='utf-8')
p=execute(['cmake',f'-DOBJECT_DIR={ROOT.as_posix()}/build/CMakeFiles',f'-DEXPECTED={OUT.as_posix()}/approved_expected_calls.txt','-P','tests/check_call_hierarchy.cmake'],'approved-call-hierarchy');assert p.returncode!=0
actual=set()
for group in ['rvc_control','rvc_main']:
    for path in (ROOT/'build/CMakeFiles'/f'{group}.dir').rglob('*.ci'):
        for a,b in re.findall(r'edge:.*?sourcename: "([A-Za-z0-9_]+)" targetname: "([A-Za-z0-9_]+)"',path.read_text(encoding='utf-8',errors='replace')):
            if not b.startswith('__'):actual.add((a,b))
expected=set(calls)
result={'executed_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'commands':commands,'checks':rows,'passed':4,'failed':6,'interpretation':'Unchanged code contradicts six assertions across C12/C13/C15; controls pass. No fix applied. Observed sensor pulse probe exercises detect_dust directly; production main lacks asynchronous dispatch entirely. This is not a browser/system test.','calls':{'approved':len(expected),'compiled':len(actual),'missing':sorted(expected-actual),'unexpected':sorted(actual-expected)}}
(OUT/'probe-results.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
