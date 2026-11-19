# Independent refutation: startup

Method: **Codex adapter using Trail of Bits criteria**, with the native Workflow runtime unavailable. This reviewer independently read the requirements, SA/SD, approval record and actual startup/cycle call chains. No source changes, builds or tests were performed. Candidate probe execution is not independently re-executed here.

The current SD revision is approved by `../../approval.md:3-7`. The SD's own earlier pending-approval statement does not override this subsequent owner approval.

## P5-01 — not refuted

**Verdict: contradicted (C13).** `docs/requirements_clarifications.md:21` prohibits Direction and Clean at Power On. FSM T0 (`artifacts/SA/DFD/dfd_level_4_fsm.md:63`) and `artifacts/SD/structure_chart.md:23` distinguish initializing Forward state from emitting a command.

The production path is `src/main.c:12` → `src/initialize_rvc.c:10-13` → `src/issue_movement_output.c:15-17` → `drive_motor`. `src/movement_controller.c:64-68` returns the Forward command after setting Forward and resetting D4. `issue_movement_output` maps it to `DIRECTION_FORWARD`. This output precedes the first `wait_for_tick` at `src/main.c:15`. Reset Step Timer and Reset Power-Up Timer merely assign private state (`src/step_timer.c:33-35`, `src/power_up_timer.c:34-36`); neither provides a sensor-dependent guard.

Refutation attempts: interpreting Forward as only internal state fails because the initializer actually invokes the output boundary. Treating Power On as the first Tick fails because Main waits only afterwards and C13 expressly separates the events. A later Stop does not erase the earlier command. The first actual Tick can correctly Stop for a blocked front; that is a satisfied later path, not a refutation.

Corrections: no initialization Clean output is present, so retain that satisfied subclaim. Report an unwanted abstract command, not an observed collision or physical movement. Returning no Movement Command from reset is also an approved interface obligation; simply leaving an unused Forward return would remove the output symptom but still miss that interface.

## P5-02 — not refuted, qualified

**Verdict: partial for C12; initial-acquisition/readiness sub-obligation absent.** C12 (`docs/requirements_clarifications.md:20`) says to read all four sensors before processing the first Tick. SA makes its intended boundary explicit: obtain samples **before** the first Tick (`artifacts/SA/process_specification.md:38,50-56`). The approved SD requires InitialSensors mode, readiness checks and no Tick delivery until acquisition completes (`artifacts/SD/structure_chart.md:17,23,192-198`).

The same startup path contains no sensor read or readiness step. After `wait_for_tick`, `src/controller.c:10-13` calls `get_inputs` before decisions/outputs. `src/get_inputs.c:11-14` obtains all four readings through `src/detect_obstacle.c:10-12` and `src/detect_dust.c:8`. Thus polling exists and C locals are populated before action selection, but acquisition occurs after the Tick has been delivered rather than in the specified initialization phase.

The strongest counterargument is C12's isolated phrase “before processing”: the Controller's input phase could count as a preparation phase before state transitions. That observation limits the finding and prevents an uninitialized-data accusation. It does not meet the current SA/approved SD's express pre-delivery initialization contract. In the simulator, `simulator/host/sim_host.c:91-102` reads the first four input values and increments Tick within `wait_for_tick`, then Controller samples them. Do not claim that the simulator feeds its static FALSE defaults into the first decision.

Absence search: `rg -n` across `src`, `include`, `CMakeLists.txt`, `simulator/host` for `inputs_ready|Inputs Ready|acquire_initial|Acquire Initial|initial.*sensor|sensor.*valid|reset_sensor|receive_input|INITIAL_SENSORS|InitialSensors|read_(front|left|right|dust)_sensor|initialize_rvc` found only the old initializer and polling boundary. Main, initializer, all reset/sensor callees, controller, get_inputs, hardware declarations, CMake source inclusion and simulator boundary were inspected. No alternative initial-acquisition/readiness path appeared.

Corrections: do not mark all C12 sensor reading absent. Four validity flags and event adapter names come from the approved SD, not C12 alone. Keep the finding about initial timing/readiness; later ordered-event loss belongs to P5-04. The recommendation to acquire actual initial samples before first Tick delivery is supported, but implementation and regression execution require the later authorized TDD step.
