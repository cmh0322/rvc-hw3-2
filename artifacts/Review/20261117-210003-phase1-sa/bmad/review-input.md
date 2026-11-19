
# FILE: docs/preliminary_requirements.md
1: • An RVC automatically cleans and mops household surface.
2: • It goes straight forward while cleaning.
3: • If its sensors found an obstacle, it stops cleaning, turns aside left or right, and goes forward with cleaning.
4: • If there are obstacles in both front, left and right, it move backward and turn aside left or right, and goes forward.
5: • If it detects dust, power up the cleaning for a while.
6: • We do not consider the detail design and implementation on HW controls.
7: • We only focus on the automatic cleaning function.

# FILE: docs/requirements_clarifications.md
1: # Requirements Clarifications
2: 
3: Decisions made by the project owner on 2026-11-06. They supplement `preliminary_requirements.md`, which remains unchanged. Bullets of that file are cited as B1-B7, by order.
4: 
5: ## Confirmed Decisions
6: 
7: | ID | Refines | Decision |
8: |---|---|---|
9: | C1 | B3 | When a front obstacle is found and both left and right are clear, the RVC turns right. |
10: | C2 | B3 | When an obstacle is found, the RVC stops moving before it continues. |
11: | C3 | B5 | "For a while" means 5 ticks. |
12: | C4 | B3, B4 | Obstacles do not disappear. An obstacle detected stays in place while the RVC stops, moves backward, or turns. (Decided 2026-11-08.) |
13: | C5 | B4, Q1 | After moving backward, the RVC turns right if the right is clear. If the right is blocked and the left is clear, it turns left. If left and right are still both blocked, it moves backward once more. (Decided 2026-11-08; left-turn case added the same day.) |
14: | C6 | B4, Q2 | Moving backward lasts 5 ticks. (Decided 2026-11-08.) |
15: | C7 | C2, Q3 | The stop before avoidance lasts 5 ticks. (Decided 2026-11-08.) |
16: | C8 | B3, B4 | A turn (left or right) lasts 5 ticks. (Decided 2026-11-08.) |
17: | C9 | B4, C5 | After moving backward, only left and right decide (as C5 states); the front sensor is not consulted. Moving backward takes the RVC away from the obstacle, so the front may read clear. (Decided 2026-11-16.) |
18: | C10 | B5, C3, Q4 | Dust detected again during a running power-up restarts the 5 ticks. (Decided 2026-11-16.) |
19: | C11 | B3, C3, Q5 | A power-up interrupted by an avoidance keeps its remaining ticks and continues when the RVC moves forward again. (Decided 2026-11-16.) |
20: 
21: ## Open Questions
22: 
23: | ID | Refines | Question |
24: |---|---|---|
25: | Q1 | B4 | After moving backward, which way does the RVC turn, and what happens if left and right are still both blocked? **Resolved by C5.** |
26: | Q2 | B4 | How far or how many ticks does the RVC move backward? **Resolved by C6.** |
27: | Q3 | C2 | How many ticks does the stop last? **Resolved by C7.** |
28: | Q4 | B5, C3 | If dust is detected again during the 5 ticks, does the count restart or continue? **Resolved by C10.** |
29: | Q5 | B3, C3 | If an obstacle interrupts powered-up cleaning, is the remaining count kept or cancelled? **Resolved by C11.** |
30: | Q6 | B3 | Does an obstacle on the left or right trigger avoidance when the front is clear? This analysis assumes it does not. |

# FILE: artifacts/SA/context_diagram.md
1: # System Context Diagram
2: 
3: System: RVC Controller
4: Sources: `docs/preliminary_requirements.md`, `docs/requirements_clarifications.md`, `artifacts/SA/event_list.md`
5: 
6: ## System Boundary
7: 
8: - Inside: the automatic cleaning control logic of the RVC Controller (B7).
9: - Outside: the sensors and digital clock that supply inputs, and the motor and cleaner that receive commands. Their hardware design and control are out of scope (B6).
10: 
11: ## Diagram
12: 
13: ```mermaid
14: flowchart LR
15:     FrontSensor["Front Sensor"]
16:     LeftSensor["Left Sensor"]
17:     RightSensor["Right Sensor"]
18:     DustSensor["Dust Sensor"]
19:     DigitalClock["Digital Clock"]
20:     System(("RVC Controller"))
21:     Motor["Motor"]
22:     Cleaner["Cleaner"]
23: 
24:     FrontSensor -->|Front Sensor Input| System
25:     LeftSensor -->|Left Sensor Input| System
26:     RightSensor -->|Right Sensor Input| System
27:     DustSensor -->|Dust Sensor Input| System
28:     DigitalClock -.->|Tick| System
29:     System -->|Direction| Motor
30:     System -->|Clean| Cleaner
31: ```
32: 
33: Solid arrows are data flows. The dashed arrow is a control flow.

