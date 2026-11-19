"""Collect SD structural evidence; a successful script is not SD approval."""
from pathlib import Path
import re,json,hashlib,tomllib
RUN=Path(__file__).resolve().parents[1]; ROOT=RUN.parents[2]
def read(p):return (ROOT/p).read_text(encoding='utf-8-sig')
def table(text,section):
 block=text.split(section,1)[1].split('\n##',1)[0]
 return [(i,[v.strip() for v in s.split('|')[1:-1]]) for i,s in enumerate(text.splitlines(),1) if s in block.splitlines() and s.startswith('| ') and not s.startswith('|---')]
sc=read('artifacts/SD/structure_chart.md'); ta=read('artifacts/SD/transform_analysis.md')
g=re.findall(r'```mermaid\s*\n(.*?)```',sc,re.S)[0]
nodes=dict(re.findall(r'(\w+)\[\[?"([^"]+)"\]\]?',g))
edges=re.findall(r'^\s*(\w+) -->\s*(?:\|[^|]+\|\s*)?(\w+)',g,re.M)
calls={(nodes[a],nodes[b]) for a,b in edges if a!='StepQ' and b!='StepQ'}
assert ('MC','StepQ') in edges and ('StepQ','StartST') in edges
calls.add((nodes['MC'],nodes['StartST']))
interfaces=[{'line':i,'caller':c[0],'callee':c[1],'input':c[2],'output':c[3],'control':c[4]} for i,c in table(sc,'## 5. Module Interfaces') if c[0]!='Caller']
iface={(r['caller'],r['callee']) for r in interfaces}
internal=[{'line':i,'name':c[0],'region':c[1],'responsibility':c[2],'callees':[] if c[3]=='—' else c[3].split(', ')} for i,c in table(sc,'### 4.1 Modules') if c[0]!='Module']
libraries=[{'line':i,'name':c[0],'terminator':c[1],'event':c[2],'contract':c[3]} for i,c in table(sc,'### 4.2 Library modules') if c[0]!='Library Module']
desc={(r['name'],callee) for r in internal for callee in r['callees']}
processmap=[{'line':i,'id':c[0],'name':c[1],'modules':c[2],'rationale':c[3]} for i,c in table(sc,'### 6.1 Processes') if re.fullmatch(r'\d+(\.\d+)*',c[0])]
spec_ids=set(re.findall(r'^## Process (\d+(?:\.\d+)*):',read('artifacts/SA/process_specification.md'),re.M))
sa_flows=set(re.findall(r'\|([^|\n]+)\|', '\n'.join(re.findall(r'```mermaid\s*\n(.*?)```','\n'.join(read(p.relative_to(ROOT)) for p in (ROOT/'artifacts/SA/DFD').glob('dfd_level_[0-3].md')),re.S))))
ta_flows=set(re.findall(r'\|"([^"]+)"\|',ta))
mapconf=tomllib.loads(read('.specify/rvc-review-map.toml'))
mapped=[p for vals in mapconf['roles'].values() for p in vals]
assert all((ROOT/p).is_file() for p in mapped)
assert set(nodes.values())=={r['name'] for r in internal+libraries}
assert calls==iface==desc
assert spec_ids=={r['id'] for r in processmap}
assert len(internal)==19 and len(libraries)==7 and len(calls)==26 and len(spec_ids)==13
leaves=spec_ids-{'0','3','3.2','4'}
assert all(re.search(r'^\| '+re.escape(p)+r'(?: \(part\))? \|',ta,re.M) for p in leaves)
missing=sorted(sa_flows-ta_flows)
assert missing==['Pending Dust Detection'],missing
assert 'D2 -->|"Dust Existence"| P2' not in ta
assert 'P41 -->|"Pending Dust Detection"| D2' not in ta
search_hits=[{'path':p.as_posix(),'line':i,'text':s} for p in [Path('artifacts/SD/transform_analysis.md'),Path('artifacts/SD/structure_chart.md')] for i,s in enumerate(read(p).splitlines(),1) if re.search('pending|C1[2-6]',s,re.I)]
manifest=json.loads((RUN/'input-manifest.json').read_text(encoding='utf-8'))
for item in manifest['inputs']+manifest['protected']:
 assert hashlib.sha256((ROOT/item['path']).read_bytes()).hexdigest()==item['sha256'],item['path']
result={'scope':'syntax inventories and source integrity; semantic gaps are findings, not script failures','modules':internal,'library_modules':libraries,'calls':sorted(calls),'interfaces':interfaces,'process_map':processmap,'leaf_processes':sorted(leaves),'call_graph_interfaces_descriptions_agree':True,'sa_flows':sorted(sa_flows),'ta_flows':sorted(ta_flows),'missing_ta_flow_names':missing,'missing_ta_edges':['D2 -> P2 : Dust Existence','P4.1 -> D2 : Pending Dust Detection'],'sd_pending_or_C12_to_C16_search':{'pattern':'pending|C1[2-6]','paths':['artifacts/SD/transform_analysis.md','artifacts/SD/structure_chart.md'],'hits':search_hits},'mapped_paths_exist':len(mapped),'protected_files_unchanged':len(manifest['protected'])}
(RUN/'verification/structure-evidence.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'modules':len(nodes),'interfaces':len(iface),'process_maps':len(spec_ids),'leaf_regions':len(leaves),'sa_flows':len(sa_flows),'ta_flows':len(ta_flows),'missing_ta_flow_names':missing,'protected_files_unchanged':len(manifest['protected'])},ensure_ascii=False,indent=2))
