# Process Specification

Current coverage: DFD Levels 0-3.

Requirement references: B1-B7 are bullets of `docs/preliminary_requirements.md`, by order. C1-C16 and Q1-Q6 are entries of `docs/requirements_clarifications.md`. Q1-Q5 are resolved by C5-C7/C10-C11. Q6 is resolved by C16. C12-C15 record the Phase 1 decisions of 2026-11-17. Earlier refinement notes are history; current logic below is normative.

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

### Initialization and input contract
Initialize the Controller to Forward, D3 to 0 and D4 to Idle, and the Pending Dust Detection flag in D2 to FALSE. Emit no Direction or Clean at Power On (C13). Read all four actual sensor values through Processes 1 and 2 before the first Tick (C12); no unreceived value is assumed FALSE. A TRUE initial dust sample sets the pending flag.

Sensor input receipt and Tick execution are logically serialized. Inputs received before a Tick update the stores before its snapshot; later inputs are processed after that Tick. Process 1 updates the received field, retaining other valid readings. Process 2 records current dust and retains any unconsumed TRUE detection even if a later FALSE arrives.

### Processing Logic
1. Each Tick uses current state and the valid sensor snapshot, not a stateless front-only decision.
2. Process 3 sequences the movement under C1-C9. Forward uses the front for avoidance entry (C16); Backing completion uses sides regardless of the front (C9).
3. Process 4 uses this Tick's Movement Status, D2 and D3. Avoiding stops suction and mopping, preserves remaining power-up ticks, and keeps pending dust. Forward starts/restarts five ticks for pending/current dust, or resumes saved ticks otherwise (C10, C11, C15).
4. Clean Start enables suction and mopping; Stop disables both; Power Up strengthens suction while mopping stays normal (C14).

### Pseudocode

```text
BEFORE first Tick:
    initialize state and stores as above
    obtain all four initial sensor samples through Processes 1 and 2
ON Tick:
    Direction, Movement Status = Process 3 using D1 and persistent movement state
    Clean = Process 4 using this Movement Status, D2 and D3
```

This is a composition of the lower-level contracts, not multiple movement commands on one Tick. Exact ordering is in DFD Level 3; the first Tick may issue Stop rather than Forward when the front is blocked.

### Relevant Requirements
- B1-B7, C1-C16

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
1. Before the first Tick, obtain all three actual obstacle readings (C12).
2. When an individual sensor input arrives, update only that matching field in D1 and retain the other valid readings. Tick does not run before the initial set is complete.

### Pseudocode

```text
ON received obstacle sensor input:
    UPDATE the matching Front/Left/Right Obstacle field in D1
    PRESERVE the other fields (all three must be initialized before first Tick, C12)
```

### Relevant Requirements
- B3, B4, C1, C12

## Process 2: Detect Dust

### Process Identification

| Field | Description |
|---|---|
| Process ID | 2 |
| Process Name | Detect Dust |
| DFD Level | Level 1 |
| Parent Process | 0 |

### Purpose
Record the current dust reading and latch each TRUE detection until Process 4 consumes it on a Forward Tick (C15).

### Inputs
- Dust Sensor Input
- Dust Existence (previous record from D2, including Pending Dust Detection)

### Outputs
- Dust Existence (to D2 Dust Existence)

### Trigger / Execution Condition
- When the dust sensor input is received.

### Processing Logic
1. Before initial sampling, set Pending Dust Detection to FALSE; obtain the actual initial Dust Sensor Input before the first Tick (C12).
2. Store the current reading as Dust Detected. A TRUE input sets Pending Dust Detection to TRUE; a FALSE input preserves it (C15). Process 4.1 alone consumes it on a Forward Tick.
3. This input update and Tick consumption are logically serialized, so a new input after consumption is retained for the next Tick.

### Pseudocode

```text
ON Dust Sensor Input:
    READ only Pending Dust Detection FROM D2
    Dust Existence.Dust Detected = Dust Sensor Input
    Dust Existence.Pending Dust Detection = Pending Dust Detection OR Dust Sensor Input
    WRITE Dust Existence TO D2
```

### Relevant Requirements
- B5, C12, C15

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
1. Classify both Front Blocked and Side Situation, with right priority, independently of the front (3.1, C1/C9).
2. Keep the movement state across ticks. Forward with front blocked enters a five-tick Stop (C2/C7); Forward with front clear remains Forward (C16).
3. On completing Stop or Backing, use the sides: right clear means Turn Right, else left clear means Turn Left, else Backward. Backing ignores the front and can repeat (C5/C9).
4. Stop, Backing and each Turn last five ticks (C6-C8). Turn completion resumes Forward. Exact timer ordering is specified by 3.2/3.2.2/3.2.4 and Level 4.
5. Return one Direction and corresponding Movement Status for this Tick. Initialization alone produces no output (C13).

