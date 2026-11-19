# Current module traceability — 2026-11-18

Approved SD revision: 2026-11-18; owner approval recorded in Phase 5. All internal design modules below map to C functions. Sensor Store owns D1/D2 in one translation unit; diagnostic queries return copies. Q6 is resolved by C16.

| SD module | C symbol | Source |
|---|---|---|
| Main | `main` | `src/main.c:11` |
| Initialize RVC | `initialize_rvc` | `src/initialize_rvc.c:9` |
| Acquire Initial Inputs | `acquire_initial_inputs` | `src/input_events.c:6` |
| Dispatch Input Event | `dispatch_input_event` | `src/input_events.c:17` |
| Dispatch Sensor Input | `dispatch_sensor_input` | `src/input_events.c:12` |
| Controller | `controller` | `src/controller.c:8` |
| Get Inputs | `get_inputs` | `src/get_inputs.c:7` |
| Detect Obstacle | `detect_obstacle` | `src/sensor_store.c:18` |
| Assess Obstacle Situation | `assess_obstacle_situation` | `src/assess_obstacle_situation.c:4` |
| Detect Dust | `detect_dust` | `src/sensor_store.c:25` |
| Reset Sensor Data | `reset_sensor_data` | `src/sensor_store.c:8` |
| Inputs Ready | `inputs_ready` | `src/sensor_store.c:14` |
| Get Obstacle Location | `get_obstacle_location` | `src/sensor_store.c:31` |
| Get Dust Existence | `get_dust_existence` | `src/sensor_store.c:32` |
| Clear Pending Dust | `clear_pending_dust` | `src/sensor_store.c:33` |
| Decide Actions | `decide_actions` | `src/decide_actions.c:9` |
| Movement Controller | `movement_controller` | `src/movement_controller.c:22` |
| Reset Movement Controller | `reset_movement_controller` | `src/movement_controller.c:64` |
| Advance Step Timer | `advance_step_timer` | `src/step_timer.c:10` |
| Start Step Timer | `start_step_timer` | `src/step_timer.c:26` |
| Reset Step Timer | `reset_step_timer` | `src/step_timer.c:33` |
| Derive Movement Status | `derive_movement_status` | `src/derive_movement_status.c:4` |
| Track Power-Up | `track_power_up` | `src/power_up_timer.c:11` |
| Reset Power-Up Timer | `reset_power_up_timer` | `src/power_up_timer.c:37` |
| Decide Cleaning | `decide_cleaning` | `src/decide_cleaning.c:4` |
| Put Outputs | `put_outputs` | `src/put_outputs.c:7` |
| Issue Movement Output | `issue_movement_output` | `src/issue_movement_output.c:15` |

Boundary APIs are receive_input_event(InputMode) → InputEvent, drive_motor(Direction), and drive_cleaner(Clean). They are declared in include/hw_interface.h and supplied by tests/fake_hw.cpp or simulator/host/sim_host.c. Initial mode supplies four actual samples; running mode supplies sensor/Tick receipt order. Real hardware implementation remains excluded by B6.

New data types: InputKind/InputMode/InputEvent and DustExistence(current,pending). Get Inputs returns ObstacleSituation; Decide Actions takes only that situation; Track Power-Up takes only MovementStatus and accesses private D2 through value-copy getters. Reset Movement Controller returns void. Calls are recorded in tests/expected_calls.txt (31) and checked against GCC call data.

Evidence: [current correction report](../Review/20261118-213657-phase5-fixes/verification/report.md). Historical implementation mappings were superseded; prior review snapshots remain in artifacts/Review.
