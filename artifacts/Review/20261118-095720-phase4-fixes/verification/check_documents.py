"""Verify revised SD structure, source preservation and review evidence."""
from pathlib import Path
from datetime import datetime,timezone,timedelta
import hashlib,json,re,subprocess
RUN=Path(__file__).resolve().parents[1]; ROOT=RUN.parents[2]
def read(p):return p.read_text(encoding='utf-8-sig')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
sc=read(ROOT/'artifacts/SD/structure_chart.md');ta=read(ROOT/'artifacts/SD/transform_analysis.md')
def table(section):
 block=sc.split(section,1)[1].split('\n##',1)[0]
 return [[x.strip() for x in line.split('|')[1:-1]] for line in block.splitlines() if line.startswith('| ') and not line.startswith('|---')][1:]
modules=table('### 4.1 Internal modules');libs=table('### 4.2 Library/boundary modules');interfaces=table('## 5. Module interfaces')
assert len(modules)==27 and len(libs)==3 and len(interfaces)==31
module_names={r[0] for r in modules+libs}
desc={(r[0],callee) for r in modules for callee in r[3].split(', ') if callee!='—'}
iface={(r[0],r[1]) for r in interfaces};assert desc==iface
blocks=re.findall(r'```mermaid\s*\n(.*?)```',sc,re.S)
calls=set()
for block in blocks[:3]:
 nodes=dict(re.findall(r'(M\d+)\[\[?"([^"]+)"\]\]?',block))
 for a,b in re.findall(r'^\s*(M\d+) -->\|[^|]+\| (M\d+)',block,re.M):calls.add((nodes[a],nodes[b]))
assert calls==iface
assert {x for edge in calls for x in edge}==module_names
def descendants(start):
 visited=set();todo=[start]
 while todo:
  node=todo.pop()
  if node in visited:continue
  visited.add(node);todo += [b for a,b in calls if a==node]
 return visited
initial=descendants('Initialize RVC')
assert not initial & {'Controller','Movement Controller','Track Power-Up','Put Outputs','Issue Movement Output','Drive Motor','Drive Cleaner'}
assert {'Reset Sensor Data','Acquire Initial Inputs','Inputs Ready','Detect Obstacle','Detect Dust','Receive Input Event'}<=initial
assert [r[1] for r in interfaces if r[0]=='Initialize RVC']==['Reset Movement Controller','Reset Power-Up Timer','Reset Sensor Data','Acquire Initial Inputs']
assert [r[1] for r in interfaces if r[0]=='Controller']==['Get Inputs','Decide Actions','Put Outputs']
assert [r[1] for r in interfaces if r[0]=='Decide Actions']==['Movement Controller','Derive Movement Status','Track Power-Up','Decide Cleaning']
assert any(r[0]=='Track Power-Up' and r[1]=='Clear Pending Dust' and r[5].startswith('Forward only') for r in interfaces)
assert {a for a,b in calls if b=='Clear Pending Dust'}=={'Track Power-Up'}
assert 'Get Dust Existence' in descendants('Track Power-Up')
assert {a for a,b in calls if b=='Controller'}=={'Dispatch Input Event'}
for token in ['pending = D2.pending OR value','D3 = 5','Clear Pending Dust()','D3 = D3 - 1','human approval of this revised SD is pending','Q6 is confirmed C16']:
 assert token in sc,token
assert 'D2 -->|"Dust Existence"| P2' in ta
assert 'P41 -->|"Pending Dust Detection"| D2' in ta
sa='\n'.join(read(p) for p in (ROOT/'artifacts/SA/DFD').glob('dfd_level_[0-3].md'))
sa_flows=set(re.findall(r'\|([^|\n]+)\|','\n'.join(re.findall(r'```mermaid\s*\n(.*?)```',sa,re.S))))
ta_flows=set(re.findall(r'\|"([^"]+)"\|',ta));assert sa_flows==ta_flows and len(sa_flows)==19
spec_ids=set(re.findall(r'^## Process (\d+(?:\.\d+)*):',read(ROOT/'artifacts/SA/process_specification.md'),re.M))
processmap=table('### 6.1 Processes');assert {r[0] for r in processmap}==spec_ids
assert len(spec_ids)==13
baseline=json.loads(read(RUN/'baseline.json'))
for e in baseline['protected']:assert sha(ROOT/e['path'])==e['sha256'],e['path']
render=json.loads(read(RUN/'verification/render-results.json'));assert len(render['diagrams'])==5 and render['errors']==[]
for d in render['diagrams']:assert sha(RUN/'rendered'/(d['id']+'.mmd'))==d['sha256']
for name in ['transform_analysis','structure_chart']:
 for i,block in enumerate(re.findall(r'```mermaid\s*\n(.*?)```',read(ROOT/'artifacts/SD'/(name+'.md')),re.S),1):
  assert read(RUN/'rendered'/f'{name}-{i}.mmd')==block
expected=[]
for line in read(ROOT/'tests/expected_calls.txt').splitlines():
 if line and not line.startswith('#'):expected.append(tuple(line.split()))
snake=lambda s:'main' if s=='Main' else re.sub(r'[^a-z0-9]+','_',s.lower()).strip('_')
design_calls={(snake(a),snake(b)) for a,b in calls}
legacy=set(expected)
delta={'status':'legacy baseline intentionally unchanged; update only with authorized implementation','legacy_only':sorted(legacy-design_calls),'revised_design_only':sorted(design_calls-legacy)}
(RUN/'verification/legacy-call-delta.json').write_text(json.dumps(delta,indent=2),encoding='utf-8')
diff=subprocess.run(['git','diff','--check'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/diff-check.log').write_text(diff.stdout+diff.stderr,encoding='utf-8');assert diff.returncode==0
result={'executed_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'internal_modules':27,'boundary_modules':3,'call_and_interface_pairs':31,'mapped_SA_processes':13,'TA_flow_names_match_SA':19,'initialization_output_paths':0,'D2_reader_and_pending_feedback_present':True,'protected_files_unchanged':len(baseline['protected']),'rendered_diagrams':5,'git_diff_check_exit':0,'C_tests':'notRun','SPIN':'notRun','web_simulator':'notRun','human_SD_approval':'pending','scope':'document structure and source preservation; not implementation conformance'}
(RUN/'verification/document-checks.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
