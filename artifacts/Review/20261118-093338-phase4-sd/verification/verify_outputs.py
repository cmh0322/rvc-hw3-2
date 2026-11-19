from pathlib import Path
from datetime import datetime,timezone,timedelta
import re,json,hashlib,subprocess,collections,tomllib,sys
RUN=Path(__file__).resolve().parents[1]; ROOT=RUN.parents[2]
def read(p):return p.read_text(encoding='utf-8-sig')
def load(p):return json.loads(read(RUN/p))
p=subprocess.run([sys.executable,str(RUN/'verification/check_structure.py')],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/structure-check.log').write_text(p.stdout+p.stderr,encoding='utf-8')
assert p.returncode==0,p.stdout+p.stderr
matrix=load('traceability/matrix.json'); raw=load('bmad/findings.json'); findings=load('traceability/findings.json')
expected=['B'+str(i) for i in range(1,8)]+['C'+str(i) for i in range(1,17)]
assert [r['id'] for r in matrix]==expected
assert tomllib.loads(read(ROOT/'.specify/rvc-review-map.toml'))['identifiers']['requirements']==expected
counts=collections.Counter(r['SD_status'] for r in matrix)
assert counts=={'mapped':15,'scope-justified':3,'partial':2,'conflict':2,'stale-status':1}
assert len(raw)==11 and collections.Counter(r['lens'] for r in raw)=={'adversarial':3,'edge-case-hunter':4,'sasd':4}
assert all(set(r)=={'lens','location','trigger_condition','guard_snippet','potential_consequence'} for r in raw)
assert set(i for f in findings for i in f['raw'])==set(range(11))
assert len(findings)==6 and sum(f['classification'].startswith('선택적') for f in findings)==1
for r in matrix:
 assert all(r[k]=='notChecked' for k in ['C_symbols','unit_tests','system_tests'])
 assert r['executed_tests']=='notRun'
 for e in [r['source']]+r['evidence']:
  lines=read(ROOT/e['path']).splitlines()
  assert 1<=e['start']<=e['end']<=len(lines),e
 assert '| '+r['id']+' |' in read(ROOT/r['source']['path']) if r['id'].startswith('C') else True
for f in findings:
 for e in f['evidence']:
  assert 1<=e['start']<=e['end']<=len(read(ROOT/e['path']).splitlines()),e
assert 'C14' in read(ROOT/'artifacts/SA/data_dictionary.md').splitlines()[111]
assert 'C4' in read(ROOT/'artifacts/SA/DFD/dfd_level_4_fsm.md').splitlines()[103]
reverse=load('traceability/reverse-map.json');assert len(reverse['modules'])==26
checklist=read(RUN/'traceability/checklist.md');assert len(re.findall(r'^- \[ \] CHK\d+',checklist,re.M))==15 and '[x] CHK' not in checklist
for path in [RUN/'bmad/report.md',RUN/'traceability/report.md',RUN/'traceability/matrix.md',RUN/'verification/report.md',ROOT/'QA.md',ROOT/'README.md']:
 for target in re.findall(r'\]\(([^)]+)\)',read(path)):
  if target.startswith(('http:','https:','#')):continue
  target=target.split('#')[0]
  assert not target or (path.parent/target).exists(),(path,target)
manifest=load('input-manifest.json')
for e in manifest['inputs']+manifest['protected']:
 assert hashlib.sha256((ROOT/e['path']).read_bytes()).hexdigest()==e['sha256'],e['path']
diff=subprocess.run(['git','diff','--check'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/diff-check.log').write_text(diff.stdout+diff.stderr,encoding='utf-8');assert diff.returncode==0,diff.stdout+diff.stderr
result={'executed_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'scope':'review evidence consistency; not SD approval or product test success','requirements_reviewed':23,'status_counts':dict(counts),'independent_lenses':3,'raw_findings_preserved':11,'triaged_required_items':5,'optional_items':1,'modules_and_interfaces':26,'process_maps':13,'primitive_region_maps':9,'checklist_questions':15,'protected_files_unchanged':len(manifest['protected']),'mapped_paths_exist':load('verification/structure-evidence.json')['mapped_paths_exist'],'git_diff_check_exit':0,'structure_check_exit':0,'C_tests':'notRun','SPIN':'notRun','web_simulator':'notRun','coverage':'notMeasured','source_fixes':'notApplied'}
(RUN/'verification/output-checks.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
