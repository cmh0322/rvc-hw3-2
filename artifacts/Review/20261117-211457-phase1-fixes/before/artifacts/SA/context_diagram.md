# System Context Diagram

System: RVC Controller
Sources: `docs/preliminary_requirements.md`, `docs/requirements_clarifications.md`, `artifacts/SA/event_list.md`

## System Boundary

- Inside: the automatic cleaning control logic of the RVC Controller (B7).
- Outside: the sensors and digital clock that supply inputs, and the motor and cleaner that receive commands. Their hardware design and control are out of scope (B6).

## Diagram

```mermaid
flowchart LR
    FrontSensor["Front Sensor"]
    LeftSensor["Left Sensor"]
    RightSensor["Right Sensor"]
    DustSensor["Dust Sensor"]
    DigitalClock["Digital Clock"]
    System(("RVC Controller"))
    Motor["Motor"]
    Cleaner["Cleaner"]

    FrontSensor -->|Front Sensor Input| System
    LeftSensor -->|Left Sensor Input| System
    RightSensor -->|Right Sensor Input| System
    DustSensor -->|Dust Sensor Input| System
    DigitalClock -.->|Tick| System
    System -->|Direction| Motor
    System -->|Clean| Cleaner
```

Solid arrows are data flows. The dashed arrow is a control flow.