# FILE: artifacts/SA/data_dictionary.md
1: # Data Dictionary
2: 
3: Current coverage: Event List, Context Diagram, DFD Levels 0-3.
4: 
5: ## 1. External Input/Output Events
6: 
7: | Input/Output Event | Description | Format / Type |
8: |---|---|---|
9: | Front Sensor Input | Reports whether an obstacle is detected in front of the RVC. | Boolean |
10: | Left Sensor Input | Reports whether an obstacle is detected on the left side of the RVC. | Boolean |
11: | Right Sensor Input | Reports whether an obstacle is detected on the right side of the RVC. | Boolean |
12: | Dust Sensor Input | Reports whether dust is detected on the surface being cleaned. | Boolean |
13: | Tick | Clock event that provides the time base for the system. | Event |
14: | Direction | Movement command sent to the motor. | Enum |
15: | Clean | Cleaning command sent to the cleaner. | Enum |
16: 
17: ## 2. Internal Data and Control Flows
18: 
19: No internal flows exist at DFD Level 0.
20: 
21: | Data Name | Description | Format / Type | Flow Category | Source | Destination | DFD Level |
22: |---|---|---|---|---|---|---|
23: | Obstacle Location | Latest obstacle detection result for front, left, and right. | Front Obstacle + Left Obstacle + Right Obstacle | Data | Process 1; D1 Obstacle Location | D1 Obstacle Location; Process 3 (L1), 3.1 (L2) | 1, 2 |
24: | Dust Existence | Latest dust detection result. | Dust Detected | Data | Process 2; D2 Dust Existence | D2 Dust Existence; Process 4 (L1), 4.1 (L2) | 1, 2 |
25: | Movement Status | Whether the RVC is moving forward or avoiding an obstacle. | Enum | Data | Process 3 (L1), 3.2 (L2), 3.2.3 (L3) | Process 4 (L1), 4.1 and 4.2 (L2, L3) | 1, 2, 3 |
26: | Obstacle Situation | Classification of the current obstacles: Front Blocked and Side Situation. | Record | Data | Process 3.1 | Process 3.2 (L2), 3.2.1 (L3) | 2, 3 |
27: | Situation Signal | Obstacle Situation delivered to the Controller as a control signal. | Record | Control | Process 3.2.1 | Process 3.2.2 | 3 |
28: | Movement Command | Action chosen by the Controller for the current tick. | Enum | Control | Process 3.2.2 | Process 3.2.3 | 3 |
29: | Start Step Timer | Tells the step timer to begin counting a 5-tick stop, backward, or turn step. | Event | Control | Process 3.2.2 | Process 3.2.4 | 3 |
30: | Step Done | Signals that the current stop, backward, or turn step has lasted 5 ticks. | Event | Control | Process 3.2.4 | Process 3.2.2 | 3 |
31: | Step Ticks Elapsed | Ticks counted in the current stop, backward, or turn step. | Idle or Integer 0-5 | Data | Process 3.2.4; D4 Step Timer | D4 Step Timer; Process 3.2.4 | 3 |
32: | Power-Up Active | Whether powered-up cleaning applies this tick. | Boolean | Data | Process 4.1 | Process 4.2 | 2 |
33: | Remaining Power-Up Ticks | Ticks of powered-up cleaning still to run. | Integer, 0-5 | Data | Process 4.1; D3 Power-Up Timer | D3 Power-Up Timer; Process 4.1 | 2 |
34: 
35: ## 3. Data Store Definitions
36: 
37: No Data Stores exist at DFD Level 0.
38: 
39: | Data Store | Description | Stored Data | Format / Type | DFD Level |
40: |---|---|---|---|---|
41: | D1 Obstacle Location | Holds the latest front, left, and right obstacle readings for use on the next Tick. | Front Obstacle, Left Obstacle, Right Obstacle | Record of 3 Booleans | 1, 2 |
42: | D2 Dust Existence | Holds the latest dust reading for use on the next Tick. | Dust Detected | Boolean | 1, 2 |
43: | D3 Power-Up Timer | Holds the remaining powered-up cleaning ticks across ticks. | Remaining Power-Up Ticks | Integer, 0-5 | 2, 3 |
44: | D4 Step Timer | Holds the tick count of the current stop, backward, or turn step across ticks. | Step Ticks Elapsed | Idle or Integer 0-5 | 3 |
45: 
46: ## 4. Detailed Data Definitions
47: 
48: ### Front Sensor Input
49: - Description: Reports whether an obstacle is detected in front of the RVC.
50: - Format / Type: Boolean
51: - Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
52: - Flow Category: Data
53: - Source: Front Sensor
54: - Destination: Process 0; Process 1 (Level 1)
55: - DFD Level: Context, 0, 1
56: - Requirement Reference: B3, B4
57: 
58: ### Left Sensor Input
59: - Description: Reports whether an obstacle is detected on the left side of the RVC.
60: - Format / Type: Boolean
61: - Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
62: - Flow Category: Data
63: - Source: Left Sensor
64: - Destination: Process 0; Process 1 (Level 1)
65: - DFD Level: Context, 0, 1
66: - Requirement Reference: B3, B4, C1
67: 
68: ### Right Sensor Input
69: - Description: Reports whether an obstacle is detected on the right side of the RVC.
70: - Format / Type: Boolean
71: - Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
72: - Flow Category: Data
73: - Source: Right Sensor
74: - Destination: Process 0; Process 1 (Level 1)
75: - DFD Level: Context, 0, 1
76: - Requirement Reference: B3, B4, C1
77: 
78: ### Dust Sensor Input
79: - Description: Reports whether dust is detected on the surface being cleaned.
80: - Format / Type: Boolean
81: - Possible Values: TRUE (dust detected), FALSE (no dust detected)
82: - Flow Category: Data
83: - Source: Dust Sensor
84: - Destination: Process 0; Process 2 (Level 1)
85: - DFD Level: Context, 0, 1
86: - Requirement Reference: B5
87: 
88: ### Tick
89: - Description: Clock event that provides the time base for the system. Powered-up cleaning lasts 5 ticks.
90: - Format / Type: Event
91: - Possible Values: None; the occurrence of the event is the information.
92: - Flow Category: Control
93: - Source: Digital Clock
94: - Destination: Process 0; Processes 3 and 4 (Level 1); Processes 3.1, 3.2, 4.1 (Level 2); Processes 3.1, 3.2.2, 3.2.4, 4.1 (Level 3)
95: - DFD Level: Context, 0, 1, 2, 3
96: - Requirement Reference: B5, C3
97: 
98: ### Direction
99: - Description: Movement command sent to the motor.
100: - Format / Type: Enum
101: - Possible Values: Forward, Backward, Turn Left, Turn Right, Stop
102: - Flow Category: Data
103: - Source: Process 0; Process 3 (Level 1); Process 3.2 (Level 2); Process 3.2.3 (Level 3)
104: - Destination: Motor
105: - DFD Level: Context, 0, 1, 2, 3
106: - Requirement Reference: B2, B3, B4, C1, C2
107: 
108: ### Clean
109: - Description: Cleaning command sent to the cleaner.
110: - Format / Type: Enum
111: - Possible Values: Start, Stop, Power Up
112: - Flow Category: Data
113: - Source: Process 0; Process 4 (Level 1); Process 4.2 (Level 2)
114: - Destination: Cleaner
115: - DFD Level: Context, 0, 1, 2, 3
116: - Requirement Reference: B1, B2, B3, B5, C3
117: 
118: ### Obstacle Location
119: - Description: Latest obstacle detection result for the three obstacle sensors. Written by Process 1, kept in D1, read by Process 3 on Tick.
120: - Format / Type: Record = Front Obstacle + Left Obstacle + Right Obstacle (each Boolean)
121: - Possible Values: Each field TRUE (obstacle) or FALSE (no obstacle)
122: - Flow Category: Data
123: - Source: Process 1 (write); D1 Obstacle Location (read)
124: - Destination: D1 Obstacle Location; Process 3 (Level 1); Process 3.1 (Level 2)
125: - DFD Level: 1, 2
126: - Requirement Reference: B3, B4, C1, Q6
127: 
128: ### Dust Existence
129: - Description: Latest dust detection result. Written by Process 2, kept in D2, read by Process 4 on Tick.
130: - Format / Type: Record = Dust Detected (Boolean)
131: - Possible Values: TRUE (dust detected), FALSE (no dust detected)
132: - Flow Category: Data
133: - Source: Process 2 (write); D2 Dust Existence (read)
134: - Destination: D2 Dust Existence; Process 4 (Level 1); Process 4.1 (Level 2)
135: - DFD Level: 1, 2
136: - Requirement Reference: B5
137: 
138: ### Movement Status
139: - Description: Tells Process 4 whether the RVC is moving forward (cleaning allowed) or avoiding an obstacle (cleaning stopped).
140: - Format / Type: Enum
141: - Possible Values: Forward, Avoiding
142: - Flow Category: Data
143: - Source: Process 3 (Level 1); Process 3.2 (Level 2); Process 3.2.3 (Level 3)
144: - Destination: Process 4 (Level 1); Processes 4.1 and 4.2 (Level 2)
145: - DFD Level: 1, 2, 3
146: - Requirement Reference: B2, B3, B4
147: 
148: ### D1 Obstacle Location (Data Store)
149: - Description: Holds the latest Obstacle Location so that Process 3 can use all three readings on each Tick.
150: - Format / Type: Record of 3 Booleans
151: - Stored Data: Front Obstacle, Left Obstacle, Right Obstacle
152: - Source: Process 1
153: - Destination: Process 3 (Level 1); Process 3.1 (Level 2)
154: - DFD Level: 1, 2
155: - Requirement Reference: B3, B4
156: 
157: ### D2 Dust Existence (Data Store)
158: - Description: Holds the latest Dust Existence so that Process 4 can use it on each Tick.
159: - Format / Type: Boolean
160: - Stored Data: Dust Detected
161: - Source: Process 2
162: - Destination: Process 4 (Level 1); Process 4.1 (Level 2)
163: - DFD Level: 1, 2
164: - Requirement Reference: B5
165: 
166: ### Obstacle Situation
167: - Description: Classification of the obstacles read from D1. It has two parts. Front Blocked says whether an obstacle is detected in front. Side Situation classifies left and right, whether or not the front is blocked (C9).
168: - Format / Type: Record = Front Blocked (Boolean) + Side Situation (Enum)
169: - Possible Values: Front Blocked: TRUE or FALSE. Side Situation: Right Open (right clear), Left Open (right blocked, left clear), Sides Blocked (left and right blocked)
170: - Flow Category: Data
171: - Source: Process 3.1
172: - Destination: Process 3.2 (Level 2); Process 3.2.1 (Level 3)
173: - DFD Level: 2, 3
174: - Requirement Reference: B3, B4, C1, Q6, C9
175: 
176: ### Power-Up Active
177: - Description: Whether powered-up cleaning applies on the current tick.
178: - Format / Type: Boolean
179: - Possible Values: TRUE (power up), FALSE (normal cleaning or stopped)
180: - Flow Category: Data
181: - Source: Process 4.1
182: - Destination: Process 4.2
183: - DFD Level: 2
184: - Requirement Reference: B5, C3
185: 
186: ### Remaining Power-Up Ticks
187: - Description: Number of powered-up cleaning ticks still to run, including the current tick before it is counted down.
188: - Format / Type: Integer
189: - Possible Values: 0-5 (0 = no power-up in progress; set to 5 on every dust detection while moving forward, C10; kept while avoiding, C11)
190: - Flow Category: Data
191: - Source: Process 4.1 (write); D3 Power-Up Timer (read)
192: - Destination: D3 Power-Up Timer; Process 4.1
193: - DFD Level: 2
194: - Requirement Reference: B5, C3, C10, C11
195: 
196: ### D3 Power-Up Timer (Data Store)
197: - Description: Holds Remaining Power-Up Ticks so that the 5-tick power-up persists across ticks.
198: - Format / Type: Integer, 0-5
199: - Stored Data: Remaining Power-Up Ticks
200: - Source: Process 4.1
201: - Destination: Process 4.1
202: - DFD Level: 2
203: - Requirement Reference: B5, C3
204: 
205: ### Situation Signal
206: - Description: The Obstacle Situation delivered to the Movement Controller as a control signal. The Controller uses Front Blocked while going forward and the Side Situation when a stop or backward step ends.
207: - Format / Type: Record = Front Blocked (Boolean) + Side Situation (Enum)
208: - Possible Values: Same as Obstacle Situation: Front Blocked (TRUE or FALSE) and Side Situation (Right Open, Left Open, Sides Blocked)
209: - Flow Category: Control
210: - Source: Process 3.2.1
211: - Destination: Process 3.2.2
212: - DFD Level: 3
213: - Requirement Reference: B3, B4, C1, C4, Q6, C9
214: 
215: ### Movement Command
216: - Description: The action chosen by the Movement Controller for the current tick. It triggers Process 3.2.3.
217: - Format / Type: Enum
218: - Possible Values: Forward, Stop, Turn Right, Turn Left, Backward
219: - Flow Category: Control
220: - Source: Process 3.2.2
221: - Destination: Process 3.2.3
222: - DFD Level: 3
223: - Requirement Reference: B2, B3, B4, C1, C2
224: 
225: ### Start Step Timer
226: - Description: Issued by the Movement Controller when a 5-tick stop (C7), backward (C6), or turn (C8) step begins. Resets the step count.
227: - Format / Type: Event
228: - Possible Values: None; the occurrence of the event is the information.
229: - Flow Category: Control
230: - Source: Process 3.2.2
231: - Destination: Process 3.2.4
232: - DFD Level: 3
233: - Requirement Reference: C6, C7, C8
234: 
235: ### Step Done
236: - Description: Present on the tick when the current stop, backward, or turn step has lasted 5 ticks.
237: - Format / Type: Event
238: - Possible Values: None; the occurrence of the event is the information.
239: - Flow Category: Control
240: - Source: Process 3.2.4
241: - Destination: Process 3.2.2
242: - DFD Level: 3
243: - Requirement Reference: C6, C7, C8
244: 
245: ### Step Ticks Elapsed
246: - Description: Number of ticks counted since Start Step Timer, not counting the tick on which the timer was started.
247: - Format / Type: Idle or Integer
248: - Possible Values: Idle (no step running), 0-5 (Step Done is emitted when it reaches 5, then it returns to Idle)
249: - Flow Category: Data
250: - Source: Process 3.2.4 (write); D4 Step Timer (read)
251: - Destination: D4 Step Timer; Process 3.2.4
252: - DFD Level: 3
253: - Requirement Reference: C6, C7, C8
254: 
255: ### D4 Step Timer (Data Store)
256: - Description: Holds Step Ticks Elapsed so that the 5-tick stop, backward, and turn steps persist across ticks.
257: - Format / Type: Idle or Integer 0-5
258: - Stored Data: Step Ticks Elapsed
259: - Source: Process 3.2.4
260: - Destination: Process 3.2.4
261: - DFD Level: 3
262: - Requirement Reference: C6, C7, C8

