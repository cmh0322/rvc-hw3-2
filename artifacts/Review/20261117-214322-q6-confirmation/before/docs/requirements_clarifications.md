# Requirements Clarifications

Decisions made by the project owner from 2026-11-06 through 2026-11-17. They supplement `preliminary_requirements.md`, which remains unchanged. Bullets of that file are cited as B1-B7, by order.

## Confirmed Decisions

| ID | Refines | Decision |
|---|---|---|
| C1 | B3 | When a front obstacle is found and both left and right are clear, the RVC turns right. |
| C2 | B3 | When an obstacle is found, the RVC stops moving before it continues. |
| C3 | B5 | "For a while" means 5 ticks. |
| C4 | B3, B4 | Obstacles do not disappear. An obstacle detected stays in place while the RVC stops, moves backward, or turns. (Decided 2026-11-08.) |
| C5 | B4, Q1 | After moving backward, the RVC turns right if the right is clear. If the right is blocked and the left is clear, it turns left. If left and right are still both blocked, it moves backward once more. (Decided 2026-11-08; left-turn case added the same day.) |
| C6 | B4, Q2 | Moving backward lasts 5 ticks. (Decided 2026-11-08.) |
| C7 | C2, Q3 | The stop before avoidance lasts 5 ticks. (Decided 2026-11-08.) |
| C8 | B3, B4 | A turn (left or right) lasts 5 ticks. (Decided 2026-11-08.) |
| C9 | B4, C5 | After moving backward, only left and right decide (as C5 states); the front sensor is not consulted. Moving backward takes the RVC away from the obstacle, so the front may read clear. (Decided 2026-11-16.) |
| C10 | B5, C3, Q4 | Dust detected again during a running power-up restarts the 5 ticks. (Decided 2026-11-16.) |
| C11 | B3, C3, Q5 | A power-up interrupted by an avoidance keeps its remaining ticks and continues when the RVC moves forward again. (Decided 2026-11-16.) |
| C12 | B2-B5, P1-04 | Read all four sensors (front, left, right, dust) before processing the first Tick. Unreceived sensor values must not be treated as FALSE. (Decided 2026-11-17.) |
| C13 | B1, B2, P1-05 | Power On only initializes the Forward state. No Direction or Clean command is emitted at Power On; the first Tick evaluates the sensors and emits the first movement and cleaning commands. (Decided 2026-11-17.) |
| C14 | B1, B5, P1-06 | Clean Start and Stop switch suction cleaning and mopping on and off together. Power Up increases suction only; mopping continues at its normal level. Hardware details remain out of scope (B6). (Decided 2026-11-17.) |
| C15 | B5, C10, C11, P1-07 | Remember dust detected during avoidance even if the sensor becomes clear before Forward resumes. On the first Forward Tick, start or restart a full 5-tick power-up when such a detection is pending, including when a previous power-up was paused. Without a pending or current detection, resume the saved remaining ticks (C11). (Decided 2026-11-17.) |

## Phase 1 decision record (2026-11-17)

C12-C15 record the project owner's four answers to the Phase 1 review. C15 resolves the formerly unnumbered avoidance-dust question. It refines C11: preserve the remaining count during avoidance, but a remembered detection takes precedence and restarts the count on resumption. Repeated detections before resumption coalesce into one restart; they do not accumulate multiple five-tick periods.

The SA realization initializes D3 to 0 (no power-up yet), D4 to Idle, and the pending-dust flag to FALSE before receiving initial samples. Actual sensor values are obtained under C12, not invented as defaults. A dust detection is recorded when a TRUE sensor input is received, so a later FALSE before the next Tick must not erase it. These are analysis refinements supporting B5/C3/C12-C15, not extra external functions.

The answers authorize the requirements/SA corrections. They do not assert that the existing SD, C implementation, tests or simulator already satisfy the revised requirements; downstream propagation is recorded in QA.md.

## Open Questions

| ID | Refines | Question |
|---|---|---|
| Q1 | B4 | After moving backward, which way does the RVC turn, and what happens if left and right are still both blocked? **Resolved by C5.** |
| Q2 | B4 | How far or how many ticks does the RVC move backward? **Resolved by C6.** |
| Q3 | C2 | How many ticks does the stop last? **Resolved by C7.** |
| Q4 | B5, C3 | If dust is detected again during the 5 ticks, does the count restart or continue? **Resolved by C10.** |
| Q5 | B3, C3 | If an obstacle interrupts powered-up cleaning, is the remaining count kept or cancelled? **Resolved by C11.** |
| Q6 | B3 | Does an obstacle on the left or right trigger avoidance when the front is clear? This analysis assumes it does not. |
