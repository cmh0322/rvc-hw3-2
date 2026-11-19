# Transform Analysis

System: RVC Controller
Sources: `artifacts/SA/DFD/dfd_level_0.md` to `dfd_level_3.md`, `artifacts/SA/DFD/dfd_level_4_fsm.md`, `artifacts/SA/process_specification.md`, `artifacts/SA/data_dictionary.md`, `artifacts/SA/context_diagram.md`, `artifacts/SA/event_list.md`
Requirement references: B1-B7 (`docs/preliminary_requirements.md`), C1-C8 and Q4-Q6 (`docs/requirements_clarifications.md`)

## 1. Objective

Identify the Afferent Flow, Central Transformation, and Efferent Flow of the RVC Controller from the approved DFD hierarchy, as the basis for the Structure Chart (`artifacts/SD/structure_chart.md`).

The analysis uses the leaf processes of the hierarchy. Processes 0, 3, 3.2, and 4 are parents and are represented by their children:

| Parent | Leaf processes |
|---|---|
| 0 RVC Controller | all of the below |
| 3 Control Movement | 3.1, 3.2.1, 3.2.2, 3.2.3, 3.2.4 |
| 3.2 Decide Movement | 3.2.1, 3.2.2, 3.2.3, 3.2.4 |
| 4 Control Cleaning | 4.1, 4.2 |

Processes 1 and 2 are leaves at Level 1.

## 2. Transform Regions

### Afferent Flow (Input)

Processes that receive the sensor inputs and raise them to the form the decision logic uses.

| Process ID | Process Name | Input | Output |
|---|---|---|---|
| 1 | Detect Obstacle | Front Sensor Input, Left Sensor Input, Right Sensor Input | Obstacle Location (to D1) |
| 3.1 | Assess Obstacle Situation | Obstacle Location (from D1), Tick | Obstacle Situation |
| 3.2.1 | Signal Obstacle Situation | Obstacle Situation | Situation Signal |
| 2 | Detect Dust | Dust Sensor Input | Dust Existence (to D2) |

Rationale:
- 1 and 2 only record what the sensors report.
- 3.1 turns the three raw readings into one Obstacle Situation. It describes the surroundings; it does not choose an action, so it is still input processing.
- 3.2.1 hands that description to the Controller as a signal without changing its value.
- Situation Signal and Dust Existence are the most abstract forms of the inputs. The next process to use each of them makes a decision.

### Central Transformation (Process)

Processes that decide what the RVC does.

| Process ID | Process Name | Input | Output |
|---|---|---|---|
| 3.2.2 | Movement Controller | Tick, Situation Signal, Step Done | Movement Command, Start Step Timer |
| 3.2.4 | Time Movement Step | Tick, Start Step Timer, Step Ticks Elapsed (from D4) | Step Done, Step Ticks Elapsed (to D4) |
| 3.2.3 (part) | Issue Movement Output: Movement Status | Movement Command | Movement Status |
| 4.1 | Track Power-Up | Tick, Dust Existence (from D2), Movement Status, Remaining Power-Up Ticks (from D3) | Power-Up Active, Remaining Power-Up Ticks (to D3) |
| 4.2 | Decide Cleaning | Movement Status, Power-Up Active | Clean |

Rationale:
- 3.2.2 is the control process of the system (the Level 4 FSM). It chooses the movement.
- 3.2.4 works only for 3.2.2: it is started by the Controller and reports back to it. It is part of the control loop, not an input or an output path.
- 4.1 decides whether powered-up cleaning applies on this tick.
- 4.2 is where the Clean value is first formed. Before 4.2 there is no cleaning command, only Movement Status and Power-Up Active, so 4.2 belongs to the decision logic.

### Efferent Flow (Output)

Processes that deliver a decision that has already been made.

| Process ID | Process Name | Input | Output |
|---|---|---|---|
| 3.2.3 (part) | Issue Movement Output: Direction | Movement Command | Direction |

Rationale:
- The movement decision already exists as Movement Command when it reaches 3.2.3. Turning it into Direction for the Motor changes its form, not its content.
- Clean has no efferent process. It flows from 4.2 directly to the Cleaner.

### Process 3.2.3 lies on the boundary

3.2.3 has two outputs with different roles, so it is listed in two regions:

| Output of 3.2.3 | Used by | Region |
|---|---|---|
| Direction | Motor (terminator) | Efferent |
| Movement Status | 4.1 and 4.2 (decision logic) | Central |

If 3.2.3 were placed whole in the efferent region, Movement Status would flow from the output side back into the decision logic. The Structure Chart therefore separates the two responsibilities into two modules.

