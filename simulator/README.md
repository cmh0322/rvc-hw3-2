# Current simulator boundary — 2026-11-18

Run `node simulator/server.js`, then open http://localhost:8765. The simulator executes production C via rvc_sim_host, compiled with GCC/C11.

`POST /api/reset` now requires actual initial `{front,left,right,dust}` Booleans. The page derives them from the configured initial map. C receives all four before reporting tick0; Direction/Clean are null at tick0. The inspector shows those actual initial readings.

`POST /api/event` accepts `{kind:"dust",value:true}` (front/left/right/dust) or `{kind:"tick"}`. Sensor-only delivery changes the store without moving, advancing timers or outputting commands. Every received sensor observation, including TRUE then FALSE between Ticks, is retained in pipe receipt order. Tick executes one Controller cycle. `POST /api/step` remains the map convenience API: four ordered sensor observations followed by Tick.

Node ControllerProcess.start(sensors) sends four actual initial observations. Its event(kind,value) method delivers individual observations/Tick. The C adapter uses `receive_input_event(InputMode)` and Drive Motor/Cleaner, replacing the previous seven polling APIs. EOF terminates only the simulator adapter. Physical capture and actuator implementation are out of scope.

Protocol: stdin lines `front 0`, `left 1`, `right 0`, `dust 1`, or `tick`; output is initial-ready JSON followed by one acknowledgement per running event. Sensor acknowledgements carry no Direction/Clean; Tick acknowledgements carry the cycle outputs. Separate read-only diagnostics include pending_dust. Queued pipe lines are not collapsed to a snapshot. The initial mode accepts sensors only.

The map still uses a fixed 10×10 floor, five ticks per quarter-turn, and at most 100 ticks per scenario. These are simulator choices, not additional production requirements. Start/Stop represent suction+mop; Power Up strengthens suction with normal mop by contract, but separate physical actuator intensity is not modeled.

Controls: Start/Pause/Step/Reset/Restart, history/back/slider, map editing and human evaluation remain available. Evaluation stays Pending until a human records a verdict. Automated tests do not populate the human evaluator form.

`node simulator/run_scenarios.js` records all 21 traces. Set RVC_SCENARIO_OUT to a separate output directory to preserve historical traces. `node simulator/generate_docs.js` refreshes scenario/traceability descriptions. Current correction evidence: artifacts/Review/20261118-213657-phase5-fixes/verification/.
