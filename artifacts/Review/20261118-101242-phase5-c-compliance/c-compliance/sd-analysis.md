# Approved SD → C interface and reverse trace

Method: Codex adapter using Trail of Bits criteria. The user approved this SD revision in approval.md. This is a source audit; call-edge presence alone does not prove interface semantics. Requirement checks are separate in requirements/.

## Invocation and interface obligations

The normative call table is artifacts/SD/structure_chart.md:185–220; lifecycle and serialized event contract are lines 13–23 and hidden storage is lines 174–181. Every source in src/ and header in include/ was read. CMakeLists.txt builds all src/*.c except main into rvc_control, builds main separately and links the same C into rvc_sim_host. There is no conditional alternate production implementation of the input path.

| Obligation | Verdict | Actual enforcement / divergence |
|---|---|---|
| SD-INIT: state-only reset, D3/D4 reset, sensor reset/acquisition | partial | src/initialize_rvc.c:8–13 resets movement and D3, but emits Forward; src/movement_controller.c:64–68 returns a MovementCommand instead of void. No sensor acquisition occurs. |
| SD-EVENT: Main receives ordered sensor/Tick events, dispatching sensors without advancing timers | absent | src/main.c:12–16 waits for Tick then runs Controller. include/hw_interface.h:17–30 provides four polling functions and wait_for_tick. No receive/dispatch function or tagged InputEvent type exists. |
| SD-STORE: D1/D2 valid-value storage and accessors; pending OR and Forward-only consume | absent | src/detect_obstacle.c:6–14 returns a temporary snapshot; src/detect_dust.c:6–8 returns one current Boolean. include/rvc_types.h has no DustExistence record or validity flags. No persistent D1/D2 owner or accessor implements the contract. |
| SD-TICK: Get Inputs → Decide Actions → Put Outputs; one complete cycle per Tick | partial | src/controller.c:10–13 keeps order. But Get Inputs returns Inputs{obstacle_situation,bool dust_existence}, not only ObstacleSituation, and reads hardware within Tick; src/get_inputs.c:8–16, include/get_inputs.h:11–21. |
| SD-DECIDE: pass SituationSignal, movement before status before power before clean | partial | src/decide_actions.c:17–22 preserves order and passes the situation value unchanged. Its signature still accepts Boolean dust, and Track Power-Up accepts it rather than reading/consuming D2: include/decide_actions.h:21; include/power_up_timer.h:20; src/power_up_timer.c:10–30. |
| SD-MOVE: advance D4 before exactly one transition; start D4 only for a new timed step | implemented | src/movement_controller.c:24–60 advances once, selects one transition, starts only when step_begins. src/step_timer.c:10–35 provides Idle/0..5 behavior. Right priority and side-only postback decision remain intact. |
| SD-OUTPUT: command mapping, Direction then Clean within same Tick | implemented | src/put_outputs.c:7–10 and src/issue_movement_output.c:6–17. MovementStatus from MovementCommand is separate from motor output, as SD permits. Actions aggregate represents returned movement/control plus Clean without changing meaning. |
| SD-HIDING: private state, value-copy read-only diagnostic queries | partial | State/D3/D4 are file-static (movement_controller.c:10, power_up_timer.c:7, step_timer.c:7), and their queries return copies. Required D1/D2 store is absent; do not misclassify permitted read-only test/simulator getters as illegal mutable coupling. |
| SD-BOUNDARY: approved three boundary functions | partial | drive_motor and drive_cleaner persist; receive_input_event is absent. Existing fake and simulator adapters accept only a current per-Tick snapshot. Simulator host input grammar is four bits per Tick (simulator/host/sim_host.c:92–108); simulator/controller_process.js:61–69 sends that snapshot, not the approved ordered event stream. |

## Actual call graph comparison

The fresh GCC call graph contains 26 calls. `tests/expected_calls.txt` contains the same 26, so the existing call_hierarchy test passes. The approved SD has 31 calls: 17 are shared, 14 are missing from compiled C, and 9 obsolete calls remain. The existing checker was executed against a separate approved expectation file in this review directory, and failed with the actual differences. No production test baseline was changed.

See ../verification/approved-call-hierarchy.log, approved_expected_calls.txt and probe-results.json. The exact differences are also retained as machine-readable evidence. Present calls with changed signatures are explicitly distinguished above; matching 17 edges is not 17 satisfied contracts.

Absence search: `rg -n "pending|receive_input|dispatch|inputs_ready|sensor_store|reset_sensor|get_dust|get_obstacle|InputEvent|InputMode" src include tests simulator/host` found no production enforcement. All 15 C source files and 16 headers were inspected, including callers and CMake source inclusion, rather than relying solely on missing names. Alternate implementation is also ruled out by the concrete paths: all sensor input goes through read_* within get_inputs and the only dust state is D3's remaining count.

## Reverse direction

| Code behavior | Specification connection | Classification |
|---|---|---|
| Initial motor Forward | Directly conflicts with C13 / T0 | Covered by startup finding, not an undocumented feature |
| Current-value polling, temporary D1/D2, dust passed down call chain | Superseded earlier SD; conflicts with approved event/store contracts | Covered by input/store finding |
| Read-only state, D3, D4 queries | Explicitly allowed by SC:181; tests and simulator only | Accepted observation APIs |
| Return Actions struct | SC call table returns Clean plus Movement Command | Equivalent C packaging, no defect |
| P3.2.1 value passing without empty wrapper function | Explicit SC:221 realization | Accepted; no one-function-per-process rule |
| Continuous TRUE restarts boost each Forward Tick | C10 and SC power-up contract | Required behavior, not an undocumented infinite boost |
| Unbounded repeated Backing while both sides blocked | C5/C9 | Required permitted behavior, not deadlock or missing liveness |
| No enum validation inside command lookup | SD requires valid boundary kinds/values; only internal valid commands reach output | No unsupported recovery requirement invented |
| Simulator 10×10 grid, 100-tick limit and blocked physical move | Simulation environment (world.js:16–18,117–126), not production controller | No new production requirement; physical collision guarantee is not claimed |
| Simulator does not track separate suction/mop intensities | B6 abstraction; Clean is forwarded unchanged | C14 actuator realization is not proven by this simulator; lack of real driver is not a defect |

No additional undocumented production feature was established beyond the superseded design paths above. This source sweep is not a claim of general memory-safety/security correctness.
