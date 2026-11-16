# RVC System Test Scenarios

Generated from `simulator/public/scenarios.js` by `node simulator/generate_docs.js`.
Requirement IDs: B1-B7 (`docs/preliminary_requirements.md`), C1-C11 and Q6 (`docs/requirements_clarifications.md`).

## 1. Test Design Policy

- 21 scenarios, each on the 10x10 grid, each run for at most 100 ticks.
- Coordinates are (x, y). (0,0) is the top left cell, x grows to the right, y grows downward.
- The grid boundary acts as a wall. The default start is (4,4), heading N.
- The test oracle is the human evaluator. The simulator assigns no PASS or FAIL.
- "Expected Behavior" is derived from the requirements and the approved SA artifacts. Tick numbers follow from the 5-tick durations (C3, C6, C7, C8) and from the simulator's map rules, which are listed in `simulator/README.md`.

## 2. Essential System Functions

| ID | Function | Requirements |
|---|---|---|
| F1 | Go forward while cleaning | B1, B2 |
| F2 | Stop moving and cleaning for 5 ticks at an obstacle | B3, C2, C7 |
| F3 | Turn right for 5 ticks when the right is open | B3, C1, C8 |
| F4 | Turn left for 5 ticks when only the left is open | B3, C8 |
| F5 | Go forward with cleaning after turning aside | B3 |
| F6 | Move backward for 5 ticks when front, left, and right are blocked | B4, C6 |
| F7 | After moving backward, turn by left and right only | B4, C5, C9 |
| F8 | Move backward again when left and right are still blocked | C5, C6, C9 |
| F9 | Power up the cleaning for 5 ticks when dust is detected | B5, C3 |
| F10 | Restart the 5 ticks when dust is detected during a power-up | C10 |
| F11 | Continue an interrupted power-up after the avoidance | C11 |
| F12 | Keep the cleaning stopped during the whole avoidance | B3 |
| F13 | Ignore side obstacles while the front is clear | Q6 (assumption) |

## 3. Scenarios

### ST-01: Empty room

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: none
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 3: F3 Turn right for 5 ticks when the right is open
- Essential Function 4: F5 Go forward with cleaning after turning aside
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B3, C2, C7, C1, C8
- Related SA Artifacts: FSM T1; Process Specification 4.2; FSM T2, T3; FSM T4, T11; Process Specification 3.1; FSM T12, T14; Process Specification 3.2.3, 4.2

**Expected Behavior**

Goes forward with Clean Start for ticks 1-4 and reaches the top wall. Stops with Clean Stop for ticks 5-9. Both sides are open, so it turns right for ticks 10-14 and then goes forward with cleaning along the wall. It repeats stop, right turn, forward at every wall, travelling clockwise around the room.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-02: Obstacle ahead, both sides open

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (4,1)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 3: F3 Turn right for 5 ticks when the right is open
- Essential Function 4: F5 Go forward with cleaning after turning aside
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B3, C2, C7, C1, C8
- Related SA Artifacts: FSM T1; Process Specification 4.2; FSM T2, T3; FSM T4, T11; Process Specification 3.1; FSM T12, T14; Process Specification 3.2.3, 4.2

**Expected Behavior**

Goes forward for ticks 1-2 to (4,2). The obstacle at (4,1) is in front: stops with Clean Stop for ticks 3-7. Both sides are open, so it turns right for ticks 8-12 (C1) and goes forward east with cleaning from tick 13.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-03: Obstacle ahead, right blocked

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (4,1) (5,2)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 3: F4 Turn left for 5 ticks when only the left is open
- Essential Function 4: F5 Go forward with cleaning after turning aside
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B3, C2, C7, C8
- Related SA Artifacts: FSM T1; Process Specification 4.2; FSM T2, T3; FSM T5, T13; Process Specification 3.1; FSM T12, T14; Process Specification 3.2.3, 4.2

**Expected Behavior**

Goes forward to (4,2) and stops for ticks 3-7. The right cell (5,2) is blocked and the left is open, so it turns left for ticks 8-12 and goes forward west with cleaning from tick 13.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-04: Obstacle ahead, left blocked

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (4,1) (3,2)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 3: F3 Turn right for 5 ticks when the right is open
- Essential Function 4: F5 Go forward with cleaning after turning aside
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B3, C2, C7, C1, C8
- Related SA Artifacts: FSM T1; Process Specification 4.2; FSM T2, T3; FSM T4, T11; Process Specification 3.1; FSM T12, T14; Process Specification 3.2.3, 4.2

