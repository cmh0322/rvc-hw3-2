from pathlib import Path
from datetime import datetime,timezone,timedelta
import os,json,re,subprocess,shutil
RUN=Path(__file__).resolve().parents[1];ROOT=RUN.parents[2]
cache=(ROOT/'build/CMakeCache.txt').read_text(encoding='utf-8')
cc=Path(re.search(r'CMAKE_C_COMPILER:FILEPATH=(.+)',cache)[1].strip())
assert cc.exists()
env=dict(os.environ);env['PATH']=str(cc.parent)+os.pathsep+env['PATH']
env['RVC_SCENARIO_OUT']=str(RUN/'system/scenarios')
records=[]
for name,args in [('gcc-version',[str(cc),'--version']),('cmake-version',['cmake','--version']),('node-version',['node','--version']),('build',['cmake','--build','build']),('ctest',['ctest','--test-dir','build','--output-on-failure']),('coverage',['cmake','--build','build','--target','coverage']),('simulator-build',['cmake','--build','build','--target','rvc_sim_host']),('scenarios',['node','simulator/run_scenarios.js'])]:
 started=datetime.now(timezone(timedelta(hours=9))).isoformat()
 p=subprocess.run(args,cwd=ROOT,env=env,capture_output=True,text=True,encoding='utf-8',errors='replace')
 (RUN/'verification'/f'{name}.log').write_text(p.stdout+p.stderr,encoding='utf-8')
 records.append({'name':name,'args':args,'started_at':started,'exit_code':p.returncode})
 (RUN/'verification/commands.json').write_text(json.dumps(records,ensure_ascii=False,indent=2),encoding='utf-8')
 print(name,p.returncode,flush=True)
 assert p.returncode==0,p.stdout[-2000:]+p.stderr[-2000:]
shutil.copyfile(ROOT/'build/coverage/summary.md',RUN/'verification/coverage-summary.md')
shutil.copyfile(ROOT/'build/Testing/Temporary/LastTest.log',RUN/'verification/LastTest.log')
