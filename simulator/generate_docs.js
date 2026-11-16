// Writes the system test documents from the scenario definitions, so that the
// documents and the simulator cannot drift apart:
//   artifacts/SystemTest/test_scenarios.md
//   artifacts/SystemTest/requirement_traceability.md
//
//   node simulator/generate_docs.js
'use strict';

const fs = require('fs');
const path = require('path');
const { SCENARIOS, FUNCTIONS, requirementsOf, artifactsOf } = require('./public/scenarios');

const OUT_DIR = path.join(__dirname, '..', 'artifacts', 'SystemTest');
const HEADING = { N: 'N (up, toward y = 0)', E: 'E (right)', S: 'S (down)', W: 'W (left)' };
const cells = (list) => (list.length === 0 ? 'none' : list.map(([x, y]) => `(${x},${y})`).join(' '));

function scenariosDocument() {
    let text = `# RVC System Test Scenarios

Generated from \`simulator/public/scenarios.js\` by \`node simulator/generate_docs.js\`.
Requirement IDs: B1-B7 (\`docs/preliminary_requirements.md\`), C1-C11 and Q6 (\`docs/requirements_clarifications.md\`).

## 1. Test Design Policy

- ${SCENARIOS.length} scenarios, each on the 10x10 grid, each run for at most 100 ticks.
- Coordinates are (x, y). (0,0) is the top left cell, x grows to the right, y grows downward.
- The grid boundary acts as a wall. The default start is (4,4), heading N.
- The test oracle is the human evaluator. The simulator assigns no PASS or FAIL.
- "Expected Behavior" is derived from the requirements and the approved SA artifacts. Tick numbers follow from the 5-tick durations (C3, C6, C7, C8) and from the simulator's map rules, which are listed in \`simulator/README.md\`.

## 2. Essential System Functions

| ID | Function | Requirements |
|---|---|---|
`;
    Object.keys(FUNCTIONS).forEach((id) => {
        text += `| ${id} | ${FUNCTIONS[id].name} | ${FUNCTIONS[id].requirements.join(', ')} |\n`;
    });
    text += '\n## 3. Scenarios\n';
    SCENARIOS.forEach((s) => {
        text += `
### ${s.id}: ${s.name}

**Initial Configuration**
- Grid: 10x10
- RVC Start: (${s.start.x},${s.start.y})
- Initial Direction: ${HEADING[s.heading]}
- Obstacles: ${cells(s.obstacles)}
- Dust: ${cells(s.dust)}
- Maximum Ticks: 100

**Test Objectives**
${s.functions.map((f, i) => `- Essential Function ${i + 1}: ${f} ${FUNCTIONS[f].name}`).join('\n')}

**Requirement Traceability**
- Related Requirement IDs: ${requirementsOf(s).join(', ')}
- Related SA Artifacts: ${artifactsOf(s).join('; ')}

**Expected Behavior**

${s.expected}

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):
`;
    });
    text += `
## 4. Custom Map Testing

In the simulator, switch on "Edit", change obstacles, dust, the RVC start, and the initial direction at tick 0, and run the map like any scenario. "Save as new scenario" keeps it in the scenario list (IDs CU-01, CU-02, ...) in the browser, and "Export map" writes it to a file. A custom map has no predefined expectation; the evaluator judges it against the requirements.
`;
    return text;
}

function traceabilityDocument() {
    let text = `# Requirement Traceability (System Test)

Generated from \`simulator/public/scenarios.js\` by \`node simulator/generate_docs.js\`.
Human results are recorded in \`test_results.md\`.

## 1. Scenarios to requirements

| Scenario ID | Essential Functions | Requirement IDs | SA Artifacts | Human Result |
|---|---|---|---|---|
`;
    SCENARIOS.forEach((s) => {
        text += `| ${s.id} | ${s.functions.join(', ')} | ${requirementsOf(s).join(', ')} | ${artifactsOf(s).join('; ')} | Pending |\n`;
    });

    const order = ['B1', 'B2', 'B3', 'B4', 'B5', 'C1', 'C2', 'C3', 'C5', 'C6', 'C7', 'C8', 'C9', 'C10', 'C11', 'Q6 (assumption)'];
    text += '\n## 2. Requirements to scenarios\n\n| Requirement | Scenarios |\n|---|---|\n';
    order.forEach((req) => {
        const ids = SCENARIOS.filter((s) => requirementsOf(s).includes(req)).map((s) => s.id);
        text += `| ${req} | ${ids.join(', ')} |\n`;
    });
    text += `| B6, B7 | Not behaviors: they limit the scope (no hardware detail; automatic cleaning only). |
| C4 | An assumption about the surroundings: obstacles do not disappear. Every map is static, so it holds in all scenarios. |

## 3. Functions to scenarios

| Function | Scenarios |
|---|---|
`;
    Object.keys(FUNCTIONS).forEach((id) => {
        const ids = SCENARIOS.filter((s) => s.functions.includes(id)).map((s) => s.id);
        text += `| ${id} ${FUNCTIONS[id].name} | ${ids.join(', ')} |\n`;
    });
    return text;
}

fs.mkdirSync(OUT_DIR, { recursive: true });
fs.writeFileSync(path.join(OUT_DIR, 'test_scenarios.md'), scenariosDocument());
fs.writeFileSync(path.join(OUT_DIR, 'requirement_traceability.md'), traceabilityDocument());
const few = SCENARIOS.filter((s) => s.functions.length < 3).map((s) => s.id);
console.log(`${SCENARIOS.length} scenarios written.` + (few.length ? ` Fewer than 3 functions: ${few.join(', ')}` : ' Every scenario has at least 3 functions.'));