**Expected Behavior**

Goes forward to (4,2) and stops for ticks 3-7. The left cell (3,2) is blocked and the right is open, so it turns right for ticks 8-12 and goes forward east with cleaning from tick 13.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-05: Dead end in the open

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (4,1) (3,2) (5,2)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F6 Move backward for 5 ticks when front, left, and right are blocked
- Essential Function 3: F7 After moving backward, turn by left and right only
- Essential Function 4: F5 Go forward with cleaning after turning aside
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, B4, C6, C5, C9
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; FSM T6, T7; FSM T9, T10; Process Specification 3.1; FSM T12, T14; Process Specification 3.2.3, 4.2

**Expected Behavior**

Goes forward to (4,2), where front, left, and right are blocked. Stops for ticks 3-7, then moves backward for ticks 8-12 to (4,7). There both sides are open, so it turns right for ticks 13-17 and goes forward east with cleaning from tick 18. Clean is Stop from tick 3 to tick 17.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-06: Closed corridor

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,6)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (3,0) (3,1) (3,2) (3,3) (3,4) (3,5) (3,6) (3,7) (3,8) (3,9) (5,0) (5,1) (5,2) (5,3) (5,4) (5,5) (5,6) (5,7) (5,8) (5,9)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 3: F6 Move backward for 5 ticks when front, left, and right are blocked
- Essential Function 4: F8 Move backward again when left and right are still blocked
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B3, C2, C7, B4, C6, C5, C9
- Related SA Artifacts: FSM T1; Process Specification 4.2; FSM T2, T3; FSM T6, T7; FSM T8; Process Specification 3.2.3, 4.2

**Expected Behavior**

Goes forward to the top of the corridor (4,0) in ticks 1-6 and stops for ticks 7-11. All three sides are blocked: moves backward for ticks 12-16. The corridor walls still block left and right, so it moves backward again, 5 ticks at a time, for the rest of the run. Once it reaches the bottom wall it cannot move further. Clean stays Stop from tick 7. The requirements give no way out of a corridor closed on both sides.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-07: Corridor that opens to the left

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (5,0) (5,1) (5,2) (5,3) (5,4) (5,5) (5,6) (5,7) (5,8) (5,9) (3,0) (3,1) (3,2) (3,3)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F6 Move backward for 5 ticks when front, left, and right are blocked
- Essential Function 3: F7 After moving backward, turn by left and right only
- Essential Function 4: F4 Turn left for 5 ticks when only the left is open
- Essential Function 5: F5 Go forward with cleaning after turning aside

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, B4, C6, C5, C9, C8
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; FSM T6, T7; FSM T9, T10; Process Specification 3.1; FSM T5, T13; FSM T12, T14

**Expected Behavior**

Reaches (4,0) at tick 4 and stops for ticks 5-9 with front, left, and right blocked. Moves backward for ticks 10-14 to (4,5). There the right is still blocked and the left is open, so it turns left for ticks 15-19 (C5, C9) and goes forward west with cleaning from tick 20. The front sensor reads clear at tick 15 and is not used.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-08: Corridor that opens to the right

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (3,0) (3,1) (3,2) (3,3) (3,4) (3,5) (3,6) (3,7) (3,8) (3,9) (5,0) (5,1) (5,2) (5,3)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F6 Move backward for 5 ticks when front, left, and right are blocked
- Essential Function 3: F7 After moving backward, turn by left and right only
- Essential Function 4: F3 Turn right for 5 ticks when the right is open
- Essential Function 5: F5 Go forward with cleaning after turning aside

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, B4, C6, C5, C9, C1, C8
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; FSM T6, T7; FSM T9, T10; Process Specification 3.1; FSM T4, T11; FSM T12, T14

**Expected Behavior**

