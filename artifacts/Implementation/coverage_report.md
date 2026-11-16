# Test Coverage Report

Measured with gcov on the C production code. A branch counts as covered when
that outcome was taken at least once.

| Source file | Lines executed | Branch outcomes taken |
|---|---|---|
| assess_obstacle_situation.c | 9 / 9 | 6 / 6 |
| controller.c | 5 / 5 | 0 / 0 |
| decide_actions.c | 6 / 6 | 0 / 0 |
| decide_cleaning.c | 7 / 7 | 4 / 4 |
| derive_movement_status.c | 5 / 5 | 2 / 2 |
| detect_dust.c | 2 / 2 | 0 / 0 |
| detect_obstacle.c | 5 / 5 | 0 / 0 |
| get_inputs.c | 5 / 5 | 0 / 0 |
| initialize_rvc.c | 5 / 5 | 0 / 0 |
| issue_movement_output.c | 3 / 3 | 0 / 0 |
| movement_controller.c | 26 / 26 | 16 / 16 |
| power_up_timer.c | 14 / 14 | 8 / 8 |
| put_outputs.c | 4 / 4 | 0 / 0 |
| step_timer.c | 16 / 16 | 4 / 4 |
| main.c | 4 / 4 | 0 / 0 |
| **Total** | **116 / 116 (100.0%)** | **40 / 40 (100.0%)** |

## Uncovered code

- None: every line was executed and every branch outcome was taken.

## How it was measured

- Date: 2026-11-16. Tool: gcov 15.2.0. Build flags: `--coverage -O0 -g`.
- Command: `cmake --build build --target coverage`. It deletes old coverage data, runs all tests through CTest, and summarizes the gcov data (`cmake/coverage.cmake`). The same table is written to `build/coverage/summary.md`.
- Measured code: every file under `src/`. `main.c` is measured in its test build, where `main` is renamed to `rvc_main`.
- Not measured: the tests and the fake hardware, which are not production code.
- Files with 0 branches contain no decision; they only call other modules in sequence.

## Note on the project path

The project folder name contains Korean characters. A test program built with GCC on Windows cannot write its coverage data to such a path directly, so a plain `ctest` run writes no coverage data here. The `coverage` target sets `GCOV_PREFIX` and `GCOV_PREFIX_STRIP` so that the data is written to the same build directory. Test results are not affected.
