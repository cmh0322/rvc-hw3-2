# Module Traceability (SD to Implementation)

System: RVC Controller
Design basis: `artifacts/SD/structure_chart.md` (approved 2026-11-15)
Language: C11, compiled with GCC 15.2.0 (`-std=c11 -Wall -Wextra -Wpedantic -Werror`, no warnings)

## 1. Modules

Each Structure Chart module is one C function. Each source file holds one module, or one hidden-data group. Every function is declared in the header of the same name under `include/`.

| Structure Chart module | C function | Source file | SA process |
|---|---|---|---|
| Main | `main` | `src/main.c` | 0 |
| Initialize RVC | `initialize_rvc` | `src/initialize_rvc.c` | FSM T0 |
| Controller | `controller` | `src/controller.c` | 0 |
| Get Inputs | `get_inputs` | `src/get_inputs.c` | — (afferent) |
| Detect Obstacle | `detect_obstacle` | `src/detect_obstacle.c` | 1 |
| Assess Obstacle Situation | `assess_obstacle_situation` | `src/assess_obstacle_situation.c` | 3.1 |
| Detect Dust | `detect_dust` | `src/detect_dust.c` | 2 |
| Decide Actions | `decide_actions` | `src/decide_actions.c` | — (central); 3.2.1 by parameter passing |
| Movement Controller | `movement_controller` | `src/movement_controller.c` | 3.2.2 (T1-T14) |
| Reset Movement Controller | `reset_movement_controller` | `src/movement_controller.c` | 3.2.2 (T0) |
| Advance Step Timer | `advance_step_timer` | `src/step_timer.c` | 3.2.4 |
| Start Step Timer | `start_step_timer` | `src/step_timer.c` | 3.2.4 |
| Reset Step Timer | `reset_step_timer` | `src/step_timer.c` | 3.2.4 |
| Derive Movement Status | `derive_movement_status` | `src/derive_movement_status.c` | 3.2.3 (Movement Status) |
| Track Power-Up | `track_power_up` | `src/power_up_timer.c` | 4.1 |
| Reset Power-Up Timer | `reset_power_up_timer` | `src/power_up_timer.c` | 4.1 |
| Decide Cleaning | `decide_cleaning` | `src/decide_cleaning.c` | 4.2 |
| Put Outputs | `put_outputs` | `src/put_outputs.c` | — (efferent) |
| Issue Movement Output | `issue_movement_output` | `src/issue_movement_output.c` | 3.2.3 (Direction) |

All 19 modules are implemented.

### Library modules (hardware interface)

Declared in `include/hw_interface.h`. They have no implementation in this project (B6). The unit tests supply `tests/fake_hw.cpp`.

| Library module | C function |
|---|---|
| Read Front Sensor | `read_front_sensor` |
| Read Left Sensor | `read_left_sensor` |
| Read Right Sensor | `read_right_sensor` |
| Read Dust Sensor | `read_dust_sensor` |
| Wait For Tick | `wait_for_tick` |
| Drive Motor | `drive_motor` |
| Drive Cleaner | `drive_cleaner` |

## 2. Interfaces

