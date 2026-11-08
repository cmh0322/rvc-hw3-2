# Requirements Clarifications

Decisions made by the project owner on 2026-11-06. They supplement `preliminary_requirements.md`, which remains unchanged. Bullets of that file are cited as B1-B7, by order.

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

## Open Questions

| ID | Refines | Question |
|---|---|---|
| Q1 | B4 | After moving backward, which way does the RVC turn, and what happens if left and right are still both blocked? **Resolved by C5.** |
| Q2 | B4 | How far or how many ticks does the RVC move backward? **Resolved by C6.** |
| Q3 | C2 | How many ticks does the stop last? **Resolved by C7.** |
| Q4 | B5, C3 | If dust is detected again during the 5 ticks, does the count restart or continue? |
| Q5 | B3, C3 | If an obstacle interrupts powered-up cleaning, is the remaining count kept or cancelled? |
| Q6 | B3 | Does an obstacle on the left or right trigger avoidance when the front is clear? This analysis assumes it does not. |
