# Unit Test Report

System: RVC Controller
Date: 2026-11-16
Design basis: `artifacts/SD/structure_chart.md`, `artifacts/SA/DFD/dfd_level_4_fsm.md`, `artifacts/SA/process_specification.md`

## 1. Result

| Item | Result |
|---|---|
| Unit tests (GoogleTest) | 121 passed, 0 failed |
| Call hierarchy check | Passed: 26 of 26 calls match the Structure Chart |
| Total (CTest) | 122 passed, 0 failed |
| Line coverage | 116 / 116 (100.0%) |
| Branch coverage | 40 / 40 (100.0%) |
| Compiler warnings | 0 (`-Wall -Wextra -Wpedantic -Werror`) |

These numbers are from a clean build (build directory deleted first). Coverage detail is in `coverage_report.md`.

## 2. Environment

| Item | Value |
|---|---|
| Production code | C11, GCC 15.2.0 (MSYS2 mingw64) |
| Tests | C++17, G++ 15.2.0, GoogleTest 1.17.0 |
| Build | CMake 4.1.0, Ninja |
| Test runner | CTest |
| Coverage | gcov 15.2.0 |

Commands, from the project root, with the MSYS2 compiler first on `PATH`:

```text
cmake -S . -B build -G Ninja
cmake --build build
ctest --test-dir build --output-on-failure
cmake --build build --target coverage
```

On this PC the default `gcc` on `PATH` is an older one (6.3.0). The MSYS2 directory (`D:\MSYS2\mingw64\bin`) must come first.

## 3. Test approach

- Tests call the real modules. The only test double is the hardware interface (`tests/fake_hw.cpp`), which is the system boundary.
- Modules with hidden data are reset through their own reset modules before each test.
- `main()` never returns. For its tests, `main.c` is compiled a second time with `main` renamed to `rvc_main`, and the fake `wait_for_tick` leaves the loop after a set number of Ticks.

## 4. TDD cycles

Each cycle: write the tests and an empty stub, build, run CTest and see the tests fail (RED), implement, run CTest and see all tests pass (GREEN). The counts are the CTest results of each run.

| Cycle | Modules | RED: failed / total | GREEN: passed / total |
|---|---|---|---|
| 1 | Assess Obstacle Situation | 4 / 5 | 5 / 5 |
| 2 | Derive Movement Status, Decide Cleaning | 6 / 13 | 13 / 13 |
| 3 | Step Timer group | 8 / 22 | 22 / 22 |
| 4 | Movement Controller group | 25 / 49 | 49 / 49 |
| 5 | Power-Up Timer group | 8 / 61 | 61 / 61 |
| 6 | Detect Obstacle, Detect Dust, Get Inputs | 11 / 75 | 75 / 75 |
| 7 | Issue Movement Output, Put Outputs | 8 / 84 | 84 / 84 |
| 8 | Decide Actions | 6 / 92 | 92 / 92 |
| 9 | Initialize RVC, Controller, requirement scenarios | 22 / 116 | 116 / 116 |
| 10 | Main | 5 / 121 | 121 / 121 |

- In every RED run the earlier tests still passed; only tests of the new modules failed.
- Some new tests passed already in RED, because the empty stub happens to return the expected value (for example, a stub that returns Forward satisfies "keeps going forward while clear"). In cycle 4, 2 of the 27 new tests did so.
- No refactoring step changed behavior. The code was written in its final form in each GREEN step.
- The call hierarchy check and the coverage script were added after cycle 10. Each failed on its first run because of an error in the script, not in the production code, and was corrected.

## 5. Tests by module

