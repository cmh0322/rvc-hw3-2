# Event List

System: RVC Controller
Sources: `docs/preliminary_requirements.md` (cited as B1-B7, by bullet order), `docs/requirements_clarifications.md` (cited as C1-C3)

## Events

| Input/Output Event | Description |
|---|---|
| Front Sensor Input | Input. Reports whether an obstacle is detected in front of the RVC. |
| Left Sensor Input | Input. Reports whether an obstacle is detected on the left side of the RVC. |
| Right Sensor Input | Input. Reports whether an obstacle is detected on the right side of the RVC. |
| Dust Sensor Input | Input. Reports whether dust is detected on the surface being cleaned. |
| Tick | Input. Clock event that provides the time base for the system; powered-up cleaning lasts 5 ticks. |
| Direction | Output. Sends a movement command to the motor: forward, backward, turn left, turn right, or stop. |
| Clean | Output. Sends a cleaning command to the cleaner: start cleaning, stop cleaning, or power up cleaning. |

## Traceability

| Input/Output Event | Requirement | Supporting behavior |
|---|---|---|
| Front Sensor Input | B3, B4 | An obstacle ahead triggers stopping and turning; it is also part of the front/left/right blocked case. |
| Left Sensor Input | B3, B4, C1 | A left obstacle limits the turn direction; it is also part of the front/left/right blocked case. |
| Right Sensor Input | B3, B4, C1 | A right obstacle limits the turn direction; it is also part of the front/left/right blocked case. |
| Dust Sensor Input | B5 | Detected dust triggers powered-up cleaning. |
| Tick | B5, C3 | Measures the 5-tick duration of powered-up cleaning. |
| Direction | B2, B3, B4, C1, C2 | Go forward, stop at an obstacle, turn left or right, and move backward. |
| Clean | B1, B2, B3, B5, C3 | Clean while going forward, stop cleaning at an obstacle, resume, and power up on dust for 5 ticks. |

## Event Classification

- Flow-oriented: all four sensor inputs and both outputs.
- Temporal: `Tick`, which is drawn as a control flow in the DFDs.
- Control: none other than `Tick`. `Direction` and `Clean` carry commands as data flows.
