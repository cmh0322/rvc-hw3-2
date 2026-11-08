# Process Specification

Current coverage: DFD Levels 0-3.

Requirement references: B1-B7 are bullets of `docs/preliminary_requirements.md`, by order. C1-C8 and Q1-Q6 are entries of `docs/requirements_clarifications.md`. Q1-Q3 were resolved by C5-C7 on 2026-11-08; earlier levels keep their Q references and note the resolution.

# DFD Level 0

## Process 0: RVC Controller

### Process Identification

| Field | Description |
|---|---|
| Process ID | 0 |
| Process Name | RVC Controller |
| DFD Level | Level 0 |
| Parent Process | None |

### Purpose
Control the movement and cleaning of the RVC automatically, using obstacle and dust detection.

### Inputs
- Front Sensor Input
- Left Sensor Input
- Right Sensor Input
- Dust Sensor Input
- Tick (control)

### Outputs
- Direction
- Clean

### Trigger / Execution Condition
- Executes on every Tick.

### Processing Logic
1. Without a front obstacle, go forward while cleaning.
2. With a front obstacle, stop cleaning and stop moving.
3. If the right is clear, turn right. If only the left is clear, turn left.
4. If front, left, and right are all blocked, move backward and then turn aside.
5. After turning aside, go forward with cleaning.
6. If dust is detected, power up the cleaning for 5 ticks, then return to normal cleaning.

The stop, backward, and turn steps span several ticks. Their sequencing is refined at lower DFD levels and in the Controller FSM. Q1-Q6 remain open and limit that refinement.

### Pseudocode

```text
ON Tick:
    IF Front Sensor Input == TRUE THEN
        Clean = Stop
        Direction = Stop
        IF Left Sensor Input == TRUE AND Right Sensor Input == TRUE THEN
            Direction = Backward
            turn aside after moving backward          (Q1)
        ELSE IF Right Sensor Input == FALSE THEN
            Direction = Turn Right
        ELSE
            Direction = Turn Left
        END IF
    ELSE
        Direction = Forward
        IF Dust Sensor Input == TRUE THEN
            Clean = Power Up for 5 ticks              (Q4, Q5)
        ELSE
            Clean = Start, unless powering up
        END IF
    END IF
```

### Relevant Requirements
- B1, B2, B3, B4, B5, B7
- C1, C2, C3

# DFD Level 1

## Process 1: Detect Obstacle

### Process Identification

| Field | Description |
|---|---|
| Process ID | 1 |
| Process Name | Detect Obstacle |
| DFD Level | Level 1 |
| Parent Process | 0 |

### Purpose
Interpret the three obstacle sensors and record where obstacles are.

### Inputs
- Front Sensor Input
- Left Sensor Input
- Right Sensor Input

### Outputs
- Obstacle Location (to D1 Obstacle Location)

### Trigger / Execution Condition
- When any obstacle sensor input is received.

### Processing Logic
1. Read the three sensor inputs.
2. Store each value as the matching field of Obstacle Location in D1.

### Pseudocode

```text
ON Front/Left/Right Sensor Input:
    Obstacle Location.Front Obstacle = Front Sensor Input
    Obstacle Location.Left Obstacle  = Left Sensor Input
    Obstacle Location.Right Obstacle = Right Sensor Input
    WRITE Obstacle Location TO D1
```

### Relevant Requirements
- B3, B4, C1

## Process 2: Detect Dust

### Process Identification

| Field | Description |
|---|---|
| Process ID | 2 |
| Process Name | Detect Dust |
| DFD Level | Level 1 |
| Parent Process | 0 |

### Purpose
Interpret the dust sensor and record whether dust is present.

### Inputs
- Dust Sensor Input

### Outputs
- Dust Existence (to D2 Dust Existence)

### Trigger / Execution Condition
- When the dust sensor input is received.

### Processing Logic
1. Read the dust sensor input.
2. Store it as Dust Existence in D2.

### Pseudocode

```text
ON Dust Sensor Input:
    Dust Existence.Dust Detected = Dust Sensor Input
    WRITE Dust Existence TO D2
```

### Relevant Requirements
- B5

## Process 3: Control Movement

### Process Identification

| Field | Description |
|---|---|
| Process ID | 3 |
| Process Name | Control Movement |
| DFD Level | Level 1 |
| Parent Process | 0 |

