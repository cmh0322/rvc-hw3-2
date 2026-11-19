"""Check Q6 -> C16 document propagation; not an implementation/model test."""
from pathlib import Path
from datetime import datetime
import hashlib, json, re, subprocess, sys, tomllib

ROOT = Path(__file__).resolve().parents[4]
RUN = Path(__file__).resolve().parents[1]
def read(p):
    return p.read_text(encoding='utf-8-sig')
def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

baseline = json.loads(read(RUN/'baseline.json'))
changed = json.loads(read(RUN/'changed-files.json'))
req = read(ROOT/'docs/requirements_clarifications.md')
mapping = tomllib.loads(read(ROOT/'.specify/rvc-review-map.toml'))
assert re.findall(r'^\| (C\d+) \|', req, re.M) == [f'C{i}' for i in range(1,17)]
assert len(mapping['identifiers']['requirements']) == 23
assert mapping['identifiers']['assumptions'] == []
assert 'Resolved by C16' in req
assert '| C15 ' in req and '\n\n| C16 ' not in req
assert not [p for p,h in baseline['protected'].items() if sha(ROOT/p) != h]
fsm = 'artifacts/SA/DFD/dfd_level_4_fsm.md'
def transitions(text):
    return [line.split('|')[1:7] for line in text.splitlines() if re.match(r'^\| T\d+ \|',line)]
assert transitions(read(ROOT/fsm)) == transitions(read(RUN/'before'/fsm))
assert len(transitions(read(ROOT/fsm))) == 15
for p in (RUN/'before/artifacts/SA').rglob('*.md'):
    rel=p.relative_to(RUN/'before')
    assert re.findall(r'```mermaid.*?```',read(p),re.S) == re.findall(r'```mermaid.*?```',read(ROOT/rel),re.S),str(rel)
oldreq=read(RUN/'before/docs/requirements_clarifications.md')
assert re.findall(r'^\| C9 .+$',oldreq,re.M) == re.findall(r'^\| C9 .+$',req,re.M)
stale = re.compile(r'Q6 (?:remains an assumption|stays an assumption|has its own assumption row|is an assumption)|Keep Q6 as an assumption|Q6를 가정으로 표시|Q6는 가정으로 유지한다')
assert not [(p,stale.findall(read(ROOT/p))) for p in changed if stale.search(read(ROOT/p))]
manifest_path = RUN/'traceability/input-manifest.json'
manifest=json.loads(read(manifest_path))
for item in manifest['inputs']:
    item['sha256']=sha(ROOT/item['path'])
manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
result=subprocess.run([sys.executable,str(RUN/'verification/check_documents.py')],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/document-checks.log').write_text(result.stdout+result.stderr,encoding='utf-8')
assert result.returncode == 0, result.stdout+result.stderr
diff=subprocess.run(['git','diff','--check'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/diff-check.log').write_text(diff.stdout+diff.stderr,encoding='utf-8')
assert diff.returncode == 0,diff.stdout+diff.stderr
checks=json.loads(read(RUN/'verification/document-checks.json'))
result={'executed_at':datetime.now().astimezone().isoformat(),'scope':'Q6 confirmation document checks only','confirmed_requirements':23,'open_question_assumptions':0,'dfd_boundaries_equal':len(checks['boundaries']),'processes_with_specifications':len(checks['process_ids']),'defined_flows':len(checks['flow_names']),'fsm_transition_conditions_actions_unchanged':15,'all_sa_mermaid_blocks_unchanged':True,'C9_unchanged':True,'protected_files_unchanged':len(baseline['protected']),'changed_files':[{'path':p,'sha256':sha(ROOT/p)} for p in changed],'git_diff_check_exit':diff.returncode,'document_checker_exit':0,'product_tests':'notRun','spin':'notRun','SD_C_compliance':'notChecked'}
(RUN/'verification/decision-checks.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k!='changed_files'},ensure_ascii=False,indent=2))
