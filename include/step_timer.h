/*
 * Step Timer group (SA Process 3.2.4, Data Store D4).
 * Modules: Advance Step Timer, Start Step Timer, Reset Step Timer.
 * Hidden data: Step Ticks Elapsed. No other module can read or write it.
 */
#ifndef STEP_TIMER_H
#define STEP_TIMER_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Advance Step Timer: counts one tick of the running step. Returns true
 * (Step Done) when the step has lasted STEP_DURATION_TICKS ticks; the timer is
 * then idle again. Does nothing and returns false when no step is running.
 */
bool advance_step_timer(void);

/* Start Step Timer: begins counting a new step. */
void start_step_timer(void);

/* Reset Step Timer: sets the timer to idle (its power-on value). */
void reset_step_timer(void);

/*
 * Read-only query for unit tests and the simulator. Returns STEP_TIMER_IDLE
 * or the ticks counted in the running step. No production module calls it.
 */
int get_step_ticks_elapsed(void);

#ifdef __cplusplus
}
#endif

#endif /* STEP_TIMER_H */