### Purpose
Decide the movement of the RVC from the obstacle locations, and tell Process 4 whether the RVC is moving forward or avoiding an obstacle.

### Inputs
- Obstacle Location (from D1 Obstacle Location)
- Tick (control)

### Outputs
- Direction (to Motor)
- Movement Status (to Process 4)

### Trigger / Execution Condition
- Executes on every Tick.

### Processing Logic
1. Read Obstacle Location from D1.
2. If there is no front obstacle, go forward and report Forward.
3. If there is a front obstacle, stop (C2) and report Avoiding.
4. Then, if the right is clear, turn right (C1). If only the left is clear, turn left.
5. If front, left, and right are all blocked, move backward, then turn aside (B4).
6. After turning aside, go forward and report Forward (B3).

Left and right obstacles are used only when there is a front obstacle (Q6 assumption). Steps 3-6 span several ticks; their sequencing and durations are refined at lower levels and limited by Q1-Q3.

### Pseudocode

```text
ON Tick:
    READ Obstacle Location FROM D1
    IF Front Obstacle == FALSE THEN
        Direction = Forward
        Movement Status = Forward
    ELSE
        Movement Status = Avoiding
        Direction = Stop                               (C2, Q3)
        IF Right Obstacle == FALSE THEN
            Direction = Turn Right                     (C1)
        ELSE IF Left Obstacle == FALSE THEN
            Direction = Turn Left
        ELSE
            Direction = Backward                       (B4, Q2)
            turn aside after moving backward           (Q1)
        END IF
    END IF
```

### Relevant Requirements
- B2, B3, B4, C1, C2
- Resolved later: Q1 (C5), Q2 (C6), Q3 (C7). Open: Q6 (assumed)

## Process 4: Control Cleaning

### Process Identification

| Field | Description |
|---|---|
| Process ID | 4 |
| Process Name | Control Cleaning |
| DFD Level | Level 1 |
| Parent Process | 0 |

### Purpose
Decide the cleaning command from the movement status and dust existence, including the 5-tick power-up.

### Inputs
- Movement Status (from Process 3)
- Dust Existence (from D2 Dust Existence)
- Tick (control)

### Outputs
- Clean (to Cleaner)

### Trigger / Execution Condition
- Executes on every Tick.

### Processing Logic
1. If Movement Status is Avoiding, stop cleaning (B3).
2. If Movement Status is Forward, clean (B2). This also resumes cleaning after avoidance (B3).
3. While moving forward, if dust is detected, power up the cleaning for 5 ticks (B5, C3).
4. Count Ticks during power-up. After 5 ticks, return to normal cleaning.

### Pseudocode

```text
ON Tick:
    READ Dust Existence FROM D2
    IF Movement Status == Avoiding THEN
        Clean = Stop                                   (B3; power-up count: Q5)
    ELSE
        IF Dust Detected == TRUE THEN
            start power-up of 5 ticks                  (C3; re-detection: Q4)
        END IF
        IF power-up active THEN
            Clean = Power Up
            decrease remaining power-up ticks
        ELSE
            Clean = Start
        END IF
    END IF
```

### Relevant Requirements
- B1, B2, B3, B5, C3
- Open: Q4, Q5

# DFD Level 2

Processes 1 (Detect Obstacle) and 2 (Detect Dust) are functional primitives and are not decomposed. Their Level 1 specifications remain in force. Processes 3 and 4 are decomposed below.

## Process 3.1: Assess Obstacle Situation

### Process Identification

| Field | Description |
|---|---|
| Process ID | 3.1 |
| Process Name | Assess Obstacle Situation |
| DFD Level | Level 2 |
| Parent Process | 3 |

### Purpose
Classify the current obstacles into one Obstacle Situation.

### Inputs
- Obstacle Location (from D1 Obstacle Location)
- Tick (control)

### Outputs
- Obstacle Situation (to Process 3.2)

### Trigger / Execution Condition
- Executes on every Tick.

### Processing Logic
1. Read Obstacle Location from D1.
2. If the front is clear, the situation is Clear. Left and right are ignored (Q6 assumption).
3. If the front is blocked and the right is clear, the situation is Right Open (C1: right has priority).
4. If the front and right are blocked and the left is clear, the situation is Left Open.
5. If front, left, and right are all blocked, the situation is All Blocked (B4).

