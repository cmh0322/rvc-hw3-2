# RVC Movement Controller model contract

This is a modeling checklist, not a completed model or proof. Re-read the source artifacts on every run; the descriptions below reflect their current interpretation and must not override changed requirements.

## State and Tick semantics

Use distinct states Forward, Stopping, Backing, TurningRight, TurningLeft. T0 sets Forward without emitting MovementCommand, Direction or Clean (C13); all four initial sensor samples precede the first Tick (C12). T1–T14 execute once per Tick. SituationSignal has a Boolean front component and three mutually exclusive side values: RightOpen (right clear, including both clear), LeftOpen (right blocked and left clear), SidesBlocked.

Each modeled Tick: sample the applicable inputs → advance D4 and obtain Done → select one FSM transition → restart D4 if the action requests it → issue MovementCommand. Explicitly define whether intermediate states are observable; assertions about whole Tick results must run after the atomic transition. Avoid accidental interleavings introduced by separate Promela processes when the approved design is a single synchronous cycle.

Current timing example: obstacle at t emits Stop and starts elapsed=0; t+1…t+4 remain stopped; t+5 chooses and starts the next five-tick step. Turning emits Forward at t+10 in the example. Distinguish Idle from elapsed 0, and record the reset order. Do not nondeterministically supply Done independently of D4 in a claim about five-tick duration.

## Environment

- State the abstraction: raw three-sensor combinations or already-classified SituationSignal. If classified, separately check the raw-to-side priority relation (C1).
- For controller robustness checks, nondeterministic signals over all legal values may be an over-approximation. Label it as such; a trace may not correspond to a realizable map.
- C4 does not freeze all sensor values across movement. If using the SA's stationary-front persistence while Stopping, cite Level 3 and explain it. Avoid imposing additional sensor stability merely to make a property pass.
- Q6 behavior is conditional on the current assumption. Validate correspondence but do not call it a confirmed requirement.
- C5/C9 allow repeated Backing while both sides are blocked; front may be clear. A cycle with enabled Tick transitions is not automatically a deadlock or defect.
- Liveness assumes continuing Ticks. Weak process fairness is not a guarantee that sensors eventually clear. Record any fairness flag and environment assumptions explicitly.

## Checks to derive from current sources

| Check | Basis | Scope |
|---|---|---|
| Initial Forward without output | T0, C12/C13 | Initialize state only; first Tick samples/evaluates the initialized inputs and produces both Direction and Clean. Do not inherit a historical SD power-on output as the new requirement. |
| Complete and non-overlapping guards | T1–T14 and legal input domain | Every state/Done/side combination, with timer-consistent reachable states |
| Stop before avoiding and exact step durations | C2/C6/C7/C8, timing table | D4 ordering, boundary tick and restart behavior |
| Right priority and post-backing front independence | C1/C5/C9 | RightOpen/LeftOpen/SidesBlocked; both front values after Backing |
| State/action agreement and timer domain | FSM states table, Dictionary D4 | Check after the cycle, not a transient assignment |
| Reachability of states and T0–T14 | FSM transition table | Explicit witness/probe per target; “unreached in” text alone is not a coverage report |
| Absence of invalid end states in the continuing controller | Controller Tick loop model | Preserve terminal semantics of a finite test harness; do not disguise deadlocks with end labels |

`eventually Forward` is not an unconditional project requirement. A conditional experiment may assume sides become available at a decision tick and Ticks continue; report the assumption and show it is not vacuous. Failure of an unconditional experiment can be expected under C5.

## Optional cleaning composition

Only when requested, add D3 and processes 4.1/4.2 after movement status is determined. Check no cleaning while Avoiding, C3 duration, C10 restart, C11 freeze/resume and C15 pending-dust capture/consumption in D2. A pending detection restarts five ticks on resumption; without one, saved ticks resume. Include TRUE then FALSE between ticks if modeling input events. D3 is outside the Level 4 movement FSM; label this a composed model. Cite PSPEC for simultaneous dust/obstacle behavior and use C12-C15 decisions rather than copying historical C behavior as the requirement. C14 defines suction-only boost and normal mopping.

## Interpretation

A SPIN pass establishes the configured property of the finite abstraction. It does not prove the abstraction faithful, physical collision freedom, actual C conformance or web simulator correctness. Record the property formula, source-to-model mapping and search completeness. Never use bitstate/hash approximation or a depth-limited/incomplete search as an exhaustive proof. For a counterexample, save/replay the trail with variable values and map each relevant step back to T IDs and requirement IDs.