Reaches (4,0) at tick 4 and stops for ticks 5-9 with front, left, and right blocked. Moves backward for ticks 10-14 to (4,5). There the right is open, so it turns right for ticks 15-19 (C5, C9) and goes forward east with cleaning from tick 20.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-09: Backward twice, then turn

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,3)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (3,0) (3,1) (3,2) (3,3) (3,4) (3,5) (3,6) (3,7) (3,8) (5,0) (5,1) (5,2) (5,3) (5,4) (5,5) (5,6) (5,7) (5,8)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F6 Move backward for 5 ticks when front, left, and right are blocked
- Essential Function 3: F8 Move backward again when left and right are still blocked
- Essential Function 4: F7 After moving backward, turn by left and right only
- Essential Function 5: F5 Go forward with cleaning after turning aside

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, B4, C6, C5, C9
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; FSM T6, T7; FSM T8; FSM T9, T10; Process Specification 3.1; FSM T12, T14

**Expected Behavior**

Reaches (4,0) at tick 3 and stops for ticks 4-8. Moves backward for ticks 9-13 to (4,5), where both sides are still blocked. Moves backward again for ticks 14-18 and ends at (4,9), below the corridor walls. Both sides are open there, so it turns right for ticks 19-23 and goes forward east with cleaning from tick 24.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-10: Dust on a straight path

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,8)
- Initial Direction: N (up, toward y = 0)
- Obstacles: none
- Dust: (4,6)
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F9 Power up the cleaning for 5 ticks when dust is detected
- Essential Function 3: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 4: F3 Turn right for 5 ticks when the right is open

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B5, C3, B3, C2, C7, C1, C8
- Related SA Artifacts: FSM T1; Process Specification 4.2; Process Specification 4.1, 4.2; FSM T2, T3; FSM T4, T11; Process Specification 3.1

**Expected Behavior**

Goes forward with Clean Start for ticks 1-2 and is on the dust cell (4,6) at tick 3. Clean is Power Up for ticks 3-7 while it keeps going forward; the dust is removed. Clean is Start again at tick 8. It reaches the top wall, stops for ticks 9-13, and turns right.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-11: Second dust during a power-up

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,8)
- Initial Direction: N (up, toward y = 0)
- Obstacles: none
- Dust: (4,6) (4,4)
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F9 Power up the cleaning for 5 ticks when dust is detected
- Essential Function 2: F10 Restart the 5 ticks when dust is detected during a power-up
- Essential Function 3: F11 Continue an interrupted power-up after the avoidance
- Essential Function 4: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B5, C3, C10, C11, B3, C2, C7
- Related SA Artifacts: Process Specification 4.1, 4.2; Process Specification 4.1; FSM T2, T3; Process Specification 4.2; Process Specification 3.2.3, 4.2

**Expected Behavior**

Clean is Power Up from tick 3 (dust at (4,6)). At tick 5 it is on the second dust cell (4,4) and the 5 ticks start again (C10), so Clean stays Power Up through tick 8. At tick 9 the top wall is in front: it stops and Clean is Stop, with 1 power-up tick left. After the stop (ticks 9-13) and the right turn (ticks 14-18) it goes forward with Clean Power Up at tick 19 (C11) and Clean Start from tick 20.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-12: Two separate power-ups

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,9)
- Initial Direction: N (up, toward y = 0)
- Obstacles: none
- Dust: (4,9) (4,2)
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F9 Power up the cleaning for 5 ticks when dust is detected
- Essential Function 3: F11 Continue an interrupted power-up after the avoidance
- Essential Function 4: F2 Stop moving and cleaning for 5 ticks at an obstacle

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B5, C3, C11, B3, C2, C7
- Related SA Artifacts: FSM T1; Process Specification 4.2; Process Specification 4.1, 4.2; Process Specification 4.1; FSM T2, T3

**Expected Behavior**

The start cell has dust: Clean is Power Up for ticks 1-5, then Start for ticks 6-7. At tick 8 it is on the second dust cell (4,2): Clean is Power Up for ticks 8-9. At tick 10 the top wall is in front and it stops with Clean Stop, 3 power-up ticks left. After the stop and the right turn it goes forward with Clean Power Up for ticks 20-22 and Clean Start from tick 23.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-13: Power-up interrupted by an obstacle

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,6)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (4,2)
- Dust: (4,4)
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F9 Power up the cleaning for 5 ticks when dust is detected
- Essential Function 2: F11 Continue an interrupted power-up after the avoidance
- Essential Function 3: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 4: F3 Turn right for 5 ticks when the right is open
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B5, C3, C11, B3, C2, C7, C1, C8
- Related SA Artifacts: Process Specification 4.1, 4.2; Process Specification 4.1; FSM T2, T3; Process Specification 4.2; FSM T4, T11; Process Specification 3.1; Process Specification 3.2.3, 4.2