### Pseudocode

```text
ON Tick:
    READ Obstacle Location FROM D1
    IF Front Obstacle == FALSE THEN
        Obstacle Situation = Clear                    (Q6)
    ELSE IF Right Obstacle == FALSE THEN
        Obstacle Situation = Right Open               (C1)
    ELSE IF Left Obstacle == FALSE THEN
        Obstacle Situation = Left Open
    ELSE
        Obstacle Situation = All Blocked              (B4)
    END IF
```

### Relevant Requirements
- B3, B4, C1
- Assumption: Q6

## Process 3.2: Decide Movement

### Process Identification

| Field | Description |
|---|---|
| Process ID | 3.2 |
| Process Name | Decide Movement |
| DFD Level | Level 2 |
| Parent Process | 3 |

### Purpose
Sequence the movement over ticks from the Obstacle Situation and send the Direction to the Motor. Report whether the RVC is moving forward or avoiding.

### Inputs
- Obstacle Situation (from Process 3.1)
- Tick (control)

### Outputs
- Direction (to Motor)
- Movement Status (to Process 4)

### Trigger / Execution Condition
- Executes on every Tick, after 3.1.

### Processing Logic
1. While moving forward with situation Clear, keep going forward and report Forward (B2).
2. When the situation becomes non-Clear while moving forward, stop first and report Avoiding (B3, C2).
3. After stopping: if Right Open, turn right (C1); if Left Open, turn left; if All Blocked, move backward (B4).
4. After moving backward, turn aside (B4; direction and blocked-again case: Q1).
5. After turning, go forward and report Forward (B3, B4).

The current avoidance step (Forward, Stopping, Turning, Backing) persists across ticks. Its durations are open (Q2, Q3). Obstacles do not disappear (C4), so the situation that caused the stop stays non-Clear until the turn. Level 3 separates this sequencing into the Controller.

### Pseudocode

```text
ON Tick:
    CASE current step OF
    Forward:
        IF Obstacle Situation == Clear THEN
            Direction = Forward;  Movement Status = Forward
        ELSE
            Direction = Stop;     Movement Status = Avoiding;  step = Stopping   (C2)
        END IF
    Stopping:                                          (duration: Q3)
        Movement Status = Avoiding
        IF Obstacle Situation == Right Open THEN  Direction = Turn Right; step = Turning   (C1)
        ELSE IF Obstacle Situation == Left Open THEN  Direction = Turn Left; step = Turning
        ELSE  Direction = Backward; step = Backing    (All Blocked; B4)
        (Clear is not possible here: obstacles do not disappear, C4)
    Backing:                                           (duration: Q2)
        Movement Status = Avoiding
        Direction = Turn Left or Turn Right; step = Turning                  (Q1)
    Turning:
        Direction = Forward;  Movement Status = Forward;  step = Forward     (B3)
    END CASE
```

### Refinement (2026-11-08)
Q1-Q3 are resolved: Stopping, Backing, and Turning each last 5 ticks (C7, C6, C8). After Backing, the RVC turns right if the right is clear, turns left if only the left is clear, or backs again if left and right are still both blocked (C5). Process 3.2.2 and the Level 4 FSM carry the exact sequencing.

### Relevant Requirements
- B2, B3, B4, C1, C2, C4
- Resolved: Q1 (C5), Q2 (C6), Q3 (C7)

## Process 4.1: Track Power-Up

### Process Identification

| Field | Description |
|---|---|
| Process ID | 4.1 |
| Process Name | Track Power-Up |
| DFD Level | Level 2 |
| Parent Process | 4 |

### Purpose
Run the 5-tick powered-up cleaning period started by dust detection.

### Inputs
- Dust Existence (from D2 Dust Existence)
- Movement Status (from Process 3.2)
- Remaining Power-Up Ticks (from D3 Power-Up Timer)
- Tick (control)

### Outputs
- Power-Up Active (to Process 4.2)
- Remaining Power-Up Ticks (to D3 Power-Up Timer)

### Trigger / Execution Condition
- Executes on every Tick, after Movement Status for the tick is available.