### Pseudocode

```text
ON Tick:
    Obstacle Situation = Process 3.1(D1)
    Direction, Movement Status = Process 3.2(Obstacle Situation, persistent state)
```

### Relevant Requirements
- B2, B3, B4, C1, C2, C4-C9, C12, C13; C16

## Process 4: Control Cleaning

### Process Identification

| Field | Description |
|---|---|
| Process ID | 4 |
| Process Name | Control Cleaning |
| DFD Level | Level 1 |
| Parent Process | 0 |

### Purpose
Decide the cleaning command from the movement status and dust existence, including the 5-tick power-up, remembered dust, and suction/mopping semantics (C14/C15).

### Inputs
- Movement Status (from Process 3)
- Dust Existence (from D2 Dust Existence)
- Tick (control)

### Outputs
- Clean (to Cleaner)
- Pending Dust Detection (updated flag to D2)

### Trigger / Execution Condition
- Executes on every Tick, after the current Movement Status is available.

### Processing Logic
1. Obtain Power-Up Active from Process 4.1 using this Tick's Movement Status and current/pending dust; D3 initially equals 0.
2. While Avoiding, stop both suction and mopping and preserve D3 and pending dust (C11/C15).
3. On Forward with pending or current dust, restart five ticks and consume the pending flag (C10/C15). Otherwise resume any saved ticks (C11).
4. Process 4.2 emits Start, Stop or Power Up with C14's suction/mopping meanings.

### Pseudocode

```text
ON Tick after Movement Status:
    Power-Up Active = Process 4.1(Dust Existence, Movement Status, D3)
    Clean = Process 4.2(Movement Status, Power-Up Active)
```

### Relevant Requirements
- B1, B2, B3, B5, C3, C10, C11, C13-C15
- Q4 -> C10 and Q5 -> C11 are resolved; avoidance dust is resolved by C15.

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
Revised 2026-11-16 for C9: the sides are classified whether or not the front is blocked.

1. Read Obstacle Location from D1.
2. Front Blocked is TRUE when the front sensor detects an obstacle.
3. Side Situation is Right Open when the right is clear (C1: right has priority).
4. Otherwise it is Left Open when the left is clear.
5. Otherwise it is Sides Blocked.

With Front Blocked, Sides Blocked means front, left, and right are all blocked (B4).

### Pseudocode

```text
ON Tick:
    READ Obstacle Location FROM D1
    Obstacle Situation.Front Blocked = Front Obstacle
    IF Right Obstacle == FALSE THEN
        Obstacle Situation.Side Situation = Right Open        (C1)
    ELSE IF Left Obstacle == FALSE THEN
        Obstacle Situation.Side Situation = Left Open
    ELSE
        Obstacle Situation.Side Situation = Sides Blocked
    END IF
```

### Relevant Requirements
- B3, B4, C1, C9
- C16: while Forward, the Controller uses Front Blocked only for avoidance entry; a clear front means continued forward movement and cleaning.

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
Obstacle Situation is a record: Front Blocked plus Side Situation. Initialize the movement state to Forward without output (C13). On each Tick, advance D4 before taking the Controller transition. In Forward, front blocked enters Stopping and starts D4; otherwise remain Forward. Stopping and Backing retain their action until Step Done. When Done, use only the sides (Right Open -> Turning Right; Left Open -> Turning Left; Sides Blocked -> Backing) and restart D4, including repeated Backing. Turning retains its direction until Done, then selects Forward. C16 applies only to Forward avoidance entry, not side classification or the Backing decision (C9).

### Pseudocode

```text
ON Tick after Process 3.1:
    Situation Signal = Process 3.2.1(Obstacle Situation)
    Step Done = Process 3.2.4 advance on Tick
    Movement Command, optional Start Step Timer = Process 3.2.2(Situation Signal, Step Done)
    IF Start Step Timer issued THEN Process 3.2.4 sets D4 = 0
    Direction, Movement Status = Process 3.2.3(Movement Command)
```

### Relevant Requirements
- B2-B4, C1, C2, C4-C9, C13; C16
- Exact states/transitions: Process 3.2.2 and Level 4 FSM. Five-tick boundaries: Process 3.2.4.

## Process 4.1: Track Power-Up

### Process Identification

| Field | Description |
|---|---|
| Process ID | 4.1 |
| Process Name | Track Power-Up |
| DFD Level | Level 2 |
| Parent Process | 4 |

### Purpose
Run the five-tick suction power-up from current or remembered dust; freeze its remaining ticks while Avoiding (C10/C11/C15).