**Expected Behavior**

At tick 3 it is on the dust cell (4,4): Clean is Power Up and it moves to (4,3). At tick 4 the obstacle is in front: it stops for ticks 4-8 with Clean Stop. It turns right for ticks 9-13 with Clean Stop. From tick 14 it goes forward east, with Clean Power Up for the 4 remaining ticks 14-17 (C11) and Clean Start from tick 18.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-14: Dust where the RVC stops

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,6)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (4,2)
- Dust: (4,3)
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F12 Keep the cleaning stopped during the whole avoidance
- Essential Function 3: F9 Power up the cleaning for 5 ticks when dust is detected
- Essential Function 4: F3 Turn right for 5 ticks when the right is open
- Essential Function 5: F5 Go forward with cleaning after turning aside

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, B5, C3, C1, C8
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; Process Specification 3.2.3, 4.2; Process Specification 4.1, 4.2; FSM T4, T11; Process Specification 3.1; FSM T12, T14

**Expected Behavior**

Reaches (4,3) at tick 3. At tick 4 the obstacle is in front and the cell has dust: it stops, and Clean is Stop, not Power Up (B3). Clean stays Stop during the stop (ticks 4-8) and the right turn (ticks 9-13); the dust stays. At tick 14 it goes forward and the dust is still under it: Clean is Power Up for ticks 14-18 and the dust is removed.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-15: Obstacles beside the path only

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (3,3) (5,3) (3,2) (5,1)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F13 Ignore side obstacles while the front is clear
- Essential Function 2: F1 Go forward while cleaning
- Essential Function 3: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 4: F3 Turn right for 5 ticks when the right is open

**Requirement Traceability**
- Related Requirement IDs: Q6 (assumption), B1, B2, B3, C2, C7, C1, C8
- Related SA Artifacts: FSM T1; Process Specification 3.1; Process Specification 4.2; FSM T2, T3; FSM T4, T11

**Expected Behavior**

Obstacles lie to the left and right of the path but never in front. It goes forward with Clean Start for ticks 1-4 without stopping (Q6 assumption) and reaches the top wall. It stops for ticks 5-9 and turns right for ticks 10-14.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-16: Heading east

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: E (right)
- Obstacles: (7,4)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 3: F3 Turn right for 5 ticks when the right is open
- Essential Function 4: F5 Go forward with cleaning after turning aside

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B3, C2, C7, C1, C8
- Related SA Artifacts: FSM T1; Process Specification 4.2; FSM T2, T3; FSM T4, T11; Process Specification 3.1; FSM T12, T14

**Expected Behavior**

Goes forward east for ticks 1-2 to (6,4). Stops for ticks 3-7 in front of the obstacle at (7,4). Turns right for ticks 8-12, which is toward the south, and goes forward south with cleaning from tick 13.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-17: Heading south, right blocked

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: S (down)
- Obstacles: (4,7) (3,6)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F1 Go forward while cleaning
- Essential Function 2: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 3: F4 Turn left for 5 ticks when only the left is open
- Essential Function 4: F5 Go forward with cleaning after turning aside

**Requirement Traceability**
- Related Requirement IDs: B1, B2, B3, C2, C7, C8
- Related SA Artifacts: FSM T1; Process Specification 4.2; FSM T2, T3; FSM T5, T13; Process Specification 3.1; FSM T12, T14

**Expected Behavior**

Goes forward south for ticks 1-2 to (4,6). Stops for ticks 3-7 in front of (4,7). Its right side is the west cell (3,6), which is blocked; its left side (east) is open. Turns left for ticks 8-12 and goes forward east with cleaning from tick 13.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-18: Heading west into a dead end

**Initial Configuration**
- Grid: 10x10
- RVC Start: (3,4)
- Initial Direction: W (left)
- Obstacles: (1,4) (2,3) (2,5)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F6 Move backward for 5 ticks when front, left, and right are blocked
- Essential Function 3: F7 After moving backward, turn by left and right only
- Essential Function 4: F5 Go forward with cleaning after turning aside
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, B4, C6, C5, C9
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; FSM T6, T7; FSM T9, T10; Process Specification 3.1; FSM T12, T14; Process Specification 3.2.3, 4.2

