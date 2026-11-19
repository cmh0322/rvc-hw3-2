# Coverage Summary

Measured with gcov on the C production code. A branch counts as covered when
that outcome was taken at least once.

| Source file | Lines executed | Branch outcomes taken |
|---|---|---|
| assess_obstacle_situation.c | 8 / 8 | 4 / 4 |
| controller.c | 5 / 5 | 0 / 0 |
| decide_actions.c | 6 / 6 | 0 / 0 |
| decide_cleaning.c | 7 / 7 | 4 / 4 |
| derive_movement_status.c | 5 / 5 | 2 / 2 |
| get_inputs.c | 3 / 3 | 0 / 0 |
| initialize_rvc.c | 6 / 6 | 0 / 0 |
| input_events.c | 12 / 12 | 6 / 6 |
| issue_movement_output.c | 3 / 3 | 0 / 0 |
| movement_controller.c | 26 / 26 | 16 / 16 |
| power_up_timer.c | 16 / 16 | 8 / 8 |
| put_outputs.c | 4 / 4 | 0 / 0 |
| sensor_store.c | 20 / 20 | 18 / 18 |
| step_timer.c | 16 / 16 | 4 / 4 |
| main.c | 3 / 3 | 0 / 0 |
| **Total** | **140 / 140 (100.0%)** | **62 / 62 (100.0%)** |

## Uncovered code

- None: every line was executed and every branch outcome was taken.

Measured 2026-11-18 after approved SD corrections. Commands/logs: artifacts/Review/20261118-213657-phase5-fixes/verification/. This is C unit-test coverage; hardware and browser JavaScript coverage are excluded.
