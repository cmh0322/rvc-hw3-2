"""Index inspected SD call contracts and compiled edge evidence, without editing sources."""
from pathlib import Path
import json,re,hashlib
RUN=Path(__file__).resolve().parents[1];ROOT=RUN.parents[2]
old=ROOT/'artifacts/Review/20261118-095720-phase4-fixes/verification/design-contract.json'
design=json.loads(old.read_text(encoding='utf-8'))
probe=json.loads((RUN/'verification/probe-results.json').read_text(encoding='utf-8'))
missing={tuple(e) for e in probe['calls']['missing']}
snake=lambda s:re.sub('[^a-z0-9]+','_',s.lower()).strip('_')
changed={('Main','Initialize RVC'):'Startup contract violated; no input acquisition and early motor output.',
('Initialize RVC','Reset Movement Controller'):'Returns MovementCommand rather than no data; caller emits it.',
('Controller','Get Inputs'):'Returns Inputs incl Boolean dust and polls hardware instead of stored D1 only.',
('Controller','Decide Actions'):'Caller supplies extra Boolean dust; approved module consumes D2 through Track Power-Up.',
('Decide Actions','Track Power-Up'):'Extra Boolean dust parameter; no D2 accessor or consumption.'}
sc=(ROOT/'artifacts/SD/structure_chart.md').read_text(encoding='utf-8').splitlines()
rows=[]
for call in design['calls']:
    a,b=call['caller'],call['callee'];pair=(snake(a),snake(b))
    line=next(i for i,l in enumerate(sc,1) if l.startswith(f'| {a} | {b} |'))
    absent=pair in missing
    rows.append({**call,'spec_ref':{'path':'artifacts/SD/structure_chart.md','start':line,'end':line},
                 'compiled_edge':'absent' if absent else 'present',
                 'contract_verdict':'absent' if absent else 'partial' if (a,b) in changed else 'implemented',
                 'note': 'No corresponding compiled call or alternate event/store enforcement; see sd-analysis.md.' if absent else changed.get((a,b),'Call, data/control meaning and order checked in sd-analysis.md; broader caller contract may still fail.')})
(RUN/'c-compliance/sd-interfaces.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8')
lines=['# SD call contract matrix','','Every row of the approved call table is represented. Present edge does not imply the whole caller meets its specification. See sd-analysis.md for source paths and branch reasoning.','','| Caller → callee | SD line | Edge | Contract |','|---|---:|---|---|']
for r in rows:lines.append(f"| {r['caller']} → {r['callee']} | {r['spec_ref']['start']} | {r['compiled_edge']} | {r['contract_verdict']} |")
(RUN/'c-compliance/sd-interfaces.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
patterns=['pending','receive_input|InputEvent|InputMode','dispatch|inputs_ready|sensor_store|reset_sensor','get_dust|get_obstacle']
inventory=[]
for pattern in patterns:
    matches=[]
    for folder in ['src','include','tests','simulator/host']:
        for p in (ROOT/folder).rglob('*'):
            if p.is_file():
                for i,l in enumerate(p.read_text(encoding='utf-8-sig').splitlines(),1):
                    if re.search(pattern,l,re.I):matches.append({'path':p.relative_to(ROOT).as_posix(),'line':i,'text':l})
    inventory.append({'pattern':pattern,'scope':['src','include','tests','simulator/host'],'matches':matches})
(RUN/'c-compliance/absence-searches.json').write_text(json.dumps(inventory,ensure_ascii=False,indent=2),encoding='utf-8')
print({'interface_rows':len(rows),'present_edges':sum(r['compiled_edge']=='present' for r in rows),'absent_edges':len(missing),'searches':len(inventory)})
