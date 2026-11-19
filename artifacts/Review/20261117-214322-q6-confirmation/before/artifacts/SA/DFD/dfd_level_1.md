# DFD Level 1

System: RVC Controller
Parent: Process 0 (RVC Controller), `artifacts/SA/DFD/dfd_level_0.md`
Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C15, Q6), `artifacts/SA/event_list.md`, `artifacts/SA/context_diagram.md`

## Diagram

```mermaid
flowchart LR
    FrontSensor["Front Sensor"]
    LeftSensor["Left Sensor"]
    RightSensor["Right Sensor"]
    DustSensor["Dust Sensor"]
    DigitalClock["Digital Clock"]
    Motor["Motor"]
    Cleaner["Cleaner"]

    P1(("1. Detect Obstacle"))
    P2(("2. Detect Dust"))
    P3(("3. Control Movement"))
    P4(("4. Control Cleaning"))

    DS1[["D1 Obstacle Location"]]
    DS2[["D2 Dust Existence"]]

    FrontSensor -->|Front Sensor Input| P1
    LeftSensor -->|Left Sensor Input| P1
    RightSensor -->|Right Sensor Input| P1
    DustSensor -->|Dust Sensor Input| P2

    P1 -->|Obstacle Location| DS1
    P2 -->|Dust Existence| DS2
    DS2 -->|Dust Existence| P2

    DS1 -->|Obstacle Location| P3
    DS2 -->|Dust Existence| P4
    P4 -->|Pending Dust Detection| DS2

    DigitalClock -.->|Tick| P3
    DigitalClock -.->|Tick| P4

    P3 -->|Movement Status| P4

    P3 -->|Direction| Motor
    P4 -->|Clean| Cleaner
```

Solid arrows are data flows. Dashed arrows are control flows. `[[ ]]` nodes are Data Stores.

All four processes are data processes. No control process is introduced at this level: control and data processing are separated at Level 3, where the Controller is identified for the Level 4 FSM (sa-dfd Step 5.4).

## Processes

| Process ID | Process Name | Responsibility | Requirements |
|---|---|---|---|
| 1 | Detect Obstacle | Reads the front, left, and right sensor inputs and records where obstacles are. | B3, B4, C1 |
| 2 | Detect Dust | Records the current dust reading and latches every TRUE detection until consumed on a Forward Tick. | B5, C15 |
| 3 | Control Movement | On each Tick, decides the movement from the obstacle locations: go forward, stop, turn right or left, or move backward. Reports whether the RVC is moving forward or avoiding an obstacle. | B2, B3, B4, C1, C2 |
| 4 | Control Cleaning | On each Tick, decides the cleaning command from the movement status and dust existence: start, stop, or power up for 5 ticks. Consumes pending dust on Forward; retains it while Avoiding. | B1, B2, B3, B5, C3, C10, C11, C14, C15 |

### Decomposition rationale

- 1 and 2 separate sensor interpretation from decision making. Each groups the inputs of one requirement: obstacle sensors (B3, B4) and the dust sensor (B5).
- 3 and 4 follow the two outputs of Process 0. Movement (`Direction`) depends on obstacles; cleaning (`Clean`) depends on dust and on whether the RVC is avoiding an obstacle (B3: "stops cleaning ... goes forward with cleaning").
- `Movement Status` is the only coupling between 3 and 4. It carries the B3 rule that cleaning stops while avoiding and resumes when moving forward again.

## Data Stores

| ID | Data Store | Contents | Written by | Read by | Justification |
|---|---|---|---|---|---|
| D1 | Obstacle Location | Front Obstacle, Left Obstacle, Right Obstacle | 1 | 3 | Sensor inputs arrive independently of the clock. 3 acts on Tick, so it needs the latest reading of all three sensors at that moment. |
| D2 | Dust Existence | Dust Detected + Pending Dust Detection | 2 (current reading and latch); 4 (consume pending flag) | 2, 4 | Preserve the latest reading and a TRUE detection even if the sensor clears before Forward resumes (C15). |

The 5-tick power-up count is kept inside Process 4 at this level. Whether it needs its own Data Store is decided at Level 2.

## Internal Flows

| Flow | Category | Source | Destination | Content |
|---|---|---|---|---|
| Obstacle Location | Data | 1 (write), D1 (read) | D1, 3 | Front Obstacle + Left Obstacle + Right Obstacle |
| Dust Existence | Data | 2 (write), D2 (read) | D2, 2, 4 | Dust Detected + Pending Dust Detection |
| Pending Dust Detection | Data | 4 | D2 | Updated pending flag; FALSE after a Forward Tick consumes the detection, unchanged during avoidance |
| Movement Status | Data | 3 | 4 | Forward or Avoiding |

## Balancing with Level 0

| Level 0 Flow | Direction | Category | External Entity | Level 1 Process | Balanced |
|---|---|---|---|---|---|
| Front Sensor Input | Input | Data | Front Sensor | 1 | Yes |
| Left Sensor Input | Input | Data | Left Sensor | 1 | Yes |
| Right Sensor Input | Input | Data | Right Sensor | 1 | Yes |
| Dust Sensor Input | Input | Data | Dust Sensor | 2 | Yes |
| Tick | Input | Control | Digital Clock | 3, 4 | Yes (split, see below) |
| Direction | Output | Data | Motor | 3 | Yes |
| Clean | Output | Data | Cleaner | 4 | Yes |

Flow mapping: the single Level 0 `Tick` is delivered to both 3 and 4. It is the same event, not two different flows.

No external flow was added or removed. `Obstacle Location`, `Dust Existence`, `Pending Dust Detection`, and `Movement Status` are internal to Process 0.

## Decisions and remaining assumption

Q1-Q5 are resolved: C5 defines post-backing selection/repetition; C6-C8 set five-tick steps; C10 restarts power-up on re-detection; C11 preserves its count during avoidance. C9 requires side classification independently of the front. C15 remembers avoidance dust and restarts on resumption; without such dust C11 resumes the saved count. Q6 alone remains an assumption: while Forward, a clear front does not initiate avoidance solely because of side obstacles.

Before the first Tick, obtain all four sensor readings into D1/D2 (C12). Initialize D3=0, D4=Idle and the pending flag=FALSE before initial sampling. Power On emits no commands (C13). Process 1 updates the received sensor field while preserving other valid readings. Process 2 updates the current dust reading and ORs TRUE detections into the pending flag. Input receipt and Tick processing are logically serialized: inputs received before a Tick are included in its snapshot; later inputs are processed after that Tick. This defines the analysis ordering, not hardware synchronization details (B6).