| Test suite | Tests | Module(s) | Derived from |
|---|---|---|---|
| AssessObstacleSituation | 5 | Assess Obstacle Situation | Process Specification 3.1 |
| DeriveMovementStatus | 4 | Derive Movement Status | Process Specification 3.2.3 |
| DecideCleaning | 4 | Decide Cleaning | Process Specification 4.2 |
| StepTimerTest | 9 | Advance / Start / Reset Step Timer | Process Specification 3.2.4 |
| MovementControllerTest | 27 | Movement Controller, Reset Movement Controller | FSM T0-T14 |
| PowerUpTimerTest | 12 | Track Power-Up, Reset Power-Up Timer | Process Specification 4.1 |
| InputsTest | 14 | Detect Obstacle, Detect Dust, Get Inputs | Process Specifications 1, 2; Structure Chart |
| OutputsTest | 9 | Issue Movement Output, Put Outputs | Process Specification 3.2.3; Structure Chart |
| DecideActionsTest | 8 | Decide Actions | Structure Chart |
| InitializeRvcTest | 4 | Initialize RVC | FSM T0 |
| ControllerTest | 6 | Controller | Structure Chart; Event List |
| MainTest | 5 | Main | Structure Chart; Event List |
| RequirementsTest | 14 | Whole system through Controller | Requirements B1-B5, C1-C8 |
| **Total** | **121** | | |

### FSM transitions

Every transition has at least one test in `tests/test_movement_controller.cpp`, named after it.

| Transition | Tests |
|---|---|
| T0 | `T0_ResetReturnsForwardAndEntersForward`, `T0_ResetLeavesAnyStateAndStopsTheStepTimer` |
| T1 | `T1_ForwardKeepsGoingForwardWhileClear` |
| T2 | `T2_ForwardStopsWhenTheRightIsOpen`, `...WhenOnlyTheLeftIsOpen`, `...WhenAllBlocked` |
| T3 | `T3_StopLastsFiveTicks`, `T3_SituationIsIgnoredUntilTheStopEnds` |
| T4 | `T4_AfterTheStopTurnsRightWhenTheRightIsOpen` |
| T5 | `T5_AfterTheStopTurnsLeftWhenOnlyTheLeftIsOpen` |
| T6 | `T6_AfterTheStopMovesBackwardWhenAllBlocked` |
| T7 | `T7_BackwardLastsFiveTicks` |
| T8 | `T8_AfterBackingMovesBackwardAgainWhenStillAllBlocked`, `T8_TheSecondBackwardStepAlsoLastsFiveTicks` |
| T9 | `T9_AfterBackingTurnsRightWhenTheRightIsOpen` |
| T10 | `T10_AfterBackingTurnsLeftWhenOnlyTheLeftIsOpen` |
| T11 | `T11_RightTurnLastsFiveTicks` |
| T12 | `T12_AfterTheRightTurnGoesForward` |
| T13 | `T13_LeftTurnLastsFiveTicks` |
| T14 | `T14_AfterTheLeftTurnGoesForward` |
| Timing example of the FSM document | `TimingExample_ObstacleAheadWithTheRightOpen` |

## 6. Requirement traceability

Tests are in `tests/test_requirements.cpp` unless another file is named.