### Processing Logic
1. Read Dust Existence from D2 and Remaining Power-Up Ticks from D3.
2. If moving forward and dust is detected with no power-up running, set the count to 5 (B5, C3).
3. If moving forward and the count is above 0, report Power-Up Active and count down by 1.
4. Otherwise report Power-Up Active = FALSE.
5. Write the count back to D3.

A power-up starting on tick t runs on ticks t to t+4, which is 5 ticks.

### Pseudocode

```text
ON Tick:
    READ Dust Existence FROM D2
    READ Remaining Power-Up Ticks FROM D3
    IF Movement Status == Forward THEN
        IF Dust Detected == TRUE AND Remaining Power-Up Ticks == 0 THEN
            Remaining Power-Up Ticks = 5               (C3)
        END IF
        (dust while Remaining > 0: restart or continue?  Q4)
        IF Remaining Power-Up Ticks > 0 THEN
            Power-Up Active = TRUE
            Remaining Power-Up Ticks = Remaining Power-Up Ticks - 1
        ELSE
            Power-Up Active = FALSE
        END IF
    ELSE
        Power-Up Active = FALSE
        (Remaining Power-Up Ticks: keep or clear?  Q5)
    END IF
    WRITE Remaining Power-Up Ticks TO D3
```

### Relevant Requirements
- B5, C3
- Open: Q4, Q5

## Process 4.2: Decide Cleaning

### Process Identification

| Field | Description |
|---|---|
| Process ID | 4.2 |
| Process Name | Decide Cleaning |
| DFD Level | Level 2 |
| Parent Process | 4 |

### Purpose
Choose the cleaning command for the current tick.

### Inputs
- Movement Status (from Process 3.2)
- Power-Up Active (from Process 4.1)

### Outputs
- Clean (to Cleaner)

### Trigger / Execution Condition
- When Power-Up Active for the tick arrives from 4.1.

### Processing Logic
1. While avoiding, stop cleaning (B3).
2. While moving forward with power-up active, power up the cleaning (B5).
3. While moving forward otherwise, clean normally (B1, B2). This also resumes cleaning after avoidance (B3).

### Pseudocode

```text
ON Power-Up Active:
    IF Movement Status == Avoiding THEN
        Clean = Stop
    ELSE IF Power-Up Active == TRUE THEN
        Clean = Power Up
    ELSE
        Clean = Start
    END IF
```

### Relevant Requirements
- B1, B2, B3, B5

# DFD Level 3

Only Process 3.2 (Decide Movement) is decomposed. Processes 1, 2, 3.1, 4.1, and 4.2 are functional primitives; their earlier specifications remain in force.

## Process 3.2.1: Signal Obstacle Situation

### Process Identification

| Field | Description |
|---|---|
| Process ID | 3.2.1 |
| Process Name | Signal Obstacle Situation |
| DFD Level | Level 3 |
| Parent Process | 3.2 |
| Process Type | Data |

### Purpose
Deliver the Obstacle Situation to the Movement Controller as a control signal.

### Inputs
- Obstacle Situation (from Process 3.1)

### Outputs
- Situation Signal (control, to Process 3.2.2)

### Trigger / Execution Condition
- When Obstacle Situation arrives from 3.1 (once per Tick).

### Processing Logic
1. Receive the Obstacle Situation.
2. Emit the Situation Signal with the same value.

### Pseudocode

```text
ON Obstacle Situation:
    Situation Signal = Obstacle Situation     (Clear | Right Open | Left Open | All Blocked)
```

### Relevant Requirements
- B3, B4, C1

## Process 3.2.2: Movement Controller

### Process Identification

| Field | Description |
|---|---|
| Process ID | 3.2.2 |
| Process Name | Movement Controller |
| DFD Level | Level 3 |
| Parent Process | 3.2 |
| Process Type | Control |

### Purpose
Sequence the RVC movement over ticks: go forward, stop at an obstacle for 5 ticks, move backward for 5 ticks when needed, turn for 5 ticks, and resume forward.

### Inputs
- Tick (control)
- Situation Signal (control, from Process 3.2.1)
- Step Done (control, from Process 3.2.4)

### Outputs
- Movement Command (control, to Process 3.2.3)
- Start Step Timer (control, to Process 3.2.4)

### Trigger / Execution Condition
- Executes on every Tick, after Situation Signal and Step Done for the tick are available.