### Inputs
- Dust Existence (from D2 Dust Existence)
- Movement Status (from Process 3.2)
- Remaining Power-Up Ticks (from D3 Power-Up Timer)
- Tick (control)

### Outputs
- Power-Up Active (to Process 4.2)
- Remaining Power-Up Ticks (to D3 Power-Up Timer)
- Pending Dust Detection (updated flag only, to D2 Dust Existence)

### Trigger / Execution Condition
- Executes on every Tick, after Movement Status for the tick is available.

### Processing Logic
Revised 2026-11-17 for C15; C10/C11 remain in force with the explicit restart precedence below. D3 starts at 0 before the first Tick. D2's pending flag is initialized FALSE before initial sensor sampling and is set by Process 2 on every TRUE dust input.

1. Read current Dust Detected and Pending Dust Detection from D2 and Remaining Power-Up Ticks from D3.
2. While Avoiding, output Power-Up Active=FALSE, preserve remaining ticks and the pending flag. Process 2 continues recording detections; no consumption or countdown occurs.
3. While Forward, if current dust or pending dust is TRUE, set the remaining count to 5. This overrides a saved partial count (C15). Clear the pending flag only after consuming it; do not change the current Dust Detected value.
4. If Forward with count > 0, output Power-Up Active=TRUE and decrement by one; otherwise output FALSE. Write the updated count and pending flag to their respective stores.

A start/restart at t powers suction on t..t+4 in the absence of another detection or avoidance. On a restart Tick, D3 becomes 4 after the current active tick is counted. Multiple pending detections coalesce into one restart. Without current/pending dust, a saved count resumes under C11. A continuously TRUE current reading restarts on each Forward Tick under C10, as before. A TRUE input followed by FALSE between ticks is not lost because Process 2 latches it.

### Pseudocode

```text
ON Tick after Movement Status:
    READ Dust Detected, Pending Dust Detection FROM D2
    READ Remaining Power-Up Ticks FROM D3
    Power-Up Active = FALSE
    IF Movement Status == Forward THEN
        IF Dust Detected OR Pending Dust Detection THEN
            Remaining Power-Up Ticks = 5               (C3, C10, C15)
        END IF
        Pending Dust Detection = FALSE                 (consume on Forward only)
        IF Remaining Power-Up Ticks > 0 THEN
            Power-Up Active = TRUE
            Remaining Power-Up Ticks = Remaining Power-Up Ticks - 1
        END IF
    END IF                                             (Avoiding preserves both, C11/C15)
    WRITE Remaining Power-Up Ticks TO D3
    UPDATE only Pending Dust Detection IN D2            (preserve current Dust Detected)
```

Input updates and this Tick are logically serialized per Process 0's contract. A later input cannot be cleared by the earlier Tick's consumption.

### Relevant Requirements
- B5, C3, C10, C11, C12, C15

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
4. C14: Start enables normal suction and mopping; Stop disables both; Power Up strengthens suction only while mopping continues normally. No hardware implementation detail is specified (B6).

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
- B1, B2, B3, B5, C14

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
    Situation Signal = Obstacle Situation     (Front Blocked + Side Situation; C9)
```

### Relevant Requirements
- B3, B4, C1, C9

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
The Controller has five states: Forward (initial), Stopping, Backing, Turning Right, Turning Left. Initialization sets Forward without output (C13). On each Tick it takes one transition and issues one Movement Command. Initial sensor sampling precedes the first Tick (C12).

| Current State | Tick condition | Actions | Next State | Source |
|---|---|---|---|---|
| Forward | not Front Blocked | Forward | Forward | B2, C16 |
| Forward | Front Blocked | Stop, Start Step Timer | Stopping | B3, C2, C7, C16 |
| Stopping | not Step Done | Stop | Stopping | C7 |
| Stopping | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C1, C8 |
| Stopping | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | B3, C8 |
| Stopping | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | B4, C6 |
| Backing | not Step Done | Backward | Backing | C6 |
| Backing | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | C5, C6, C9 |
| Backing | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C5, C8 |
| Backing | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | C5, C8 |
| Turning Right | not Step Done | Turn Right | Turning Right | C8 |
| Turning Right | Step Done | Forward | Forward | B3, B4, C8 |
| Turning Left | not Step Done | Turn Left | Turning Left | C8 |
| Turning Left | Step Done | Forward | Forward | B3, B4, C8 |

When a stop or backward step ends, only the Side Situation decides (C9). The full state model, with transition IDs and validation, is the Level 4 FSM (`artifacts/SA/DFD/dfd_level_4_fsm.md`).

### Relevant Requirements
- B2, B3, B4, C1, C2, C4, C5, C6, C7, C8, C9, C12, C13, C16

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