**Expected Behavior**

Goes forward west to (2,4) at tick 1, where front, left, and right are blocked. Stops for ticks 2-6 and moves backward (east) for ticks 7-11 to (7,4). Both sides are open there: turns right for ticks 12-16, which is toward the north, and goes forward north with cleaning from tick 17.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-19: Start in a corner

**Initial Configuration**
- Grid: 10x10
- RVC Start: (0,0)
- Initial Direction: N (up, toward y = 0)
- Obstacles: none
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F3 Turn right for 5 ticks when the right is open
- Essential Function 3: F5 Go forward with cleaning after turning aside
- Essential Function 4: F1 Go forward while cleaning
- Essential Function 5: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, C1, C8, B1, B2
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; FSM T4, T11; Process Specification 3.1; FSM T12, T14; FSM T1; Process Specification 3.2.3, 4.2

**Expected Behavior**

The wall is in front at the first tick: it stops for ticks 1-5 without having moved. The left is the wall and the right is open: it turns right for ticks 6-10 and goes forward east with cleaning from tick 11. It then follows the walls clockwise.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-20: Obstacle and dust course

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (4,1)
- Dust: (6,2) (8,2)
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F3 Turn right for 5 ticks when the right is open
- Essential Function 3: F9 Power up the cleaning for 5 ticks when dust is detected
- Essential Function 4: F10 Restart the 5 ticks when dust is detected during a power-up
- Essential Function 5: F11 Continue an interrupted power-up after the avoidance
- Essential Function 6: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, C1, C8, B5, C3, C10, C11
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; FSM T4, T11; Process Specification 3.1; Process Specification 4.1, 4.2; Process Specification 4.1; Process Specification 3.2.3, 4.2

**Expected Behavior**

Stops in front of (4,1) for ticks 3-7 and turns right for ticks 8-12. Going east, it is on the dust cell (6,2) at tick 15: Clean is Power Up. At tick 17 it is on the dust cell (8,2) and the 5 ticks start again. At tick 18 the right wall is in front: it stops with Clean Stop and 4 power-up ticks left. After the stop (ticks 18-22) and the right turn (ticks 23-27) it goes forward south with Clean Power Up for ticks 28-31 and Clean Start from tick 32.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

### ST-21: Enclosed on all four sides

**Initial Configuration**
- Grid: 10x10
- RVC Start: (4,4)
- Initial Direction: N (up, toward y = 0)
- Obstacles: (4,3) (3,4) (5,4) (4,5)
- Dust: none
- Maximum Ticks: 100

**Test Objectives**
- Essential Function 1: F2 Stop moving and cleaning for 5 ticks at an obstacle
- Essential Function 2: F6 Move backward for 5 ticks when front, left, and right are blocked
- Essential Function 3: F8 Move backward again when left and right are still blocked
- Essential Function 4: F12 Keep the cleaning stopped during the whole avoidance

**Requirement Traceability**
- Related Requirement IDs: B3, C2, C7, B4, C6, C5, C9
- Related SA Artifacts: FSM T2, T3; Process Specification 4.2; FSM T6, T7; FSM T8; Process Specification 3.2.3, 4.2

**Expected Behavior**

Front, left, and right are blocked at the first tick: it stops for ticks 1-5. It then issues Backward for ticks 6-10, but the cell behind is also blocked and it does not move. Left and right stay blocked, so it issues Backward again, 5 ticks at a time, for the rest of the run. Clean is Stop throughout. The RVC has no rear sensor, and the requirements give no behavior for an enclosed RVC.

**Human Evaluation**
- Result: Pending (PASS / FAIL / INCONCLUSIVE)
- Evaluator:
- Observations:
- Related Tick(s):

## 4. Custom Map Testing

In the simulator, switch on "Edit", change obstacles, dust, the RVC start, and the initial direction at tick 0, and run the map like any scenario. "Save as new scenario" keeps it in the scenario list (IDs CU-01, CU-02, ...) in the browser, and "Export map" writes it to a file. A custom map has no predefined expectation; the evaluator judges it against the requirements.
