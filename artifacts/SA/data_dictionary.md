# Data Dictionary

Current coverage: Event List, Context Diagram, DFD Levels 0-3.

## 1. External Input/Output Events

| Input/Output Event | Description | Format / Type |
|---|---|---|
| Front Sensor Input | Reports whether an obstacle is detected in front of the RVC. | Boolean |
| Left Sensor Input | Reports whether an obstacle is detected on the left side of the RVC. | Boolean |
| Right Sensor Input | Reports whether an obstacle is detected on the right side of the RVC. | Boolean |
| Dust Sensor Input | Reports whether dust is detected on the surface being cleaned. | Boolean |
| Tick | Clock event that provides the time base for the system. | Event |
| Direction | Movement command sent to the motor. | Enum |
| Clean | Cleaning command sent to the cleaner. | Enum |

## 2. Internal Data and Control Flows

No internal flows exist at DFD Level 0.

| Data Name | Description | Format / Type | Flow Category | Source | Destination | DFD Level |
|---|---|---|---|---|---|---|
| Obstacle Location | Latest obstacle detection result for front, left, and right. | Front Obstacle + Left Obstacle + Right Obstacle | Data | Process 1; D1 Obstacle Location | D1 Obstacle Location; Process 3 (L1), 3.1 (L2) | 1, 2 |
| Dust Existence | Latest dust detection result. | Dust Detected | Data | Process 2; D2 Dust Existence | D2 Dust Existence; Process 4 (L1), 4.1 (L2) | 1, 2 |
| Movement Status | Whether the RVC is moving forward or avoiding an obstacle. | Enum | Data | Process 3 (L1), 3.2 (L2), 3.2.3 (L3) | Process 4 (L1), 4.1 and 4.2 (L2, L3) | 1, 2, 3 |
| Obstacle Situation | Classification of the current obstacles. | Enum | Data | Process 3.1 | Process 3.2 (L2), 3.2.1 (L3) | 2, 3 |
| Situation Signal | Obstacle Situation delivered to the Controller as a control signal. | Enum | Control | Process 3.2.1 | Process 3.2.2 | 3 |
| Movement Command | Action chosen by the Controller for the current tick. | Enum | Control | Process 3.2.2 | Process 3.2.3 | 3 |
| Start Step Timer | Tells the step timer to begin counting a 5-tick stop, backward, or turn step. | Event | Control | Process 3.2.2 | Process 3.2.4 | 3 |
| Step Done | Signals that the current stop, backward, or turn step has lasted 5 ticks. | Event | Control | Process 3.2.4 | Process 3.2.2 | 3 |
| Step Ticks Elapsed | Ticks counted in the current stop, backward, or turn step. | Idle or Integer 0-5 | Data | Process 3.2.4; D4 Step Timer | D4 Step Timer; Process 3.2.4 | 3 |
| Power-Up Active | Whether powered-up cleaning applies this tick. | Boolean | Data | Process 4.1 | Process 4.2 | 2 |
| Remaining Power-Up Ticks | Ticks of powered-up cleaning still to run. | Integer, 0-5 | Data | Process 4.1; D3 Power-Up Timer | D3 Power-Up Timer; Process 4.1 | 2 |

## 3. Data Store Definitions

No Data Stores exist at DFD Level 0.

| Data Store | Description | Stored Data | Format / Type | DFD Level |
|---|---|---|---|---|
| D1 Obstacle Location | Holds the latest front, left, and right obstacle readings for use on the next Tick. | Front Obstacle, Left Obstacle, Right Obstacle | Record of 3 Booleans | 1, 2 |
| D2 Dust Existence | Holds the latest dust reading for use on the next Tick. | Dust Detected | Boolean | 1, 2 |
| D3 Power-Up Timer | Holds the remaining powered-up cleaning ticks across ticks. | Remaining Power-Up Ticks | Integer, 0-5 | 2, 3 |
| D4 Step Timer | Holds the tick count of the current stop, backward, or turn step across ticks. | Step Ticks Elapsed | Idle or Integer 0-5 | 3 |

## 4. Detailed Data Definitions

### Front Sensor Input
- Description: Reports whether an obstacle is detected in front of the RVC.
- Format / Type: Boolean
- Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
- Flow Category: Data
- Source: Front Sensor
- Destination: Process 0; Process 1 (Level 1)
- DFD Level: Context, 0, 1
- Requirement Reference: B3, B4

