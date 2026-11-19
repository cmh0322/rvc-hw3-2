"""Phase 1 structural evidence only; no behavioral or product PASS verdict."""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[4]
RUN = Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding="utf-8-sig")

def graph(path, block=0):
    text = re.findall(r"```mermaid\s*\n(.*?)```", read(path), re.S)[block]
    edges = []
    for source, arrow, flow, target in re.findall(r"(\w+)\s+(-->|-\.->)\|([^|]+)\|\s+(\w+)", text):
        edges.append((source.removesuffix("ext"), target.removesuffix("ext"), flow, "control" if arrow == "-.->" else "data"))
    assert edges, path
    return edges

def boundary(edges, inside):
    result = set()
    for source, target, flow, kind in edges:
        if (source in inside) != (target in inside):
            result.add(("out" if source in inside else "in", flow, kind, target if source in inside else source))
    return sorted(result)

base = "artifacts/SA/"
context = graph(base + "context_diagram.md")
levels = [graph(base + f"DFD/dfd_level_{i}.md") for i in range(4)]
cleaning = graph(base + "DFD/dfd_level_2.md", 1)
cases = [
    ("Context -> 0", context, {"System"}, levels[0], {"P0"}),
    ("0 -> 1", levels[0], {"P0"}, levels[1], {"P1", "P2", "P3", "P4", "DS1", "DS2"}),
    ("3 -> 3.1/3.2", levels[1], {"P3"}, levels[2], {"P31", "P32"}),
    ("4 -> 4.1/4.2", levels[1], {"P4"}, cleaning, {"P41", "P42", "DS3"}),
    ("3.2 -> 3.2.1-4", levels[2], {"P32"}, levels[3], {"P321", "P322", "P323", "P324", "DS4"}),
]
checks = []
for name, parent, pin, child, cin in cases:
    p, c = boundary(parent, pin), boundary(child, cin)
    checks.append({"name": name, "parent": p, "child": c, "equal": p == c})

processes = set()
for i in range(4):
    processes.update(re.findall(r'^\| (\d+(?:\.\d+)*) \|', read(base + f"DFD/dfd_level_{i}.md"), re.M))
specs = set(re.findall(r'^## Process (\d+(?:\.\d+)*):', read(base + 'process_specification.md'), re.M))
flows = {edge[2] for g in [context, *levels, cleaning] for edge in g}
definitions = set(re.findall(r'^### (.+)$', read(base + 'data_dictionary.md'), re.M))
manifest = json.loads((RUN / 'traceability/input-manifest.json').read_text(encoding='utf-8'))
unchanged = all(hashlib.sha256((ROOT / i['path']).read_bytes()).hexdigest() == i['sha256'] for i in manifest['inputs'])
result = {
    'scope': 'Diagram boundary syntax, process/flow definition presence, input integrity. No behavior proof.',
    'boundaries': checks,
    'process_ids': sorted(processes),
    'spec_ids': sorted(specs),
    'missing_specs': sorted(processes - specs),
    'extra_specs': sorted(specs - processes),
    'flow_names': sorted(flows),
    'missing_flow_definitions': sorted(flows - definitions),
    'input_sha256_unchanged': unchanged,
}
(RUN / 'verification/document-checks.json').write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(result, ensure_ascii=False, indent=2))
raise SystemExit(0 if all(c['equal'] for c in checks) and processes == specs and not flows - definitions and unchanged else 1)