# FILE: artifacts/SA/DFD/dfd_level_0.md
1: # DFD Level 0
2: 
3: System: RVC Controller
4: Sources: `docs/preliminary_requirements.md`, `docs/requirements_clarifications.md`, `artifacts/SA/event_list.md`, `artifacts/SA/context_diagram.md`
5: 
6: ## Diagram
7: 
8: ```mermaid
9: flowchart LR
10:     FrontSensor["Front Sensor"]
11:     LeftSensor["Left Sensor"]
12:     RightSensor["Right Sensor"]
13:     DustSensor["Dust Sensor"]
14:     DigitalClock["Digital Clock"]
15:     P0(("0. RVC Controller"))
16:     Motor["Motor"]
17:     Cleaner["Cleaner"]
18: 
19:     FrontSensor -->|Front Sensor Input| P0
20:     LeftSensor -->|Left Sensor Input| P0
21:     RightSensor -->|Right Sensor Input| P0
22:     DustSensor -->|Dust Sensor Input| P0
23:     DigitalClock -.->|Tick| P0
24:     P0 -->|Direction| Motor
25:     P0 -->|Clean| Cleaner
26: ```
27: 
28: Solid arrows are data flows. The dashed arrow is a control flow.
29: 
30: ## Process
31: 
32: | Process ID | Process Name | Responsibility |
33: |---|---|---|
34: | 0 | RVC Controller | Turns sensor inputs and clock ticks into movement and cleaning commands. |
35: 
36: ## Balancing with the Context Diagram
37: 
38: | Flow | Direction | Category | External Entity | Context Diagram | Level 0 |
39: |---|---|---|---|---|---|
40: | Front Sensor Input | Input | Data | Front Sensor | Yes | Yes |
41: | Left Sensor Input | Input | Data | Left Sensor | Yes | Yes |
42: | Right Sensor Input | Input | Data | Right Sensor | Yes | Yes |
43: | Dust Sensor Input | Input | Data | Dust Sensor | Yes | Yes |
44: | Tick | Input | Control | Digital Clock | Yes | Yes |
45: | Direction | Output | Data | Motor | Yes | Yes |
46: | Clean | Output | Data | Cleaner | Yes | Yes |
47: 
48: Level 0 introduces no flows, Data Stores, or internal processes beyond the Context Diagram.

# FILE: artifacts/SA/DFD/dfd_level_1.md
1: # DFD Level 1
2: 
3: System: RVC Controller
4: Parent: Process 0 (RVC Controller), `artifacts/SA/DFD/dfd_level_0.md`
5: Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C3, Q1-Q6), `artifacts/SA/event_list.md`, `artifacts/SA/context_diagram.md`
6: 
7: ## Diagram
8: 
9: ```mermaid
10: flowchart LR
11:     FrontSensor["Front Sensor"]
12:     LeftSensor["Left Sensor"]
13:     RightSensor["Right Sensor"]
14:     DustSensor["Dust Sensor"]
15:     DigitalClock["Digital Clock"]
16:     Motor["Motor"]
17:     Cleaner["Cleaner"]
18: 
19:     P1(("1. Detect Obstacle"))
20:     P2(("2. Detect Dust"))
21:     P3(("3. Control Movement"))
22:     P4(("4. Control Cleaning"))
23: 
24:     DS1[["D1 Obstacle Location"]]
25:     DS2[["D2 Dust Existence"]]
26: 
27:     FrontSensor -->|Front Sensor Input| P1
28:     LeftSensor -->|Left Sensor Input| P1
29:     RightSensor -->|Right Sensor Input| P1
30:     DustSensor -->|Dust Sensor Input| P2
31: 
32:     P1 -->|Obstacle Location| DS1
33:     P2 -->|Dust Existence| DS2
34: 
35:     DS1 -->|Obstacle Location| P3
36:     DS2 -->|Dust Existence| P4
37: 
38:     DigitalClock -.->|Tick| P3
39:     DigitalClock -.->|Tick| P4
40: 
41:     P3 -->|Movement Status| P4
42: 
43:     P3 -->|Direction| Motor
44:     P4 -->|Clean| Cleaner
45: ```
46: 
47: Solid arrows are data flows. Dashed arrows are control flows. `[[ ]]` nodes are Data Stores.
48: 
49: All four processes are data processes. No control process is introduced at this level: control and data processing are separated at Level 3, where the Controller is identified for the Level 4 FSM (sa-dfd Step 5.4).
50: 
51: ## Processes
52: 
53: | Process ID | Process Name | Responsibility | Requirements |
54: |---|---|---|---|
55: | 1 | Detect Obstacle | Reads the front, left, and right sensor inputs and records where obstacles are. | B3, B4, C1 |
56: | 2 | Detect Dust | Reads the dust sensor input and records whether dust is present. | B5 |
57: | 3 | Control Movement | On each Tick, decides the movement from the obstacle locations: go forward, stop, turn right or left, or move backward. Reports whether the RVC is moving forward or avoiding an obstacle. | B2, B3, B4, C1, C2 |
58: | 4 | Control Cleaning | On each Tick, decides the cleaning command from the movement status and dust existence: start, stop, or power up for 5 ticks. | B1, B2, B3, B5, C3 |
59: 
60: ### Decomposition rationale
61: 
62: - 1 and 2 separate sensor interpretation from decision making. Each groups the inputs of one requirement: obstacle sensors (B3, B4) and the dust sensor (B5).
63: - 3 and 4 follow the two outputs of Process 0. Movement (`Direction`) depends on obstacles; cleaning (`Clean`) depends on dust and on whether the RVC is avoiding an obstacle (B3: "stops cleaning ... goes forward with cleaning").
64: - `Movement Status` is the only coupling between 3 and 4. It carries the B3 rule that cleaning stops while avoiding and resumes when moving forward again.
65: 
66: ## Data Stores
67: 
68: | ID | Data Store | Contents | Written by | Read by | Justification |
69: |---|---|---|---|---|---|
70: | D1 | Obstacle Location | Front Obstacle, Left Obstacle, Right Obstacle | 1 | 3 | Sensor inputs arrive independently of the clock. 3 acts on Tick, so it needs the latest reading of all three sensors at that moment. |
71: | D2 | Dust Existence | Dust Detected | 2 | 4 | Same reason: 4 acts on Tick and needs the latest dust reading. |
72: 
73: The 5-tick power-up count is kept inside Process 4 at this level. Whether it needs its own Data Store is decided at Level 2.
74: 
75: ## Internal Flows
76: 
77: | Flow | Category | Source | Destination | Content |
78: |---|---|---|---|---|
79: | Obstacle Location | Data | 1 (write), D1 (read) | D1, 3 | Front Obstacle + Left Obstacle + Right Obstacle |
80: | Dust Existence | Data | 2 (write), D2 (read) | D2, 4 | Dust Detected |
81: | Movement Status | Data | 3 | 4 | Forward or Avoiding |
82: 
83: ## Balancing with Level 0
84: 
85: | Level 0 Flow | Direction | Category | External Entity | Level 1 Process | Balanced |
86: |---|---|---|---|---|---|
87: | Front Sensor Input | Input | Data | Front Sensor | 1 | Yes |
88: | Left Sensor Input | Input | Data | Left Sensor | 1 | Yes |
89: | Right Sensor Input | Input | Data | Right Sensor | 1 | Yes |
90: | Dust Sensor Input | Input | Data | Dust Sensor | 2 | Yes |
91: | Tick | Input | Control | Digital Clock | 3, 4 | Yes (split, see below) |
92: | Direction | Output | Data | Motor | 3 | Yes |
93: | Clean | Output | Data | Cleaner | 4 | Yes |
94: 
95: Flow mapping: the single Level 0 `Tick` is delivered to both 3 and 4. It is the same event, not two different flows.
96: 
97: No external flow was added or removed. `Obstacle Location`, `Dust Existence`, and `Movement Status` are internal to Process 0.
98: 
99: ## Open Issues Affecting Level 1
100: 
101: Update 2026-11-08: Q1, Q2, Q3 are resolved by C5, C6, C7 and applied at Level 3 and in the Level 4 FSM. C4 (obstacles do not disappear) also applies.
102: 
103: These come from `docs/requirements_clarifications.md` and are not resolved here.
104: 
105: | ID | Affects | Effect at Level 1 |
106: |---|---|---|
107: | Q1 | 3 | Turn direction after backward movement, and what to do if left and right are still blocked. |
108: | Q2 | 3 | Duration of backward movement. |
109: | Q3 | 3 | Duration of the stop (C2). |
110: | Q4 | 4 | Whether new dust during power-up restarts the 5-tick count. |
111: | Q5 | 3, 4 | Whether an obstacle cancels or keeps the remaining power-up count when `Movement Status` becomes Avoiding. |
112: | Q6 | 1, 3 | Whether a side obstacle with a clear front triggers avoidance. Assumed not: 3 uses Left/Right Obstacle only when Front Obstacle is TRUE. |