### Left Sensor Input
- Description: Reports whether an obstacle is detected on the left side of the RVC.
- Format / Type: Boolean
- Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
- Flow Category: Data
- Source: Left Sensor
- Destination: Process 0; Process 1 (Level 1)
- DFD Level: Context, 0, 1
- Requirement Reference: B3, B4, C1

### Right Sensor Input
- Description: Reports whether an obstacle is detected on the right side of the RVC.
- Format / Type: Boolean
- Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
- Flow Category: Data
- Source: Right Sensor
- Destination: Process 0; Process 1 (Level 1)
- DFD Level: Context, 0, 1
- Requirement Reference: B3, B4, C1

### Dust Sensor Input
- Description: Reports whether dust is detected on the surface being cleaned.
- Format / Type: Boolean
- Possible Values: TRUE (dust detected), FALSE (no dust detected)
- Flow Category: Data
- Source: Dust Sensor
- Destination: Process 0; Process 2 (Level 1)
- DFD Level: Context, 0, 1
- Requirement Reference: B5

### Tick
- Description: Clock event that provides the time base for the system. Powered-up cleaning lasts 5 ticks.
- Format / Type: Event
- Possible Values: None; the occurrence of the event is the information.
- Flow Category: Control
- Source: Digital Clock
- Destination: Process 0; Processes 3 and 4 (Level 1); Processes 3.1, 3.2, 4.1 (Level 2); Processes 3.1, 3.2.2, 3.2.4, 4.1 (Level 3)
- DFD Level: Context, 0, 1, 2, 3
- Requirement Reference: B5, C3

### Direction
- Description: Movement command sent to the motor.
- Format / Type: Enum
- Possible Values: Forward, Backward, Turn Left, Turn Right, Stop
- Flow Category: Data
- Source: Process 0; Process 3 (Level 1); Process 3.2 (Level 2); Process 3.2.3 (Level 3)
- Destination: Motor
- DFD Level: Context, 0, 1, 2, 3
- Requirement Reference: B2, B3, B4, C1, C2

### Clean
- Description: Cleaning command sent to the cleaner.
- Format / Type: Enum
- Possible Values: Start, Stop, Power Up
- Flow Category: Data
- Source: Process 0; Process 4 (Level 1); Process 4.2 (Level 2)
- Destination: Cleaner
- DFD Level: Context, 0, 1, 2, 3
- Requirement Reference: B1, B2, B3, B5, C3

### Obstacle Location
- Description: Latest obstacle detection result for the three obstacle sensors. Written by Process 1, kept in D1, read by Process 3 on Tick.
- Format / Type: Record = Front Obstacle + Left Obstacle + Right Obstacle (each Boolean)
- Possible Values: Each field TRUE (obstacle) or FALSE (no obstacle)
- Flow Category: Data
- Source: Process 1 (write); D1 Obstacle Location (read)
- Destination: D1 Obstacle Location; Process 3 (Level 1); Process 3.1 (Level 2)
- DFD Level: 1, 2
- Requirement Reference: B3, B4, C1, Q6

### Dust Existence
- Description: Latest dust detection result. Written by Process 2, kept in D2, read by Process 4 on Tick.
- Format / Type: Record = Dust Detected (Boolean)
- Possible Values: TRUE (dust detected), FALSE (no dust detected)
- Flow Category: Data
- Source: Process 2 (write); D2 Dust Existence (read)
- Destination: D2 Dust Existence; Process 4 (Level 1); Process 4.1 (Level 2)
- DFD Level: 1, 2
- Requirement Reference: B5

### Movement Status
- Description: Tells Process 4 whether the RVC is moving forward (cleaning allowed) or avoiding an obstacle (cleaning stopped).
- Format / Type: Enum
- Possible Values: Forward, Avoiding
- Flow Category: Data
- Source: Process 3 (Level 1); Process 3.2 (Level 2); Process 3.2.3 (Level 3)
- Destination: Process 4 (Level 1); Processes 4.1 and 4.2 (Level 2)
- DFD Level: 1, 2, 3
- Requirement Reference: B2, B3, B4

### D1 Obstacle Location (Data Store)
- Description: Holds the latest Obstacle Location so that Process 3 can use all three readings on each Tick.
- Format / Type: Record of 3 Booleans
- Stored Data: Front Obstacle, Left Obstacle, Right Obstacle
- Source: Process 1
- Destination: Process 3 (Level 1); Process 3.1 (Level 2)
- DFD Level: 1, 2
- Requirement Reference: B3, B4