## 3. Transform Boundaries

- **Afferent-to-Central Boundary:** after 3.2.1 on the obstacle path, and after 2 (at D2) on the dust path.
- **Central-to-Efferent Boundary:** after 3.2.2 on the movement path, and after 4.2 on the cleaning path.
- **Boundary Data Flows:** Dust Existence (afferent → central), Clean (central → Cleaner).
- **Boundary Control Flows:** Situation Signal (afferent → central), Movement Command (central → efferent).

| Boundary flow | Category | From | To | Why the boundary is here |
|---|---|---|---|---|
| Situation Signal | Control | 3.2.1 | 3.2.2 | Last point where the obstacle input is only a description. 3.2.2 turns it into an action. |
| Dust Existence | Data | 2 (via D2) | 4.1 | The dust reading is used unchanged. 4.1 turns it into a power-up decision. |
| Movement Command | Control | 3.2.2 | 3.2.3 | First point where the movement output exists. After it, only the form changes. |
| Clean | Data | 4.2 | Cleaner | First point where the cleaning output exists. It needs no further processing. |

**Tick** is not transformed by any afferent process. It triggers 3.1, 3.2.2, 3.2.4, and 4.1 directly. In the design it becomes the trigger of one control cycle, not a value that is passed around.

## 4. Transform Analysis Diagram

```mermaid
flowchart LR
    FS["Front Sensor"]
    LS["Left Sensor"]
    RS["Right Sensor"]
    DSN["Dust Sensor"]
    CLK["Digital Clock"]
    MOT["Motor"]
    CLN["Cleaner"]

    subgraph A["Afferent Flow (Input)"]
        P1(("1 Detect Obstacle"))
        D1[["D1 Obstacle Location"]]
        P31(("3.1 Assess Obstacle Situation"))
        P321(("3.2.1 Signal Obstacle Situation"))
        P2(("2 Detect Dust"))
        D2[["D2 Dust Existence"]]
    end

    subgraph C["Central Transformation"]
        P322(("3.2.2 Movement Controller"))
        P324(("3.2.4 Time Movement Step"))
        D4[["D4 Step Timer"]]
        P323S(("3.2.3 Movement Status part"))
        P41(("4.1 Track Power-Up"))
        D3[["D3 Power-Up Timer"]]
        P42(("4.2 Decide Cleaning"))
    end

    subgraph E["Efferent Flow (Output)"]
        P323D(("3.2.3 Direction part"))
    end

    FS -->|"Front Sensor Input"| P1
    LS -->|"Left Sensor Input"| P1
    RS -->|"Right Sensor Input"| P1
    P1 -->|"Obstacle Location"| D1
    D1 -->|"Obstacle Location"| P31
    P31 -->|"Obstacle Situation"| P321
    DSN -->|"Dust Sensor Input"| P2
    P2 -->|"Dust Existence"| D2

    P321 -.->|"Situation Signal"| P322
    D2 -->|"Dust Existence"| P41

    CLK -.->|"Tick"| P31
    CLK -.->|"Tick"| P322
    CLK -.->|"Tick"| P324
    CLK -.->|"Tick"| P41

    P322 -.->|"Start Step Timer"| P324
    P324 -.->|"Step Done"| P322
    P324 -->|"Step Ticks Elapsed"| D4
    D4 -->|"Step Ticks Elapsed"| P324
    P322 -.->|"Movement Command"| P323S
    P323S -->|"Movement Status"| P41
    P323S -->|"Movement Status"| P42
    P41 -->|"Remaining Power-Up Ticks"| D3
    D3 -->|"Remaining Power-Up Ticks"| P41
    P41 -->|"Power-Up Active"| P42

    P322 -.->|"Movement Command"| P323D
    P323D -->|"Direction"| MOT
    P42 -->|"Clean"| CLN

    classDef control stroke-dasharray: 5 5
    class P322 control
```

Solid arrows are data flows. Dashed arrows are control flows. `3.2.2` has a dashed border because it is the control process. All names are those of the DFDs; `3.2.3` appears twice, once for each of its outputs.

## 5. Result

| Region | DFD processes | Role in the Structure Chart |
|---|---|---|
| Afferent | 1, 2, 3.1, 3.2.1 | Input branch: obtains Obstacle Situation and Dust Existence. |
| Central | 3.2.2, 3.2.4, 3.2.3 (Movement Status), 4.1, 4.2 | Processing branch: decides Movement Command and Clean. |
| Efferent | 3.2.3 (Direction) | Output branch: delivers Direction to the Motor and Clean to the Cleaner. |

Every leaf process is assigned to a region. No process was added, and no flow was renamed.
