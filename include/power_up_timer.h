/*
 * Power-Up Timer group (SA Process 4.1, Data Store D3).
 * Modules: Track Power-Up, Reset Power-Up Timer.
 * Hidden data: Remaining Power-Up Ticks. No other module can read or write it.
 */
#ifndef POWER_UP_TIMER_H
#define POWER_UP_TIMER_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Track Power-Up: starts a POWER_UP_DURATION_TICKS power-up when dust is
 * current or pending in D2, consumes pending only on Forward, and returns whether
 * powered-up cleaning applies on this tick. Call it exactly once per Tick.
 */
bool track_power_up(MovementStatus movement_status);

/* Reset Power-Up Timer: sets the remaining count to 0 (its power-on value). */
void reset_power_up_timer(void);

/*
 * Read-only query for unit tests and the simulator. No production module
 * calls it.
 */
int get_remaining_power_up_ticks(void);

#ifdef __cplusplus
}
#endif

#endif /* POWER_UP_TIMER_H */