### D2 Dust Existence (Data Store)
- Description: Holds the latest Dust Existence so that Process 4 can use it on each Tick.
- Format / Type: Boolean
- Stored Data: Dust Detected
- Source: Process 2
- Destination: Process 4 (Level 1); Process 4.1 (Level 2)
- DFD Level: 1, 2
- Requirement Reference: B5

### Obstacle Situation
- Description: Classification of the obstacles read from D1, used to choose the avoidance action. Left and right are considered only when the front is blocked (Q6 assumption).
- Format / Type: Enum
- Possible Values: Clear (no front obstacle), Right Open (front blocked, right clear), Left Open (front and right blocked, left clear), All Blocked (front, left, and right blocked)
- Flow Category: Data
- Source: Process 3.1
- Destination: Process 3.2 (Level 2); Process 3.2.1 (Level 3)
- DFD Level: 2, 3
- Requirement Reference: B3, B4, C1, Q6

### Power-Up Active
- Description: Whether powered-up cleaning applies on the current tick.
- Format / Type: Boolean
- Possible Values: TRUE (power up), FALSE (normal cleaning or stopped)
- Flow Category: Data
- Source: Process 4.1
- Destination: Process 4.2
- DFD Level: 2
- Requirement Reference: B5, C3

### Remaining Power-Up Ticks
- Description: Number of powered-up cleaning ticks still to run, including the current tick before it is counted down.
- Format / Type: Integer
- Possible Values: 0-5 (0 = no power-up in progress; set to 5 on dust detection)
- Flow Category: Data
- Source: Process 4.1 (write); D3 Power-Up Timer (read)
- Destination: D3 Power-Up Timer; Process 4.1
- DFD Level: 2
- Requirement Reference: B5, C3, Q4, Q5

### D3 Power-Up Timer (Data Store)
- Description: Holds Remaining Power-Up Ticks so that the 5-tick power-up persists across ticks.
- Format / Type: Integer, 0-5
- Stored Data: Remaining Power-Up Ticks
- Source: Process 4.1
- Destination: Process 4.1
- DFD Level: 2
- Requirement Reference: B5, C3

### Situation Signal
- Description: The Obstacle Situation delivered to the Movement Controller as a control signal. The Controller uses it as the condition of its Tick transitions.
- Format / Type: Enum
- Possible Values: Clear, Right Open, Left Open, All Blocked (same meaning as Obstacle Situation)
- Flow Category: Control
- Source: Process 3.2.1
- Destination: Process 3.2.2
- DFD Level: 3
- Requirement Reference: B3, B4, C1, C4, Q6

### Movement Command
- Description: The action chosen by the Movement Controller for the current tick. It triggers Process 3.2.3.
- Format / Type: Enum
- Possible Values: Forward, Stop, Turn Right, Turn Left, Backward
- Flow Category: Control
- Source: Process 3.2.2
- Destination: Process 3.2.3
- DFD Level: 3
- Requirement Reference: B2, B3, B4, C1, C2

### Start Step Timer
- Description: Issued by the Movement Controller when a 5-tick stop (C7), backward (C6), or turn (C8) step begins. Resets the step count.
- Format / Type: Event
- Possible Values: None; the occurrence of the event is the information.
- Flow Category: Control
- Source: Process 3.2.2
- Destination: Process 3.2.4
- DFD Level: 3
- Requirement Reference: C6, C7, C8

### Step Done
- Description: Present on the tick when the current stop, backward, or turn step has lasted 5 ticks.
- Format / Type: Event
- Possible Values: None; the occurrence of the event is the information.
- Flow Category: Control
- Source: Process 3.2.4
- Destination: Process 3.2.2
- DFD Level: 3
- Requirement Reference: C6, C7, C8

### Step Ticks Elapsed
- Description: Number of ticks counted since Start Step Timer, not counting the tick on which the timer was started.
- Format / Type: Idle or Integer
- Possible Values: Idle (no step running), 0-5 (Step Done is emitted when it reaches 5, then it returns to Idle)
- Flow Category: Data
- Source: Process 3.2.4 (write); D4 Step Timer (read)
- Destination: D4 Step Timer; Process 3.2.4
- DFD Level: 3
- Requirement Reference: C6, C7, C8

### D4 Step Timer (Data Store)
- Description: Holds Step Ticks Elapsed so that the 5-tick stop, backward, and turn steps persist across ticks.
- Format / Type: Idle or Integer 0-5
- Stored Data: Step Ticks Elapsed
- Source: Process 3.2.4
- Destination: Process 3.2.4
- DFD Level: 3
- Requirement Reference: C6, C7, C8