### Processing Logic
The Controller has five states: Forward (initial), Stopping, Backing, Turning Right, Turning Left. On each Tick it takes one transition and issues one Movement Command.

| Current State | Tick condition | Actions | Next State | Source |
|---|---|---|---|---|
| Forward | Clear | Forward | Forward | B2 |
| Forward | not Clear | Stop, Start Step Timer | Stopping | B3, C2, C7 |
| Stopping | not Step Done | Stop | Stopping | C7 |
| Stopping | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C1, C8 |
| Stopping | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | B3, C8 |
| Stopping | Step Done and All Blocked | Backward, Start Step Timer | Backing | B4, C6 |
| Backing | not Step Done | Backward | Backing | C6 |
| Backing | Step Done and All Blocked | Backward, Start Step Timer | Backing | C5, C6 |
| Backing | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C5, C8 |
| Backing | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | C5, C8 |
| Turning Right | not Step Done | Turn Right | Turning Right | C8 |
| Turning Right | Step Done | Forward | Forward | B3, B4, C8 |
| Turning Left | not Step Done | Turn Left | Turning Left | C8 |
| Turning Left | Step Done | Forward | Forward | B3, B4, C8 |

Clear cannot arrive in Stopping or Backing (C4). The full state model, with transition IDs and validation, is the Level 4 FSM (`artifacts/SA/DFD/dfd_level_4_fsm.md`).

### Relevant Requirements
- B2, B3, B4, C1, C2, C4, C5, C6, C7, C8

## Process 3.2.3: Issue Movement Output

### Process Identification

| Field | Description |
|---|---|
| Process ID | 3.2.3 |
| Process Name | Issue Movement Output |
| DFD Level | Level 3 |
| Parent Process | 3.2 |
| Process Type | Data |

### Purpose
Turn the Controller's Movement Command into the Direction for the Motor and the Movement Status for Process 4.

### Inputs
- Movement Command (control, from Process 3.2.2)

### Outputs
- Direction (to Motor)
- Movement Status (to Process 4)

### Trigger / Execution Condition
- When a Movement Command arrives.

### Processing Logic
1. Send Direction with the same value as the Movement Command.
2. Report Movement Status Forward when the command is Forward; otherwise Avoiding (B3: cleaning stops while avoiding).

### Pseudocode

```text
ON Movement Command:
    Direction = Movement Command
    IF Movement Command == Forward THEN
        Movement Status = Forward
    ELSE
        Movement Status = Avoiding
    END IF
```

### Relevant Requirements
- B2, B3, B4

## Process 3.2.4: Time Movement Step

### Process Identification

| Field | Description |
|---|---|
| Process ID | 3.2.4 |
| Process Name | Time Movement Step |
| DFD Level | Level 3 |
| Parent Process | 3.2 |
| Process Type | Data |

### Purpose
Count the ticks of a stop, backward, or turn step and tell the Controller when 5 ticks have elapsed.

### Inputs
- Start Step Timer (control, from Process 3.2.2)
- Tick (control)
- Step Ticks Elapsed (from D4 Step Timer)

### Outputs
- Step Done (control, to Process 3.2.2)
- Step Ticks Elapsed (to D4 Step Timer)

### Trigger / Execution Condition
- On every Tick, before 3.2.2 runs.
- On Start Step Timer, issued by 3.2.2 during a tick.

### Processing Logic
1. On Start Step Timer, set the count to 0. The tick on which the step starts is the first tick of the step.
2. On each later Tick, if a step is running, add 1.
3. When the count reaches 5, emit Step Done and set the timer to Idle.

A step started on tick t covers ticks t to t+4. Step Done arrives on tick t+5, when the Controller issues the next action.

### Pseudocode

```text
ON Start Step Timer:
    WRITE Step Ticks Elapsed = 0 TO D4

ON Tick:                                   (before 3.2.2)
    READ Step Ticks Elapsed FROM D4
    IF Step Ticks Elapsed != Idle THEN
        Step Ticks Elapsed = Step Ticks Elapsed + 1
        IF Step Ticks Elapsed == 5 THEN
            emit Step Done
            Step Ticks Elapsed = Idle
        END IF
        WRITE Step Ticks Elapsed TO D4
    END IF
```

Initial value of D4: Idle.

### Relevant Requirements
- C6, C7, C8