# FILE: artifacts/SA/DFD/dfd_level_2.md
1: # DFD Level 2
2: 
3: System: RVC Controller
4: Parent: DFD Level 1, `artifacts/SA/DFD/dfd_level_1.md`
5: Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C4, Q1-Q6), `artifacts/SA/event_list.md`, `artifacts/SA/context_diagram.md`, `artifacts/SA/DFD/dfd_level_0.md`, `artifacts/SA/DFD/dfd_level_1.md`
6: 
7: ## Decomposition Scope
8: 
9: | Level 1 Process | Decomposed | Reason |
10: |---|---|---|
11: | 1 Detect Obstacle | No | Functional primitive. It copies three Boolean sensor values into D1; splitting it into per-sensor processes would add no function the requirements describe. Its Level 1 Process Specification is complete. |
12: | 2 Detect Dust | No | Functional primitive. It copies one Boolean sensor value into D2. |
13: | 3 Control Movement | Yes → 3.1, 3.2 | It mixes two functions: classifying the obstacle situation (B3, B4, C1, Q6) and sequencing the movement over several ticks (stop, turn, backward, forward; B3, B4, C2). |
14: | 4 Control Cleaning | Yes → 4.1, 4.2 | It mixes two functions: counting the 5-tick power-up (B5, C3) and choosing the cleaning command (B1-B3, B5). |
15: 
16: ## Diagram 3: Control Movement
17: 
18: ```mermaid
19: flowchart LR
20:     DigitalClock["Digital Clock"]
21:     Motor["Motor"]
22:     DS1[["D1 Obstacle Location"]]
23:     P4ext(("4. Control Cleaning"))
24: 
25:     P31(("3.1 Assess Obstacle Situation"))
26:     P32(("3.2 Decide Movement"))
27: 
28:     DS1 -->|Obstacle Location| P31
29:     DigitalClock -.->|Tick| P31
30:     DigitalClock -.->|Tick| P32
31:     P31 -->|Obstacle Situation| P32
32:     P32 -->|Direction| Motor
33:     P32 -->|Movement Status| P4ext
34: ```
35: 
36: Solid arrows are data flows. Dashed arrows are control flows. `[[ ]]` nodes are Data Stores. `4. Control Cleaning` is a sibling Level 1 process, shown only as the destination of `Movement Status`.
37: 
38: ### Processes
39: 
40: | Process ID | Process Name | Responsibility | Requirements |
41: |---|---|---|---|
42: | 3.1 | Assess Obstacle Situation | On each Tick, reads D1 and classifies the obstacles into one Obstacle Situation. Applies the right-first rule (C1) and uses left/right only when the front is blocked (Q6 assumption). | B3, B4, C1, Q6 |
43: | 3.2 | Decide Movement | On each Tick, chooses the Direction from the Obstacle Situation and the current avoidance step: stop first (C2), then turn, or move backward then turn; go forward when clear. Reports Movement Status to Process 4. | B2, B3, B4, C1, C2 |
44: 
45: The avoidance step (stopping, turning, moving backward) is control state that persists across ticks. It stays inside 3.2 at this level. Level 3 separates it from 3.2 as the Controller, which Level 4 describes as an FSM.
46: 
47: ### Balancing with Process 3
48: 
49: | Process 3 Flow | Direction | Category | Level 2 Process | Balanced |
50: |---|---|---|---|---|
51: | Obstacle Location (from D1) | Input | Data | 3.1 | Yes |
52: | Tick | Input | Control | 3.1, 3.2 | Yes (same event to both) |
53: | Direction | Output | Data | 3.2 | Yes |
54: | Movement Status | Output | Data | 3.2 | Yes |
55: 
56: Internal flow added: `Obstacle Situation` (3.1 → 3.2).
57: 
58: ## Diagram 4: Control Cleaning
59: 
60: ```mermaid
61: flowchart LR
62:     DigitalClock["Digital Clock"]
63:     Cleaner["Cleaner"]
64:     DS2[["D2 Dust Existence"]]
65:     DS3[["D3 Power-Up Timer"]]
66:     P3ext(("3. Control Movement"))
67: 
68:     P41(("4.1 Track Power-Up"))
69:     P42(("4.2 Decide Cleaning"))
70: 
71:     DS2 -->|Dust Existence| P41
72:     DigitalClock -.->|Tick| P41
73:     P3ext -->|Movement Status| P41
74:     P3ext -->|Movement Status| P42
75:     DS3 -->|Remaining Power-Up Ticks| P41
76:     P41 -->|Remaining Power-Up Ticks| DS3
77:     P41 -->|Power-Up Active| P42
78:     P42 -->|Clean| Cleaner
79: ```
80: 
81: Solid arrows are data flows. Dashed arrows are control flows. `[[ ]]` nodes are Data Stores. `3. Control Movement` is a sibling Level 1 process, shown only as the source of `Movement Status`.
82: 
83: ### Processes
84: 
85: | Process ID | Process Name | Responsibility | Requirements |
86: |---|---|---|---|
87: | 4.1 | Track Power-Up | On each Tick, starts a 5-tick power-up when dust is detected while moving forward, counts it down, and reports whether power-up is active this tick. | B5, C3 |
88: | 4.2 | Decide Cleaning | Chooses the Clean command: Stop while avoiding, Power Up while power-up is active, otherwise Start. Runs when 4.1 reports Power-Up Active for the tick. | B1, B2, B3, B5 |
89: 
90: ### Data Store
91: 
92: | ID | Data Store | Contents | Written by | Read by | Justification |
93: |---|---|---|---|---|---|
94: | D3 | Power-Up Timer | Remaining Power-Up Ticks (0-5) | 4.1 | 4.1 | The 5-tick count (C3) must persist across ticks. Level 1 deferred this decision to Level 2. |
95: 
96: ### Balancing with Process 4
97: 
98: | Process 4 Flow | Direction | Category | Level 2 Process | Balanced |
99: |---|---|---|---|---|
100: | Dust Existence (from D2) | Input | Data | 4.1 | Yes |
101: | Movement Status | Input | Data | 4.1, 4.2 | Yes (same flow to both) |
102: | Tick | Input | Control | 4.1 | Yes |
103: | Clean | Output | Data | 4.2 | Yes |
104: 
105: Internal items added: `Power-Up Active` (4.1 → 4.2), `Remaining Power-Up Ticks` (4.1 ↔ D3), Data Store D3.
106: 
107: ## Overall Balancing with Level 0
108: 
109: | Level 0 Flow | Level 1 Process | Level 2 Process |
110: |---|---|---|
111: | Front Sensor Input | 1 | 1 (not decomposed) |
112: | Left Sensor Input | 1 | 1 (not decomposed) |
113: | Right Sensor Input | 1 | 1 (not decomposed) |
114: | Dust Sensor Input | 2 | 2 (not decomposed) |
115: | Tick | 3, 4 | 3.1, 3.2, 4.1 |
116: | Direction | 3 | 3.2 |
117: | Clean | 4 | 4.2 |
118: 
119: No external flow was added or removed. All new flows and D3 are internal to their parent processes.
120: 
121: ## Open Issues Affecting Level 2
122: 
123: Update 2026-11-08: Q1, Q2, Q3 are resolved by C5, C6, C7 and applied at Level 3 and in the Level 4 FSM.
124: 
125: | ID | Affects | Effect at Level 2 |
126: |---|---|---|
127: | Q1 | 3.2 | Turn direction after backward movement, and what to do if left and right are still blocked. |
128: | Q2 | 3.2 | Number of ticks spent moving backward. |
129: | Q3 | 3.2 | Number of ticks spent stopped (C2). |
130: | Q4 | 4.1 | Whether dust detected while Remaining Power-Up Ticks > 0 resets the count to 5 or is ignored. |
131: | Q5 | 4.1 | Whether D3 is cleared or kept when Movement Status becomes Avoiding. |
132: | Q6 | 3.1 | Assumed: left/right obstacles are ignored while the front is clear. |
133: | C4 | 3.2 | Resolved: obstacles do not disappear, so the Situation seen when stopping does not become Clear before the avoidance completes. 3.2 has no "front cleared while stopped" branch. |
134: | — | 4.1 | B5 does not say whether dust detected while Avoiding starts a power-up. Level 1 (Process 4) already limits it to moving forward; Level 2 keeps that. |

