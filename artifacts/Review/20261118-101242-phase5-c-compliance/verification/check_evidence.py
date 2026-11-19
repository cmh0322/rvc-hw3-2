"""Validate audit completeness, references and protected source hashes."""
from pathlib import Path
from datetime import datetime, timezone, timedelta
from collections import Counter
import hashlib,json,subprocess,re
RUN=Path(__file__).resolve().parents[1];ROOT=RUN.parents[2]
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def read(p):
    raw=p.read_bytes()
    return raw.decode('utf-16' if raw.startswith((b'\xff\xfe',b'\xfe\xff')) else 'utf-8-sig')
def refs(value):
    if isinstance(value,dict):
        if {'path','start','end'}<=value.keys():
            lines=read(ROOT/value['path']).splitlines()
            assert 1<=value['start']<=value['end']<=len(lines),value
        for v in value.values():refs(v)
    elif isinstance(value,list):
        for v in value:refs(v)
baseline=load(RUN/'baseline.json')
for entry in baseline['protected']:
    assert hashlib.sha256((ROOT/entry['path']).read_bytes()).hexdigest()==entry['sha256'],entry['path']
ids=[f'B{i}' for i in range(1,8)]+[f'C{i}' for i in range(1,17)]
records=[]
for identifier in ids:
    path=RUN/'c-compliance/requirements'/f'{identifier}.json'
    record=load(path);assert record['id']==identifier
    assert record['verdict'] in {'implemented','partial','contradicted','stronger-than-spec','absent','undecidable'}
    assert all(field in record for field in ['spec_refs','code_refs','subclaims','paths_walked','searched','divergence','tests_reviewed','test_execution','open_questions'])
    assert path.with_suffix('.md').exists();refs(record);records.append(record)
interfaces=load(RUN/'c-compliance/sd-interfaces.json');assert len(interfaces)==31;refs(interfaces)
probe=load(RUN/'verification/probe-results.json')
assert probe['failed']==6 and probe['passed']==4
assert probe['calls']['compiled']==26 and probe['calls']['approved']==31
assert len(probe['calls']['missing'])==14 and len(probe['calls']['unexpected'])==9
refutations=list((RUN/'c-compliance/refutations').glob('*.json'))
assert refutations,'Independent refutation records are required'
for path in refutations:refs(load(path))
votes={f['id']:f for path in refutations for f in load(path).get('findings',[])}
assert all(f'P5-{i:02}' in votes and not votes[f'P5-{i:02}']['refuted'] for i in range(1,7))
findings=load(RUN/'c-compliance/findings.json');assert len(findings)==6;refs(findings)
checked_links=0
for path in [ROOT/'QA.md',ROOT/'README.md',*RUN.rglob('report.md'),RUN/'c-compliance/matrix.md']:
    for target in re.findall(r'\]\(([^)]+)\)',read(path)):
        if '://' in target or target.startswith('#'):continue
        assert (path.parent/target.split('#',1)[0]).exists(),(str(path),target)
        checked_links+=1
diff=subprocess.run(['git','diff','--check'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
(RUN/'verification/diff-check.log').write_text(diff.stdout+diff.stderr,encoding='utf-8');assert diff.returncode==0
result={'checked_at':datetime.now(timezone(timedelta(hours=9))).isoformat(),'protected_files_unchanged':len(baseline['protected']),
        'requirement_records':len(records),'raw_verdict_counts':dict(Counter(x['verdict'] for x in records)),
        'SD_interface_rows':len(interfaces),'independent_refutation_files':len(refutations),'independently_refuted_findings':6,'existing_relative_links':checked_links,'git_diff_check_exit':0,
        'scope':'Evidence completeness and input preservation; implementation noncompliance remains.',
        'production_modified':False,'browser_system_test':'notRun','SPIN':'notRun'}
(RUN/'verification/evidence-checks.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