| C function | Parameters | Returns | Structure Chart interface (section 5) |
|---|---|---|---|
| `main(void)` | — | `int` (never returns) | — |
| `initialize_rvc(void)` | — | — | — |
| `controller(void)` | — | — | — |
| `get_inputs(void)` | — | `Inputs` = Obstacle Situation + Dust Existence | ↑ Obstacle Situation, Dust Existence |
| `detect_obstacle(void)` | — | `ObstacleLocation` | ↑ Obstacle Location |
| `assess_obstacle_situation(ObstacleLocation)` | Obstacle Location | `ObstacleSituation` | ↓ Obstacle Location, ↑ Obstacle Situation |
| `detect_dust(void)` | — | `bool` Dust Existence | ↑ Dust Existence |
| `decide_actions(ObstacleSituation, bool)` | Obstacle Situation, Dust Existence | `Actions` = Movement Command + Clean | ↓ both inputs, ↑ Clean, ↑ Movement Command |
| `movement_controller(SituationSignal)` | Situation Signal | `MovementCommand` | ↓ Situation Signal, ↑ Movement Command |
| `reset_movement_controller(void)` | — | `MovementCommand` (Forward) | ↑ Movement Command |
| `advance_step_timer(void)` | — | `bool` Step Done | ↑ Step Done |
| `start_step_timer(void)` | — | — | — |
| `reset_step_timer(void)` | — | — | — |
| `derive_movement_status(MovementCommand)` | Movement Command | `MovementStatus` | ↓ Movement Command, ↑ Movement Status |
| `track_power_up(MovementStatus, bool)` | Movement Status, Dust Existence | `bool` Power-Up Active | ↓ both inputs, ↑ Power-Up Active |
| `reset_power_up_timer(void)` | — | — | — |
| `decide_cleaning(MovementStatus, bool)` | Movement Status, Power-Up Active | `Clean` | ↓ both inputs, ↑ Clean |
| `put_outputs(MovementCommand, Clean)` | Movement Command, Clean | — | ↓ Movement Command, ↓ Clean |
| `issue_movement_output(MovementCommand)` | Movement Command | — | ↓ Movement Command |

Data types are in `include/rvc_types.h` and follow the Data Dictionary.

`Inputs` and `Actions` are two small structures that let `get_inputs` and `decide_actions` return their two values by value. They carry exactly the items of the Structure Chart interface. No pointers are passed between modules, so there is nothing to check before dereferencing.

## 3. Hidden data

| Group | Source file | Hidden data (`static`) | SA origin |
|---|---|---|---|
| Movement Controller | `src/movement_controller.c` | `controller_state` | FSM states |
| Step Timer | `src/step_timer.c` | `step_ticks_elapsed` | D4 |
| Power-Up Timer | `src/power_up_timer.c` | `remaining_power_up_ticks` | D3 |

There are no global variables. D1 and D2 are return values passed within one cycle (design decision 1).

## 4. Call hierarchy

The `call_hierarchy` test compares the calls GCC recorded for the compiled code (`-fcallgraph-info`) with the 26 calls of Structure Chart section 5, listed in `tests/expected_calls.txt`.

Result: 26 of 26 calls match. The code has no call that is not in the chart, and the chart has no call that is missing from the code.

## 5. Differences from the Structure Chart

There are no differences in modules, interfaces, or calls. The following are additions the design already allows or does not cover.

| Item | What | Basis |
|---|---|---|
| Read-only queries | `get_controller_state`, `get_step_ticks_elapsed`, `get_remaining_power_up_ticks` | Design decision 4 (approved). No production module calls them. |
| `Inputs`, `Actions` | Return structures | See section 2. |
| No executable | `main.c` is compiled and tested, but no program is linked | The hardware interface has no implementation (B6). The simulator phase supplies one. |

## 6. Behavior the approved artifacts leave undefined

The code must do something in these cases. Each is isolated in one place and has a test that is marked as not being a requirement.

| ID | Case | What the code does | Where | Needs |
|---|---|---|---|---|
| G1 | A stop or backward step ends and the Situation Signal is Clear. The FSM has no transition, because C4 rules this out. | Turns right, the default of C1 and C5. | `movement_controller`, final `else` | Decision. After moving backward, the front may no longer be detected. See test report section 6. |
| Q4 | Dust detected while a power-up is running | Count continues; it is not restarted. | `track_power_up` | Decision |
| Q5 | Avoidance interrupts a power-up | Remaining count is kept and continues afterwards. | `track_power_up` | Decision |
| Q6 | Left or right obstacle while the front is clear | Ignored (assumption of the SA). | `assess_obstacle_situation` | Confirmation |

Q4 and Q5 follow the pseudocode of Process Specification 4.1 as written.