# FILE: artifacts/SA/DFD/dfd_level_3.md
1: # DFD Level 3
2: 
3: System: RVC Controller
4: Parent: DFD Level 2, `artifacts/SA/DFD/dfd_level_2.md`
5: Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C11, Q6), `artifacts/SA/DFD/dfd_level_0.md`, `artifacts/SA/DFD/dfd_level_1.md`, `artifacts/SA/DFD/dfd_level_2.md`
6: 
7: ## Decomposition Scope
8: 
9: | Level 2 Process | Decomposed | Reason |
10: |---|---|---|
11: | 1 Detect Obstacle | No | Primitive since Level 2. |
12: | 2 Detect Dust | No | Primitive since Level 2. |
13: | 3.1 Assess Obstacle Situation | No | Primitive. A single stateless classification of D1 (see its Process Specification). |
14: | 3.2 Decide Movement | Yes → 3.2.1, 3.2.2, 3.2.3, 3.2.4 | It mixes control and data processing: it keeps the avoidance step across ticks (control state), counts the 5-tick stop, backward, and turn periods (C6, C7, C8), and produces the Direction and Movement Status data. Level 3 separates the control part as the Controller (sa-dfd Step 5.4). |
15: | 4.1 Track Power-Up | No | Primitive. Its only state is a number (Remaining Power-Up Ticks) kept in D3 and handled by arithmetic, not by mode sequencing. |
16: | 4.2 Decide Cleaning | No | Primitive. A stateless choice among three Clean values. |
17: 
18: ## Diagram 3.2: Decide Movement
19: 
20: ```mermaid
21: flowchart LR
22:     DigitalClock["Digital Clock"]
23:     Motor["Motor"]
24:     P31ext(("3.1 Assess Obstacle Situation"))
25:     P4ext(("4. Control Cleaning"))
26:     DS4[["D4 Step Timer"]]
27: 
28:     P321(("3.2.1 Signal Obstacle Situation"))
29:     P322(("3.2.2 Movement Controller"))
30:     P323(("3.2.3 Issue Movement Output"))
31:     P324(("3.2.4 Time Movement Step"))
32: 
33:     P31ext -->|Obstacle Situation| P321
34:     P321 -.->|Situation Signal| P322
35:     DigitalClock -.->|Tick| P322
36:     DigitalClock -.->|Tick| P324
37:     P322 -.->|Start Step Timer| P324
38:     P324 -.->|Step Done| P322
39:     DS4 -->|Step Ticks Elapsed| P324
40:     P324 -->|Step Ticks Elapsed| DS4
41:     P322 -.->|Movement Command| P323
42:     P323 -->|Direction| Motor
43:     P323 -->|Movement Status| P4ext
44: 
45:     classDef control stroke-dasharray: 5 5
46:     class P322 control
47: ```
48: 
49: Solid arrows are data flows. Dashed arrows are control flows. `3.2.2 Movement Controller` is drawn with a dashed border: it is a control process. `3.1` and `4. Control Cleaning` are shown only as the source and destination of the parent's flows.
50: 
51: ## Processes
52: 
53: | Process ID | Process Name | Type | Responsibility | Requirements |
54: |---|---|---|---|---|
55: | 3.2.1 | Signal Obstacle Situation | Data | Converts the Obstacle Situation data from 3.1 into a Situation Signal control flow for the Controller. | B3, B4, C1 |
56: | 3.2.2 | Movement Controller | Control | Keeps the current state (Forward, Stopping, Backing, Turning Right, Turning Left). On each Tick, uses Situation Signal and Step Done to choose the next state, issues one Movement Command, and starts the step timer when a 5-tick step begins. Specified by the Level 4 FSM. | B2, B3, B4, C1, C2, C4-C8 |
57: | 3.2.3 | Issue Movement Output | Data | When a Movement Command arrives, sends the matching Direction to the Motor and the matching Movement Status to Process 4. | B2, B3, B4 |
58: | 3.2.4 | Time Movement Step | Data | Counts the ticks of the current stop, backward, or turn step in D4 and signals Step Done when 5 ticks have elapsed. | C6, C7, C8 |
59: 
60: ## Data Store
61: 
62: | ID | Data Store | Contents | Written by | Read by | Justification |
63: |---|---|---|---|---|---|
64: | D4 | Step Timer | Step Ticks Elapsed (Idle or 0-5) | 3.2.4 | 3.2.4 | The 5-tick stop (C7), backward movement (C6), and turn (C8) must be counted across ticks. The count is numeric data, so it is kept outside the control process, like D3 for the power-up. |
65: 
66: ## Controller Interface (input to Level 4)
67: 
68: | Item | Kind | Values |
69: |---|---|---|
70: | Tick | Input event (control) | — |
71: | Situation Signal | Input condition (control) | Front Blocked (yes or no) and Side Situation (Right Open, Left Open, Sides Blocked) |
72: | Step Done | Input condition (control) | Present on the tick when the running stop, backward, or turn step has lasted 5 ticks |
73: | Movement Command | Output action (control) | Forward, Stop, Turn Right, Turn Left, Backward |
74: | Start Step Timer | Output action (control) | — |
75: | Controller states | Internal | Forward (initial), Stopping, Backing, Turning Right, Turning Left |
76: 
77: ## Controller Behavior
78: 
79: | Current State | Tick condition | Actions | Next State | Source |
80: |---|---|---|---|---|
81: | Forward | not Front Blocked | Forward | Forward | B2 |
82: | Forward | Front Blocked | Stop, Start Step Timer | Stopping | B3, C2, C7 |
83: | Stopping | not Step Done | Stop | Stopping | C7 |
84: | Stopping | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | B3, C1, C8 |
85: | Stopping | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | B3, C8 |
86: | Stopping | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | B4, C6 |
87: | Backing | not Step Done | Backward | Backing | C6 |
88: | Backing | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | C5, C6, C9 |
89: | Backing | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C5, C8 |
90: | Backing | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | C5, C8 |
91: | Turning Right | not Step Done | Turn Right | Turning Right | C8 |
92: | Turning Right | Step Done | Forward | Forward | B3, B4, C8 |
93: | Turning Left | not Step Done | Turn Left | Turning Left | C8 |
94: | Turning Left | Step Done | Forward | Forward | B3, B4, C8 |
95: 
96: - **C4 applied:** obstacles do not disappear, so while the RVC is stopped the front stays blocked. Sides Blocked at the end of a stop therefore means front, left, and right are blocked (B4).
97: - **C9 applied (2026-11-16):** at the end of a backward step only the Side Situation decides. The front is not consulted, because moving backward takes the RVC away from the obstacle and the front sensor may read clear.
98: - **Durations:** stop, backward, and turn each last 5 ticks (C7, C6, C8). Turning is split into two states so that the same turn direction is issued for all 5 ticks.
99: 
100: ## Balancing with Process 3.2
101: 
102: | Process 3.2 Flow | Direction | Category | Level 3 Process | Balanced |
103: |---|---|---|---|---|
104: | Obstacle Situation | Input | Data | 3.2.1 | Yes |
105: | Tick | Input | Control | 3.2.2, 3.2.4 | Yes (same event to both) |
106: | Direction | Output | Data | 3.2.3 | Yes |
107: | Movement Status | Output | Data | 3.2.3 | Yes |
108: 
109: Internal items added: `Situation Signal`, `Movement Command`, `Start Step Timer`, `Step Done` (control), `Step Ticks Elapsed` (data), Data Store D4.
110: 
111: ## Overall Balancing with Level 0
112: 
113: | Level 0 Flow | Level 1 | Level 2 | Level 3 |
114: |---|---|---|---|
115: | Front Sensor Input | 1 | 1 | 1 |
116: | Left Sensor Input | 1 | 1 | 1 |
117: | Right Sensor Input | 1 | 1 | 1 |
118: | Dust Sensor Input | 2 | 2 | 2 |
119: | Tick | 3, 4 | 3.1, 3.2, 4.1 | 3.1, 3.2.2, 3.2.4, 4.1 |
120: | Direction | 3 | 3.2 | 3.2.3 |
121: | Clean | 4 | 4.2 | 4.2 |
122: 
123: No external flow was added or removed.
124: 
125: ## Execution Order Within One Tick
126: 
127: 1. 3.1 reads D1 and produces Obstacle Situation; 3.2.1 converts it to Situation Signal.
128: 2. 3.2.4 advances D4 and, if 5 ticks have elapsed, emits Step Done.
129: 3. 3.2.2 takes its transition and issues Movement Command (and Start Step Timer when a step begins).
130: 4. 3.2.3 produces Direction and Movement Status.
131: 5. 4.1, then 4.2, use Movement Status to produce Clean.
132: 
133: ## Open Issues Affecting Level 3 and Level 4
134: 
135: | ID | Affects | Status |
136: |---|---|---|
137: | Q1 → C5 | 3.2.2 | Resolved: turn right after backing; back again if left and right are still blocked. |
138: | Q2 → C6 | 3.2.2, 3.2.4 | Resolved: backward lasts 5 ticks. |
139: | Q3 → C7 | 3.2.2, 3.2.4 | Resolved: stop lasts 5 ticks. |
140: | C5 edge | 3.2.2 | Resolved: after backing, Left Open turns left (C5 updated). |
141: | C8 | 3.2.2, 3.2.4 | Resolved: a turn lasts 5 ticks. |
142: | Q4 → C10, Q5 → C11 | 4.1 | Resolved: dust during a power-up restarts the 5 ticks; the remaining count is kept while avoiding. |
143: | C9 | 3.1, 3.2.2 | Resolved: Obstacle Situation carries Front Blocked and Side Situation; after backing the sides decide. |
144: | Q6 | 3.1 | Assumption unchanged: left/right ignored while the front is clear. |

# FILE: artifacts/SA/DFD/dfd_level_4_fsm.md
1: # DFD Level 4: Movement Controller FSM
2: 
3: System: RVC Controller
4: Controller: Process 3.2.2 Movement Controller, `artifacts/SA/DFD/dfd_level_3.md`
5: Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C11, Q6)
6: 
7: ## Controller Inputs and Outputs
8: 
9: | Item | Kind | Source / Destination | Values |
10: |---|---|---|---|
11: | Tick | Event | Digital Clock | — |
12: | Situation Signal | Condition | 3.2.1 | Front Blocked (yes or no) and Side Situation (Right Open, Left Open, Sides Blocked) |
13: | Step Done | Condition | 3.2.4 | Present when the current stop, backward, or turn step has lasted 5 ticks |
14: | Movement Command | Action | 3.2.3 | Forward, Stop, Turn Right, Turn Left, Backward |
15: | Start Step Timer | Action | 3.2.4 | — |
16: 
17: Abbreviations in labels: `FrontBlocked` is the front part of the Situation Signal; `RightOpen`, `LeftOpen`, `SidesBlocked` are its Side Situation; `Done` is Step Done; `StartTimer` is Start Step Timer.
18: 
19: Revised 2026-11-16 for C9: the conditions of T1 and T2 use the front only, and the conditions of T4-T6 and T8-T10 use the sides only.
20: 
21: ## FSM
22: 
23: ```mermaid
24: stateDiagram-v2
25:     [*] --> Forward : Power On / Forward
26: 
27:     Forward --> Forward : Tick [not FrontBlocked] / Forward
28:     Forward --> Stopping : Tick [FrontBlocked] / Stop, StartTimer
29: 
30:     Stopping --> Stopping : Tick [not Done] / Stop
31:     Stopping --> TurningRight : Tick [Done and RightOpen] / Turn Right, StartTimer
32:     Stopping --> TurningLeft : Tick [Done and LeftOpen] / Turn Left, StartTimer
33:     Stopping --> Backing : Tick [Done and SidesBlocked] / Backward, StartTimer
34: 
35:     Backing --> Backing : Tick [not Done] / Backward
36:     Backing --> Backing : Tick [Done and SidesBlocked] / Backward, StartTimer
37:     Backing --> TurningRight : Tick [Done and RightOpen] / Turn Right, StartTimer
38:     Backing --> TurningLeft : Tick [Done and LeftOpen] / Turn Left, StartTimer
39: 
40:     TurningRight --> TurningRight : Tick [not Done] / Turn Right
41:     TurningRight --> Forward : Tick [Done] / Forward
42: 
43:     TurningLeft --> TurningLeft : Tick [not Done] / Turn Left
44:     TurningLeft --> Forward : Tick [Done] / Forward
45: ```
46: 
47: ## States
48: 
49: | State | Meaning | Movement Command while in state | Movement Status (via 3.2.3) |
50: |---|---|---|---|
51: | Forward | Moving forward with cleaning. Initial state. | Forward | Forward |
52: | Stopping | Stopped in front of an obstacle for 5 ticks. | Stop | Avoiding |
53: | Backing | Moving backward for 5 ticks because front, left, and right are blocked. | Backward | Avoiding |
54: | TurningRight | Turning right for 5 ticks. | Turn Right | Avoiding |
55: | TurningLeft | Turning left for 5 ticks. | Turn Left | Avoiding |
56: 
57: Turning is split into two states because the Controller must keep issuing the same turn direction for 5 ticks.
58: 
59: ## Transition Table
60: 
61: | # | Current State | Event | Condition | Action | Next State | Source |
62: |---|---|---|---|---|---|---|
63: | T0 | [*] | Power On | — | Forward | Forward | B1, B2 |
64: | T1 | Forward | Tick | not Front Blocked | Forward | Forward | B2 |
65: | T2 | Forward | Tick | Front Blocked | Stop, Start Step Timer | Stopping | B3, C2, C7 |
66: | T3 | Stopping | Tick | not Step Done | Stop | Stopping | C7 |
67: | T4 | Stopping | Tick | Step Done and Right Open | Turn Right, Start Step Timer | TurningRight | B3, C1, C8 |
68: | T5 | Stopping | Tick | Step Done and Left Open | Turn Left, Start Step Timer | TurningLeft | B3, C8 |
69: | T6 | Stopping | Tick | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | B4, C6 |
70: | T7 | Backing | Tick | not Step Done | Backward | Backing | C6 |
71: | T8 | Backing | Tick | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | C5, C6, C9 |
72: | T9 | Backing | Tick | Step Done and Right Open | Turn Right, Start Step Timer | TurningRight | C5, C8, C9 |
73: | T10 | Backing | Tick | Step Done and Left Open | Turn Left, Start Step Timer | TurningLeft | C5, C8, C9 |
74: | T11 | TurningRight | Tick | not Step Done | Turn Right | TurningRight | C8 |
75: | T12 | TurningRight | Tick | Step Done | Forward | Forward | B3, B4, C8 |
76: | T13 | TurningLeft | Tick | not Step Done | Turn Left | TurningLeft | C8 |
77: | T14 | TurningLeft | Tick | Step Done | Forward | Forward | B3, B4, C8 |
78: 
79: ## Timing Example
80: 
81: Obstacle ahead with the right clear, first detected at tick t:
82: 
83: | Tick | State before | Condition | Command | State after |
84: |---|---|---|---|---|
85: | t | Forward | FrontBlocked | Stop (timer starts) | Stopping |
86: | t+1 to t+4 | Stopping | not Done | Stop | Stopping |
87: | t+5 | Stopping | Done, RightOpen | Turn Right (timer starts) | TurningRight |
88: | t+6 to t+9 | TurningRight | not Done | Turn Right | TurningRight |
89: | t+10 | TurningRight | Done | Forward | Forward |
90: 
91: Stop covers ticks t to t+4 and the turn covers t+5 to t+9, 5 ticks each (C7, C8). Backing works the same way: 5 Backward ticks, then the decision on the next tick (C6).
92: 
93: ## Validation
94: 
95: | Check | Result |
96: |---|---|
97: | All states defined | Yes: Forward, Stopping, Backing, TurningRight, TurningLeft. |
98: | Initial state | Forward. |
99: | Valid source and target for every transition | Yes: T0-T14. |
100: | Input events from DFD | Tick (Digital Clock), Situation Signal (3.2.1), Step Done (3.2.4), all in Level 3. |
101: | Output actions match Controller outputs | Movement Command values and Start Step Timer, both Level 3 outputs of 3.2.2. |
102: | Conflicting conditions | None. Forward splits on Front Blocked. Stopping and Backing split first on Step Done, then on the Side Situation (Right Open, Left Open, Sides Blocked are mutually exclusive). Turning states split on Step Done only. |
103: | Priority | Step Done is checked first. The Side Situation matters only on the tick Step Done is present. Right Open takes priority over Left Open by its definition in 3.1 (C1). |
104: | Missing conditions | None. In every state the conditions cover all inputs. In Stopping the front is still blocked (C4), so Sides Blocked there means front, left, and right are blocked (B4). In Backing the front is not consulted (C9). |
105: | Unreachable states | None. Stopping via T2; Backing via T6; TurningRight via T4, T9; TurningLeft via T5, T10. |
106: | States without an outgoing transition | None. |
107: | Cycle check | Backing can repeat (T8) while all directions stay blocked. The requirements set no limit on repeats. |
108: 
109: ## Notes
110: 
111: - The Situation Signal is ignored during a turn. By C4 the obstacles do not move, and the requirements do not describe interrupting a turn.
112: - Q4 and Q5 (power-up) affect Process 4.1 only, not this FSM.
113: - The FSM has no Process Specification, per AGENTS.md. Process 3.2.2's specification refers to it.

