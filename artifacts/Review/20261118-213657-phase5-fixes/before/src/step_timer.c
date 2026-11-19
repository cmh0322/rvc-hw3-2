#include "step_timer.h"

/*
 * Step Timer group (SA Process 3.2.4).
 * Hidden data: Data Store D4, Step Ticks Elapsed.
 */
static int step_ticks_elapsed = STEP_TIMER_IDLE;

/* Module: Advance Step Timer (Process 3.2.4, on Tick). */
bool advance_step_timer(void)
{
    bool step_done = false;

    if (step_ticks_elapsed != STEP_TIMER_IDLE) {
        step_ticks_elapsed++;
        if (step_ticks_elapsed == STEP_DURATION_TICKS) {
            step_done = true;
            step_ticks_elapsed = STEP_TIMER_IDLE;
        }
    }

    return step_done;
}

/* Module: Start Step Timer (Process 3.2.4, on Start Step Timer). */
void start_step_timer(void)
{
    /* The tick on which the step starts is the first tick of the step. */
    step_ticks_elapsed = 0;
}

/* Module: Reset Step Timer (initial value of D4). */
void reset_step_timer(void)
{
    step_ticks_elapsed = STEP_TIMER_IDLE;
}

/* Read-only query for unit tests and the simulator. */
int get_step_ticks_elapsed(void)
{
    return step_ticks_elapsed;
}