| Requirement | Verification |
|---|---|
| B1 Automatically cleans | `B1_B2_GoesStraightForwardWhileCleaning` |
| B2 Goes forward while cleaning | `B1_B2_GoesStraightForwardWhileCleaning` |
| B3 Obstacle: stop cleaning, turn aside, go forward with cleaning | `B3_C2_C7_StopsMovingAndCleaningForFiveTicksAtAnObstacle`, `B3_C1_C8_TurnsRightForFiveTicksWhenBothSidesAreClear`, `B3_TurnsRightWhenTheLeftIsBlocked`, `B3_C8_TurnsLeftForFiveTicksWhenTheRightIsBlocked`, `B3_GoesForwardWithCleaningAfterTurningAside` |
| B4 Front, left, right blocked: move backward, turn aside, go forward | `B4_C6_MovesBackwardForFiveTicksWhenFrontLeftAndRightAreBlocked`, `B4_C5_AfterBackingTurnsRightWhenTheRightIsClearThenGoesForward` |
| B5 Dust: power up the cleaning for a while | `B5_C3_PowersUpTheCleaningForFiveTicksWhenDustIsDetected`, `B5_DustDoesNotChangeTheMovement`, `B3_B5_ObstacleStopsTheCleaningEvenWithDust` |
| B6 No hardware detail | Not a behavior. Met by design: the hardware interface is declared only (`include/hw_interface.h`). |
| B7 Only the automatic cleaning function | Not a behavior. No other function is implemented. |
| C1 Both sides clear: turn right | `B3_C1_C8_TurnsRightForFiveTicksWhenBothSidesAreClear` |
| C2 Stop moving at an obstacle | `B3_C2_C7_StopsMovingAndCleaningForFiveTicksAtAnObstacle` |
| C3 Power-up lasts 5 ticks | `B5_C3_PowersUpTheCleaningForFiveTicksWhenDustIsDetected` |
| C4 Obstacles do not disappear | An assumption about the surroundings, not a behavior. No test. See G1 below. |
| C5 After moving backward: right, else left, else backward again | `B4_C5_AfterBackingTurnsRightWhenTheRightIsClearThenGoesForward`, `C5_AfterBackingTurnsLeftWhenOnlyTheLeftIsClear`, `C5_C6_AfterBackingMovesBackwardAgainWhenStillBlocked` |
| C6 Backward lasts 5 ticks | `B4_C6_MovesBackwardForFiveTicksWhenFrontLeftAndRightAreBlocked` |
| C7 Stop lasts 5 ticks | `B3_C2_C7_StopsMovingAndCleaningForFiveTicksAtAnObstacle` |
| C8 Turn lasts 5 ticks | `B3_C1_C8_TurnsRightForFiveTicksWhenBothSidesAreClear`, `B3_C8_TurnsLeftForFiveTicksWhenTheRightIsBlocked` |

Event List: Tick, Direction, and Clean are verified by `ControllerTest` and `MainTest` (one Direction and one Clean per Tick; every sensor read once per Tick).

### Tests that are not requirements

Four tests record what the code does where the approved artifacts give no rule. They pass, but passing proves nothing about a requirement. They exist so that a later decision shows up as a deliberate test change.

| Test | Records | Open item |
|---|---|---|
| `MovementControllerTest.Undefined_ClearWhenAStopOrBackwardStepEndsTurnsRight` | Clear at the end of a stop or backward step turns right | G1 |
| `PowerUpTimerTest.Provisional_Q4_DustDuringARunningPowerUpDoesNotRestartIt` | Count is not restarted | Q4 |
| `PowerUpTimerTest.Provisional_Q5_RemainingCountIsKeptWhileAvoiding` | Count is kept while avoiding | Q5 |
| `RequirementsTest.Assumption_Q6_SideObstaclesAloneDoNotTriggerAvoidance` | Side obstacles are ignored while the front is clear | Q6 |

### G1: a gap found during implementation

The FSM defines no transition for "a stop or backward step ends and the Situation Signal is Clear". The SA states that C4 makes this impossible.

For the stop this holds: the RVC does not move, so the front obstacle stays in front. For the backward step it depends on the sensor range. After the RVC has moved backward for 5 ticks, a front sensor with a short range no longer detects the obstacle, and the signal is Clear. The simulator will produce this case in every dead-end scenario.

C5 states the rule after moving backward in terms of left and right only. The Situation Signal cannot express that when the front is clear, because Assess Obstacle Situation then ignores left and right (Q6 assumption).

The code currently turns right in this case. A decision is needed before system testing. The choice affects the FSM, and one option changes the Situation Signal:

1. Keep it: Clear after backing turns right.
2. After backing, decide by left and right only, as C5 reads. This needs the Situation Signal to carry left and right when the front is clear.
3. Clear after backing goes forward.

## 7. Limits of this verification

- The hardware interface is replaced by a fake. No real sensor, clock, motor, or cleaner was involved.
- The tests check the commands sent on each Tick. They do not check where the RVC ends up on a floor; that is the purpose of the simulator.
- 100% coverage means every line and branch outcome ran in a test. It does not show that the undefined cases above behave as the project owner wants.