# FILE: artifacts/SA/event_list.md
1: # Event List
2: 
3: System: RVC Controller
4: Sources: `docs/preliminary_requirements.md` (cited as B1-B7, by bullet order), `docs/requirements_clarifications.md` (cited as C1-C3)
5: 
6: ## Events
7: 
8: | Input/Output Event | Description |
9: |---|---|
10: | Front Sensor Input | Input. Reports whether an obstacle is detected in front of the RVC. |
11: | Left Sensor Input | Input. Reports whether an obstacle is detected on the left side of the RVC. |
12: | Right Sensor Input | Input. Reports whether an obstacle is detected on the right side of the RVC. |
13: | Dust Sensor Input | Input. Reports whether dust is detected on the surface being cleaned. |
14: | Tick | Input. Clock event that provides the time base for the system; powered-up cleaning lasts 5 ticks. |
15: | Direction | Output. Sends a movement command to the motor: forward, backward, turn left, turn right, or stop. |
16: | Clean | Output. Sends a cleaning command to the cleaner: start cleaning, stop cleaning, or power up cleaning. |
17: 
18: ## Traceability
19: 
20: | Input/Output Event | Requirement | Supporting behavior |
21: |---|---|---|
22: | Front Sensor Input | B3, B4 | An obstacle ahead triggers stopping and turning; it is also part of the front/left/right blocked case. |
23: | Left Sensor Input | B3, B4, C1 | A left obstacle limits the turn direction; it is also part of the front/left/right blocked case. |
24: | Right Sensor Input | B3, B4, C1 | A right obstacle limits the turn direction; it is also part of the front/left/right blocked case. |
25: | Dust Sensor Input | B5 | Detected dust triggers powered-up cleaning. |
26: | Tick | B5, C3 | Measures the 5-tick duration of powered-up cleaning. |
27: | Direction | B2, B3, B4, C1, C2 | Go forward, stop at an obstacle, turn left or right, and move backward. |
28: | Clean | B1, B2, B3, B5, C3 | Clean while going forward, stop cleaning at an obstacle, resume, and power up on dust for 5 ticks. |
29: 
30: ## Event Classification
31: 
32: - Flow-oriented: all four sensor inputs and both outputs.
33: - Temporal: `Tick`, which is drawn as a control flow in the DFDs.
34: - Control: none other than `Tick`. `Direction` and `Clean` carry commands as data flows.

