# Event List

System: RVC Controller
Sources: `docs/preliminary_requirements.md` (cited as B1-B7, by bullet order), `docs/requirements_clarifications.md` (cited as C1-C16)

## Events

| Input/Output Event | Description |
|---|---|
| Front Sensor Input | Input. Reports whether an obstacle is detected in front of the RVC. |
| Left Sensor Input | Input. Reports whether an obstacle is detected on the left side of the RVC. |
| Right Sensor Input | Input. Reports whether an obstacle is detected on the right side of the RVC. |
| Dust Sensor Input | Input. Reports whether dust is detected on the surface being cleaned; each TRUE input is remembered internally until a Forward Tick consumes it (C15). |
| Tick | Input. Clock event that provides the time base for the system; powered-up cleaning, stopping, backing and turning each use 5-tick durations. |
| Direction | Output. Sends a movement command to the motor: forward, backward, turn left, turn right, or stop. |
| Clean | Output. Sends a cleaning command to the cleaner: Start (suction and mopping), Stop (both off), or Power Up (stronger suction, normal mopping), per C14. |

## Traceability

| Input/Output Event | Requirement | Supporting behavior |
|---|---|---|
| Front Sensor Input | B3, B4 | An obstacle ahead triggers stopping and turning; it is also part of the front/left/right blocked case. |
| Left Sensor Input | B3, B4, C1 | A left obstacle limits the turn direction; it is also part of the front/left/right blocked case. |
| Right Sensor Input | B3, B4, C1 | A right obstacle limits the turn direction; it is also part of the front/left/right blocked case. |
| Dust Sensor Input | B5, C10, C15 | Dust triggers/restarts power-up; detections during avoidance are remembered until Forward resumes. |
| Tick | B5, C3, C6-C8, C12, C13 | Measures timed actions. First Tick occurs after all initial sensor samples; Power On emits no commands. |
| Direction | B2, B3, B4, C1, C2 | Go forward, stop at an obstacle, turn left or right, and move backward. |
| Clean | B1, B2, B3, B5, C3, C10, C11, C14, C15 | Suction and mopping run while Forward and stop while Avoiding; power-up strengthens suction only, including a remembered detection on resumption. |

## Event Classification

- Flow-oriented: all four sensor inputs and both outputs.
- Temporal: `Tick`, which is drawn as a control flow in the DFDs.
- Control: none other than `Tick`. `Direction` and `Clean` carry commands as data flows.

## Initialization contract

C12 requires all four initial sensor readings before the first Tick. C13 makes Power On an internal initialization condition, not an eighth external event or an output command. Internal pending-dust storage and its consumption do not add external flows.
