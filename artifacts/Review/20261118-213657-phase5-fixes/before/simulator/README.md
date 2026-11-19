# Web-Based RVC Simulator Specification

## 1. Overview

An interactive simulator for system testing the implemented RVC Controller. It shows the RVC on an editable 10x10 map, runs the C controller one Tick at a time, and records the complete state at every Tick. The human evaluator judges the behavior; the simulator assigns no result.

## 2. How to run

Requirements: the project built with CMake (see the project README) and Node.js. No packages are installed.

```sh
cmake --build build --target rvc_sim_host    # the C controller for the simulator
node simulator/server.js                     # then open http://localhost:8765
```

Other commands:

```sh
node simulator/run_scenarios.js    # runs all scenarios without a browser, writes traces
node simulator/generate_docs.js    # regenerates the scenario and traceability documents
```

## 3. Execution architecture

```
Browser page                Node.js server            C process (rvc_sim_host)
map, display, history  <->  simulator/server.js  <->  main() + all production modules
simulator/public/           relays one line           + simulator/host/sim_host.c
                            per Tick                    (the hardware interface)
```

- **The controller is the real C code.** `rvc_sim_host` links the unchanged files of `src/`, including `main()`, with `simulator/host/sim_host.c`. That file implements the seven hardware interface functions of `include/hw_interface.h` and nothing else.
- **No control decision is made in JavaScript.** The page computes the sensor values from the map, sends them, and applies the returned outputs to the map.
- **The map is separate from the controller.** `simulator/public/world.js` holds the map rules; `app.js` holds display and controls.

| Required interface | Here |
|---|---|
| initialize(configuration) | `POST /api/reset`: starts a fresh C process. The map configuration stays in the page; the controller has no configuration. |
| step(sensor_inputs) | `POST /api/step` with `{front, left, right, dust}`: one Tick. |
| get_state() | Every reset and step returns the outputs and the internal state. |
| reset() | `POST /api/reset`: the old C process is ended and a new one started, so the state is the power-on state. |

Inside the C process, `wait_for_tick()` writes one JSON line with the state and then reads one line of sensor values. `main()` runs exactly as designed: `Initialize RVC`, then `Wait For Tick` and `Controller` for every Tick. The internal state is read through the read-only queries `get_controller_state`, `get_step_ticks_elapsed`, and `get_remaining_power_up_ticks`.

## 4. Map rules

These rules belong to the simulator. The requirements do not define the floor, so they are stated here.

| Topic | Rule |
|---|---|
| Grid | 10x10, x = 0..9 to the right, y = 0..9 downward. The boundary acts as a wall. |
| Default start | (4,4), heading N. The requirements give no direction; N is the simulator's choice. |
| Obstacle sensors | Each reads the adjacent cell in front, to the left, or to the right: blocked if it holds an obstacle or is outside the grid. |
| Dust sensor | Reads the cell the RVC is on. |
| Forward, Backward | One cell per Tick. If the target cell is blocked, the RVC stays and the event is recorded. |
| Turn Right, Turn Left | Five Turn ticks make one 90-degree turn (C8). The heading changes on the fifth tick. The marker shows the turn in progress. |
| Stop | No movement. |
| Clean Start, Power Up | The cell the RVC is on is marked as cleaned. |
| Dust removal | Dust is removed when Clean is Power Up on that cell. |
| Tick 0 | The state after power on. Direction is Forward (FSM T0); the map does not change until Tick 1. |

## 5. Tick execution

One simulation Tick is one call of `Controller` in the C program.

1. Read the map and the RVC position.
2. Determine the four sensor inputs.
3. Send them; the C program runs one control cycle.
4. Receive Direction, Clean, and the internal state.
5. Apply movement and cleaning to the map.
6. Record a snapshot.
7. Draw the new state.

The run stops at Tick 100.

## 6. Controls and editing

- **Start, Pause, Step, Reset, Restart, Speed** (1 to 20 ticks per second).
- **Step back** and the tick slider show saved snapshots. The C controller is not reversed.
- **Reset** restores the controller state, both timers, the RVC position and direction, and the initial map.
- **Map edit mode** (at Tick 0): place or remove obstacles and dust, set the RVC start and the initial direction, clear the map, return to the selected scenario, save as a new scenario, export and import a map file.
- **Validation:** the start must be inside the grid, an obstacle cannot be on the start cell, and dust cannot be on an obstacle. An invalid edit is refused with a message; the map is never changed silently.

## 7. State inspection and history

The State Inspector shows, for the tick on display and the tick before it: tick, position, heading and turn progress, previous and current controller state, the transition, the four sensor inputs, the Motor output, the Cleaner output, the step timer, the power-up ticks remaining, and the map events. Changed values are highlighted.

The History table has one row per tick from Tick 0. "Export trace" saves the configuration and all snapshots as a JSON file.

No value is invented: every controller value shown comes from the C process.

## 8. Test execution

- Choose a scenario, run it, inspect it, and record PASS, FAIL, or INCONCLUSIVE with the evaluator, related ticks, and observations.
- "Save evaluation and trace" stores the evaluation in the browser and writes it, with the full trace, to `simulator/results/`.
- "Export all evaluations" saves all recorded results as one file.
- The simulator has no automated assertions and never assigns a result.

## 9. Limitations

- The map rules of section 4 are choices of the simulator, not requirements. In particular, sensors see one cell, and one Tick moves one cell.
- The RVC has no rear sensor. A Backward command against a wall or obstacle does not move it; the event is recorded.
- Custom scenarios and evaluations are kept in the browser's local storage. Use export to keep them elsewhere.
- The server handles one simulation at a time and listens on localhost only.
