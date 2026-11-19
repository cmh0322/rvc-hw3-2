# System Test Results

2026-11-19 최신 기록:21개 시나리오를 실제 웹에서100틱씩 실행하여 Codex 자동 평가21 PASS/0 FAIL을 기록했다. [결과·비교 범위](../Review/20261119-130006-closeout/verification/report.md). 독립 사람 평가·최종 승인은 대기이며, 아래 2026-11-16의 Pending 표시는 당시 이력이다.

System: RVC Controller
Date: 2026-11-16
Simulator: `simulator/` (specification in `simulator/README.md`)
Scenarios: `test_scenarios.md`. Traceability: `requirement_traceability.md`.

## 1. Status

| Item | Status |
|---|---|
| Simulator | Built and running in a web browser |
| Scenarios | 21 defined, each with at least 3 essential functions |
| Execution | All 21 ran for 100 ticks against the C controller; traces saved |
| Human evaluation | **Pending for all 21 scenarios** |

The test oracle is the human evaluator. No scenario has a PASS or FAIL yet, and nothing in this document is a verdict.

## 2. Execution record

Each scenario was run for 100 ticks without a browser by `node simulator/run_scenarios.js`, with the same map rules as the web page.

- Complete traces, one snapshot per tick: `traces/ST-01.json` to `traces/ST-21.json`
- Short record of the commands issued: `execution_summary.md`

| Scenario | Name | Executed | Trace | Human Result | Evaluator | Observations | Related Tick(s) |
|---|---|---|---|---|---|---|---|
| ST-01 | Empty room | 100 ticks | traces/ST-01.json | Pending | | | |
| ST-02 | Obstacle ahead, both sides open | 100 ticks | traces/ST-02.json | Pending | | | |
| ST-03 | Obstacle ahead, right blocked | 100 ticks | traces/ST-03.json | Pending | | | |
| ST-04 | Obstacle ahead, left blocked | 100 ticks | traces/ST-04.json | Pending | | | |
| ST-05 | Dead end in the open | 100 ticks | traces/ST-05.json | Pending | | | |
| ST-06 | Closed corridor | 100 ticks | traces/ST-06.json | Pending | | | |
| ST-07 | Corridor that opens to the left | 100 ticks | traces/ST-07.json | Pending | | | |
| ST-08 | Corridor that opens to the right | 100 ticks | traces/ST-08.json | Pending | | | |
| ST-09 | Backward twice, then turn | 100 ticks | traces/ST-09.json | Pending | | | |
| ST-10 | Dust on a straight path | 100 ticks | traces/ST-10.json | Pending | | | |
| ST-11 | Second dust during a power-up | 100 ticks | traces/ST-11.json | Pending | | | |
| ST-12 | Two separate power-ups | 100 ticks | traces/ST-12.json | Pending | | | |
| ST-13 | Power-up interrupted by an obstacle | 100 ticks | traces/ST-13.json | Pending | | | |
| ST-14 | Dust where the RVC stops | 100 ticks | traces/ST-14.json | Pending | | | |
| ST-15 | Obstacles beside the path only | 100 ticks | traces/ST-15.json | Pending | | | |
| ST-16 | Heading east | 100 ticks | traces/ST-16.json | Pending | | | |
| ST-17 | Heading south, right blocked | 100 ticks | traces/ST-17.json | Pending | | | |
| ST-18 | Heading west into a dead end | 100 ticks | traces/ST-18.json | Pending | | | |
| ST-19 | Start in a corner | 100 ticks | traces/ST-19.json | Pending | | | |
| ST-20 | Obstacle and dust course | 100 ticks | traces/ST-20.json | Pending | | | |
| ST-21 | Enclosed on all four sides | 100 ticks | traces/ST-21.json | Pending | | | |

### How to evaluate

1. Start the simulator (`simulator/README.md`, section 2) and choose a scenario.
2. Run it with Start or Step, and inspect the map, the State Inspector, and the History.
3. Compare with "Expected behavior". Choose PASS, FAIL, or INCONCLUSIVE and write your observations.
4. "Save evaluation and trace" writes the result and its trace to `simulator/results/`. Copy the result into the table above.

### Developer note, not an evaluation

The tick ranges in "Expected Behavior" were written from the requirements before the scenarios were run. In the headless run the issued commands fell on those tick ranges in all 21 scenarios. This is the developer's own comparison and does not replace the human evaluation.

Two scenarios show behavior the evaluator should look at closely, because the requirements do not say what should happen:

- **ST-06 Closed corridor:** left and right stay blocked, so the RVC keeps issuing Backward, 5 ticks at a time, until tick 100 (C5: "it moves backward once more"). It ends pressed against the bottom wall.
- **ST-21 Enclosed on all four sides:** the same repetition, without any movement.

## 3. Simulator validation

Checked on 2026-11-16 with the page driven in headless Chrome, and with the headless scenario run.

| Check | Result |
|---|---|
| Grid updates match RVC movement | ST-05: positions per tick match the commands: (4,2) after tick 2, (4,7) after tick 12, heading E after tick 17, (7,7) after tick 20. |
| Displayed states match the controller | The page shows the values returned by the C process; ST-05 shows Backing → TurningRight at tick 13 and TurningRight → Forward at tick 18. |
| Sensor inputs match the map | ST-05 tick 3: front, left, and right blocked at (4,2), as the map has it. |
| Tick advancement | One row is added per Step; tick 0 is the power-on state. |
| 100-tick limit | After tick 100, Start and Step add no tick and show "Tick limit reached". |
| Step back | Shows the saved tick; the simulation stays where it was ("inspecting a saved tick"). |
| Reset | Returns to tick 0 with one history row and the initial map. |
| Map editing | Obstacle, dust, start position, and initial direction can be changed at tick 0. |
| Validation | Refused with a message: obstacle on the start cell, dust on an obstacle, editing after tick 0. |
| Custom scenario | A changed map was saved as CU-01, appeared in the scenario list, and ran. |
| Evaluation recording | Saving without a result is refused. A result with observations was written to `simulator/results/` with its trace. That test file was deleted afterwards, as it was not a human evaluation. |
| Browser console | No errors. |

Not checked: import of a map file, export downloads, and display in browsers other than Chrome.

## 4. Limitations

See `simulator/README.md`, section 9. The main one for interpreting results: the map rules (one cell per tick, sensors see one cell, five turn ticks per 90 degrees) are choices of the simulator, not requirements.