# FILE: artifacts/SA/process_specification.md
1: # Process Specification
2: 
3: Current coverage: DFD Levels 0-3.
4: 
5: Requirement references: B1-B7 are bullets of `docs/preliminary_requirements.md`, by order. C1-C11 and Q1-Q6 are entries of `docs/requirements_clarifications.md`. Q1-Q3 were resolved by C5-C7 on 2026-11-08; earlier levels keep their Q references and note the resolution.
6: 
7: # DFD Level 0
8: 
9: ## Process 0: RVC Controller
10: 
11: ### Process Identification
12: 
13: | Field | Description |
14: |---|---|
15: | Process ID | 0 |
16: | Process Name | RVC Controller |
17: | DFD Level | Level 0 |
18: | Parent Process | None |
19: 
20: ### Purpose
21: Control the movement and cleaning of the RVC automatically, using obstacle and dust detection.
22: 
23: ### Inputs
24: - Front Sensor Input
25: - Left Sensor Input
26: - Right Sensor Input
27: - Dust Sensor Input
28: - Tick (control)
29: 
30: ### Outputs
31: - Direction
32: - Clean
33: 
34: ### Trigger / Execution Condition
35: - Executes on every Tick.
36: 
37: ### Processing Logic
38: 1. Without a front obstacle, go forward while cleaning.
39: 2. With a front obstacle, stop cleaning and stop moving.
40: 3. If the right is clear, turn right. If only the left is clear, turn left.
41: 4. If front, left, and right are all blocked, move backward and then turn aside.
42: 5. After turning aside, go forward with cleaning.
43: 6. If dust is detected, power up the cleaning for 5 ticks, then return to normal cleaning.
44: 
45: The stop, backward, and turn steps span several ticks. Their sequencing is refined at lower DFD levels and in the Controller FSM. Q1-Q6 remain open and limit that refinement.
46: 
47: ### Pseudocode
48: 
49: ```text
50: ON Tick:
51:     IF Front Sensor Input == TRUE THEN
52:         Clean = Stop
53:         Direction = Stop
54:         IF Left Sensor Input == TRUE AND Right Sensor Input == TRUE THEN
55:             Direction = Backward
56:             turn aside after moving backward          (Q1)
57:         ELSE IF Right Sensor Input == FALSE THEN
58:             Direction = Turn Right
59:         ELSE
60:             Direction = Turn Left
61:         END IF
62:     ELSE
63:         Direction = Forward
64:         IF Dust Sensor Input == TRUE THEN
65:             Clean = Power Up for 5 ticks              (Q4, Q5)
66:         ELSE
67:             Clean = Start, unless powering up
68:         END IF
69:     END IF
70: ```
71: 
72: ### Relevant Requirements
73: - B1, B2, B3, B4, B5, B7
74: - C1, C2, C3
75: 
76: # DFD Level 1
77: 
78: ## Process 1: Detect Obstacle
79: 
80: ### Process Identification
81: 
82: | Field | Description |
83: |---|---|
84: | Process ID | 1 |
85: | Process Name | Detect Obstacle |
86: | DFD Level | Level 1 |
87: | Parent Process | 0 |
88: 
89: ### Purpose
90: Interpret the three obstacle sensors and record where obstacles are.
91: 
92: ### Inputs
93: - Front Sensor Input
94: - Left Sensor Input
95: - Right Sensor Input
96: 
97: ### Outputs
98: - Obstacle Location (to D1 Obstacle Location)
99: 
100: ### Trigger / Execution Condition
101: - When any obstacle sensor input is received.
102: 
103: ### Processing Logic
104: 1. Read the three sensor inputs.
105: 2. Store each value as the matching field of Obstacle Location in D1.
106: 
107: ### Pseudocode
108: 
109: ```text
110: ON Front/Left/Right Sensor Input:
111:     Obstacle Location.Front Obstacle = Front Sensor Input
112:     Obstacle Location.Left Obstacle  = Left Sensor Input
113:     Obstacle Location.Right Obstacle = Right Sensor Input
114:     WRITE Obstacle Location TO D1
115: ```
116: 
117: ### Relevant Requirements
118: - B3, B4, C1
119: 
120: ## Process 2: Detect Dust
121: 
122: ### Process Identification
123: 
124: | Field | Description |
125: |---|---|
126: | Process ID | 2 |
127: | Process Name | Detect Dust |
128: | DFD Level | Level 1 |
129: | Parent Process | 0 |
130: 
131: ### Purpose
132: Interpret the dust sensor and record whether dust is present.
133: 
134: ### Inputs
135: - Dust Sensor Input
136: 
137: ### Outputs
138: - Dust Existence (to D2 Dust Existence)
139: 
140: ### Trigger / Execution Condition
141: - When the dust sensor input is received.
142: 
143: ### Processing Logic
144: 1. Read the dust sensor input.
145: 2. Store it as Dust Existence in D2.
146: 
147: ### Pseudocode
148: 
149: ```text
150: ON Dust Sensor Input:
151:     Dust Existence.Dust Detected = Dust Sensor Input
152:     WRITE Dust Existence TO D2
153: ```
154: 
155: ### Relevant Requirements
156: - B5
157: 
158: ## Process 3: Control Movement
159: 
160: ### Process Identification
161: 
162: | Field | Description |
163: |---|---|
164: | Process ID | 3 |
165: | Process Name | Control Movement |
166: | DFD Level | Level 1 |
167: | Parent Process | 0 |
168: 
169: ### Purpose
170: Decide the movement of the RVC from the obstacle locations, and tell Process 4 whether the RVC is moving forward or avoiding an obstacle.
171: 
172: ### Inputs
173: - Obstacle Location (from D1 Obstacle Location)
174: - Tick (control)
175: 
176: ### Outputs
177: - Direction (to Motor)
178: - Movement Status (to Process 4)
179: 
180: ### Trigger / Execution Condition
181: - Executes on every Tick.
182: 
183: ### Processing Logic
184: 1. Read Obstacle Location from D1.
185: 2. If there is no front obstacle, go forward and report Forward.
186: 3. If there is a front obstacle, stop (C2) and report Avoiding.
187: 4. Then, if the right is clear, turn right (C1). If only the left is clear, turn left.
188: 5. If front, left, and right are all blocked, move backward, then turn aside (B4).
189: 6. After turning aside, go forward and report Forward (B3).
190: 
191: Left and right obstacles are used only when there is a front obstacle (Q6 assumption). Steps 3-6 span several ticks; their sequencing and durations are refined at lower levels and limited by Q1-Q3.
192: 
193: ### Pseudocode
194: 
195: ```text
196: ON Tick:
197:     READ Obstacle Location FROM D1
198:     IF Front Obstacle == FALSE THEN
199:         Direction = Forward
200:         Movement Status = Forward
201:     ELSE
202:         Movement Status = Avoiding
203:         Direction = Stop                               (C2, Q3)
204:         IF Right Obstacle == FALSE THEN
205:             Direction = Turn Right                     (C1)
206:         ELSE IF Left Obstacle == FALSE THEN
207:             Direction = Turn Left
208:         ELSE
209:             Direction = Backward                       (B4, Q2)
210:             turn aside after moving backward           (Q1)
211:         END IF
212:     END IF
213: ```
214: 
215: ### Relevant Requirements
216: - B2, B3, B4, C1, C2
217: - Resolved later: Q1 (C5), Q2 (C6), Q3 (C7). Open: Q6 (assumed)
218: 
219: ## Process 4: Control Cleaning
220: 
221: ### Process Identification
222: 
223: | Field | Description |
224: |---|---|
225: | Process ID | 4 |
226: | Process Name | Control Cleaning |
227: | DFD Level | Level 1 |
228: | Parent Process | 0 |
229: 
230: ### Purpose
231: Decide the cleaning command from the movement status and dust existence, including the 5-tick power-up.
232: 
233: ### Inputs
234: - Movement Status (from Process 3)
235: - Dust Existence (from D2 Dust Existence)
236: - Tick (control)
237: 
238: ### Outputs
239: - Clean (to Cleaner)
240: 
241: ### Trigger / Execution Condition
242: - Executes on every Tick.
243: 
244: ### Processing Logic
245: 1. If Movement Status is Avoiding, stop cleaning (B3).
246: 2. If Movement Status is Forward, clean (B2). This also resumes cleaning after avoidance (B3).
247: 3. While moving forward, if dust is detected, power up the cleaning for 5 ticks (B5, C3).
248: 4. Count Ticks during power-up. After 5 ticks, return to normal cleaning.
249: 
250: ### Pseudocode
251: 
252: ```text
253: ON Tick:
254:     READ Dust Existence FROM D2
255:     IF Movement Status == Avoiding THEN
256:         Clean = Stop                                   (B3; power-up count: Q5)
257:     ELSE
258:         IF Dust Detected == TRUE THEN
259:             start power-up of 5 ticks                  (C3; re-detection: Q4)
260:         END IF
261:         IF power-up active THEN
262:             Clean = Power Up
263:             decrease remaining power-up ticks
264:         ELSE
265:             Clean = Start
266:         END IF
267:     END IF
268: ```
269: 
270: ### Relevant Requirements
271: - B1, B2, B3, B5, C3
272: - Open: Q4, Q5
273: 
274: # DFD Level 2
275: 
276: Processes 1 (Detect Obstacle) and 2 (Detect Dust) are functional primitives and are not decomposed. Their Level 1 specifications remain in force. Processes 3 and 4 are decomposed below.
277: 
278: ## Process 3.1: Assess Obstacle Situation
279: 
280: ### Process Identification
281: 
282: | Field | Description |
283: |---|---|
284: | Process ID | 3.1 |
285: | Process Name | Assess Obstacle Situation |
286: | DFD Level | Level 2 |
287: | Parent Process | 3 |
288: 
289: ### Purpose
290: Classify the current obstacles into one Obstacle Situation.
291: 
292: ### Inputs
293: - Obstacle Location (from D1 Obstacle Location)
294: - Tick (control)
295: 
296: ### Outputs
297: - Obstacle Situation (to Process 3.2)
298: 
299: ### Trigger / Execution Condition
300: - Executes on every Tick.
301: 
302: ### Processing Logic
303: Revised 2026-11-16 for C9: the sides are classified whether or not the front is blocked.
304: 
305: 1. Read Obstacle Location from D1.
306: 2. Front Blocked is TRUE when the front sensor detects an obstacle.
307: 3. Side Situation is Right Open when the right is clear (C1: right has priority).
308: 4. Otherwise it is Left Open when the left is clear.
309: 5. Otherwise it is Sides Blocked.
310: 
311: With Front Blocked, Sides Blocked means front, left, and right are all blocked (B4).
312: 
313: ### Pseudocode
314: 
315: ```text
316: ON Tick:
317:     READ Obstacle Location FROM D1
318:     Obstacle Situation.Front Blocked = Front Obstacle
319:     IF Right Obstacle == FALSE THEN
320:         Obstacle Situation.Side Situation = Right Open        (C1)
321:     ELSE IF Left Obstacle == FALSE THEN
322:         Obstacle Situation.Side Situation = Left Open
323:     ELSE
324:         Obstacle Situation.Side Situation = Sides Blocked
325:     END IF
326: ```
327: 
328: ### Relevant Requirements
329: - B3, B4, C1, C9
330: - Assumption: Q6 (while going forward the Controller uses Front Blocked only)
331: 
332: ## Process 3.2: Decide Movement
333: 
334: ### Process Identification
335: 
336: | Field | Description |
337: |---|---|
338: | Process ID | 3.2 |
339: | Process Name | Decide Movement |
340: | DFD Level | Level 2 |
341: | Parent Process | 3 |
342: 
343: ### Purpose
344: Sequence the movement over ticks from the Obstacle Situation and send the Direction to the Motor. Report whether the RVC is moving forward or avoiding.
345: 
346: ### Inputs
347: - Obstacle Situation (from Process 3.1)
348: - Tick (control)
349: 
350: ### Outputs
351: - Direction (to Motor)
352: - Movement Status (to Process 4)
353: 
354: ### Trigger / Execution Condition
355: - Executes on every Tick, after 3.1.
356: 
357: ### Processing Logic
358: 1. While moving forward with situation Clear, keep going forward and report Forward (B2).
359: 2. When the situation becomes non-Clear while moving forward, stop first and report Avoiding (B3, C2).
360: 3. After stopping: if Right Open, turn right (C1); if Left Open, turn left; if All Blocked, move backward (B4).
361: 4. After moving backward, turn aside (B4; direction and blocked-again case: Q1).
362: 5. After turning, go forward and report Forward (B3, B4).
363: 
364: The current avoidance step (Forward, Stopping, Turning, Backing) persists across ticks. Its durations are open (Q2, Q3). Obstacles do not disappear (C4), so the situation that caused the stop stays non-Clear until the turn. Level 3 separates this sequencing into the Controller.
365: 
366: ### Pseudocode
367: 
368: ```text
369: ON Tick:
370:     CASE current step OF
371:     Forward:
372:         IF Obstacle Situation == Clear THEN
373:             Direction = Forward;  Movement Status = Forward
374:         ELSE
375:             Direction = Stop;     Movement Status = Avoiding;  step = Stopping   (C2)
376:         END IF
377:     Stopping:                                          (duration: Q3)
378:         Movement Status = Avoiding
379:         IF Obstacle Situation == Right Open THEN  Direction = Turn Right; step = Turning   (C1)
380:         ELSE IF Obstacle Situation == Left Open THEN  Direction = Turn Left; step = Turning
381:         ELSE  Direction = Backward; step = Backing    (All Blocked; B4)
382:         (Clear is not possible here: obstacles do not disappear, C4)
383:     Backing:                                           (duration: Q2)
384:         Movement Status = Avoiding
385:         Direction = Turn Left or Turn Right; step = Turning                  (Q1)
386:     Turning:
387:         Direction = Forward;  Movement Status = Forward;  step = Forward     (B3)
388:     END CASE
389: ```
390: 
391: ### Refinement (2026-11-08)
392: Q1-Q3 are resolved: Stopping, Backing, and Turning each last 5 ticks (C7, C6, C8). After Backing, the RVC turns right if the right is clear, turns left if only the left is clear, or backs again if left and right are still both blocked (C5). Process 3.2.2 and the Level 4 FSM carry the exact sequencing.
393: 
394: ### Relevant Requirements
395: - B2, B3, B4, C1, C2, C4
396: - Resolved: Q1 (C5), Q2 (C6), Q3 (C7)
397: 
398: ## Process 4.1: Track Power-Up
399: 
400: ### Process Identification
401: 
402: | Field | Description |
403: |---|---|
404: | Process ID | 4.1 |
405: | Process Name | Track Power-Up |
406: | DFD Level | Level 2 |
407: | Parent Process | 4 |
408: 
409: ### Purpose
410: Run the 5-tick powered-up cleaning period started by dust detection.
411: 
412: ### Inputs
413: - Dust Existence (from D2 Dust Existence)
414: - Movement Status (from Process 3.2)
415: - Remaining Power-Up Ticks (from D3 Power-Up Timer)
416: - Tick (control)
417: 
418: ### Outputs
419: - Power-Up Active (to Process 4.2)
420: - Remaining Power-Up Ticks (to D3 Power-Up Timer)
421: 
422: ### Trigger / Execution Condition
423: - Executes on every Tick, after Movement Status for the tick is available.
424: 
425: ### Processing Logic
426: Revised 2026-11-16 for C10 and C11.
427: 
428: 1. Read Dust Existence from D2 and Remaining Power-Up Ticks from D3.
429: 2. If moving forward and dust is detected, set the count to 5 (B5, C3). This also restarts a power-up that is already running (C10).
430: 3. If moving forward and the count is above 0, report Power-Up Active and count down by 1.
431: 4. Otherwise report Power-Up Active = FALSE. While avoiding, the count is kept (C11).
432: 5. Write the count back to D3.
433: 
434: A power-up starting on tick t runs on ticks t to t+4, which is 5 ticks.
435: 
436: ### Pseudocode
437: 
438: ```text
439: ON Tick:
440:     READ Dust Existence FROM D2
441:     READ Remaining Power-Up Ticks FROM D3
442:     IF Movement Status == Forward THEN
443:         IF Dust Detected == TRUE THEN
444:             Remaining Power-Up Ticks = 5               (C3, C10)
445:         END IF
446:         IF Remaining Power-Up Ticks > 0 THEN
447:             Power-Up Active = TRUE
448:             Remaining Power-Up Ticks = Remaining Power-Up Ticks - 1
449:         ELSE
450:             Power-Up Active = FALSE
451:         END IF
452:     ELSE
453:         Power-Up Active = FALSE                        (count kept, C11)
454:     END IF
455:     WRITE Remaining Power-Up Ticks TO D3
456: ```
457: 
458: ### Relevant Requirements
459: - B5, C3, C10, C11
460: 
461: ## Process 4.2: Decide Cleaning
462: 
463: ### Process Identification
464: 
465: | Field | Description |
466: |---|---|
467: | Process ID | 4.2 |
468: | Process Name | Decide Cleaning |
469: | DFD Level | Level 2 |
470: | Parent Process | 4 |
471: 
472: ### Purpose
473: Choose the cleaning command for the current tick.
474: 
475: ### Inputs
476: - Movement Status (from Process 3.2)
477: - Power-Up Active (from Process 4.1)
478: 
479: ### Outputs
480: - Clean (to Cleaner)
481: 
482: ### Trigger / Execution Condition
483: - When Power-Up Active for the tick arrives from 4.1.
484: 
485: ### Processing Logic
486: 1. While avoiding, stop cleaning (B3).
487: 2. While moving forward with power-up active, power up the cleaning (B5).
488: 3. While moving forward otherwise, clean normally (B1, B2). This also resumes cleaning after avoidance (B3).
489: 
490: ### Pseudocode
491: 
492: ```text
493: ON Power-Up Active:
494:     IF Movement Status == Avoiding THEN
495:         Clean = Stop
496:     ELSE IF Power-Up Active == TRUE THEN
497:         Clean = Power Up
498:     ELSE
499:         Clean = Start
500:     END IF
501: ```
502: 
503: ### Relevant Requirements
504: - B1, B2, B3, B5
505: 
506: # DFD Level 3
507: 
508: Only Process 3.2 (Decide Movement) is decomposed. Processes 1, 2, 3.1, 4.1, and 4.2 are functional primitives; their earlier specifications remain in force.
509: 
510: ## Process 3.2.1: Signal Obstacle Situation
511: 
512: ### Process Identification
513: 
514: | Field | Description |
515: |---|---|
516: | Process ID | 3.2.1 |
517: | Process Name | Signal Obstacle Situation |
518: | DFD Level | Level 3 |
519: | Parent Process | 3.2 |
520: | Process Type | Data |
521: 
522: ### Purpose
523: Deliver the Obstacle Situation to the Movement Controller as a control signal.
524: 
525: ### Inputs
526: - Obstacle Situation (from Process 3.1)
527: 
528: ### Outputs
529: - Situation Signal (control, to Process 3.2.2)
530: 
531: ### Trigger / Execution Condition
532: - When Obstacle Situation arrives from 3.1 (once per Tick).
533: 
534: ### Processing Logic
535: 1. Receive the Obstacle Situation.
536: 2. Emit the Situation Signal with the same value.
537: 
538: ### Pseudocode
539: 
540: ```text
541: ON Obstacle Situation:
542:     Situation Signal = Obstacle Situation     (Clear | Right Open | Left Open | All Blocked)
543: ```
544: 
545: ### Relevant Requirements
546: - B3, B4, C1
547: 
548: ## Process 3.2.2: Movement Controller
549: 
550: ### Process Identification
551: 
552: | Field | Description |
553: |---|---|
554: | Process ID | 3.2.2 |
555: | Process Name | Movement Controller |
556: | DFD Level | Level 3 |
557: | Parent Process | 3.2 |
558: | Process Type | Control |
559: 
560: ### Purpose
561: Sequence the RVC movement over ticks: go forward, stop at an obstacle for 5 ticks, move backward for 5 ticks when needed, turn for 5 ticks, and resume forward.
562: 
563: ### Inputs
564: - Tick (control)
565: - Situation Signal (control, from Process 3.2.1)
566: - Step Done (control, from Process 3.2.4)
567: 
568: ### Outputs
569: - Movement Command (control, to Process 3.2.3)
570: - Start Step Timer (control, to Process 3.2.4)
571: 
572: ### Trigger / Execution Condition
573: - Executes on every Tick, after Situation Signal and Step Done for the tick are available.
574: 
575: ### Processing Logic
576: The Controller has five states: Forward (initial), Stopping, Backing, Turning Right, Turning Left. On each Tick it takes one transition and issues one Movement Command.
577: 
578: | Current State | Tick condition | Actions | Next State | Source |
579: |---|---|---|---|---|
580: | Forward | not Front Blocked | Forward | Forward | B2 |
581: | Forward | Front Blocked | Stop, Start Step Timer | Stopping | B3, C2, C7 |
582: | Stopping | not Step Done | Stop | Stopping | C7 |
583: | Stopping | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C1, C8 |
584: | Stopping | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | B3, C8 |
585: | Stopping | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | B4, C6 |
586: | Backing | not Step Done | Backward | Backing | C6 |
587: | Backing | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | C5, C6, C9 |
588: | Backing | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C5, C8 |
589: | Backing | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | C5, C8 |
590: | Turning Right | not Step Done | Turn Right | Turning Right | C8 |
591: | Turning Right | Step Done | Forward | Forward | B3, B4, C8 |
592: | Turning Left | not Step Done | Turn Left | Turning Left | C8 |
593: | Turning Left | Step Done | Forward | Forward | B3, B4, C8 |
594: 
595: When a stop or backward step ends, only the Side Situation decides (C9). The full state model, with transition IDs and validation, is the Level 4 FSM (`artifacts/SA/DFD/dfd_level_4_fsm.md`).
596: 
597: ### Relevant Requirements
598: - B2, B3, B4, C1, C2, C4, C5, C6, C7, C8, C9
599: 
600: ## Process 3.2.3: Issue Movement Output
601: 
602: ### Process Identification
603: 
604: | Field | Description |
605: |---|---|
606: | Process ID | 3.2.3 |
607: | Process Name | Issue Movement Output |
608: | DFD Level | Level 3 |
609: | Parent Process | 3.2 |
610: | Process Type | Data |
611: 
612: ### Purpose
613: Turn the Controller's Movement Command into the Direction for the Motor and the Movement Status for Process 4.
614: 
615: ### Inputs
616: - Movement Command (control, from Process 3.2.2)
617: 
618: ### Outputs
619: - Direction (to Motor)
620: - Movement Status (to Process 4)
621: 
622: ### Trigger / Execution Condition
623: - When a Movement Command arrives.
624: 
625: ### Processing Logic
626: 1. Send Direction with the same value as the Movement Command.
627: 2. Report Movement Status Forward when the command is Forward; otherwise Avoiding (B3: cleaning stops while avoiding).
628: 
629: ### Pseudocode
630: 
631: ```text
632: ON Movement Command:
633:     Direction = Movement Command
634:     IF Movement Command == Forward THEN
635:         Movement Status = Forward
636:     ELSE
637:         Movement Status = Avoiding
638:     END IF
639: ```
640: 
641: ### Relevant Requirements
642: - B2, B3, B4
643: 
644: ## Process 3.2.4: Time Movement Step
645: 
646: ### Process Identification
647: 
648: | Field | Description |
649: |---|---|
650: | Process ID | 3.2.4 |
651: | Process Name | Time Movement Step |
652: | DFD Level | Level 3 |
653: | Parent Process | 3.2 |
654: | Process Type | Data |
655: 
656: ### Purpose
657: Count the ticks of a stop, backward, or turn step and tell the Controller when 5 ticks have elapsed.
658: 
659: ### Inputs
660: - Start Step Timer (control, from Process 3.2.2)
661: - Tick (control)
662: - Step Ticks Elapsed (from D4 Step Timer)
663: 
664: ### Outputs
665: - Step Done (control, to Process 3.2.2)
666: - Step Ticks Elapsed (to D4 Step Timer)
667: 
668: ### Trigger / Execution Condition
669: - On every Tick, before 3.2.2 runs.
670: - On Start Step Timer, issued by 3.2.2 during a tick.
671: 
672: ### Processing Logic
673: 1. On Start Step Timer, set the count to 0. The tick on which the step starts is the first tick of the step.
674: 2. On each later Tick, if a step is running, add 1.
675: 3. When the count reaches 5, emit Step Done and set the timer to Idle.
676: 
677: A step started on tick t covers ticks t to t+4. Step Done arrives on tick t+5, when the Controller issues the next action.
678: 
679: ### Pseudocode
680: 
681: ```text
682: ON Start Step Timer:
683:     WRITE Step Ticks Elapsed = 0 TO D4
684: 
685: ON Tick:                                   (before 3.2.2)
686:     READ Step Ticks Elapsed FROM D4
687:     IF Step Ticks Elapsed != Idle THEN
688:         Step Ticks Elapsed = Step Ticks Elapsed + 1
689:         IF Step Ticks Elapsed == 5 THEN
690:             emit Step Done
691:             Step Ticks Elapsed = Idle
692:         END IF
693:         WRITE Step Ticks Elapsed TO D4
694:     END IF
695: ```
696: 
697: Initial value of D4: Idle.
698: 
699: ### Relevant Requirements
700: - C6, C7, C8