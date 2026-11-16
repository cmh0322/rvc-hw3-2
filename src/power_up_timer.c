#include "power_up_timer.h"

/*
 * Power-Up Timer group (SA Process 4.1).
 * Hidden data: Data Store D3, Remaining Power-Up Ticks.
 */
static int remaining_power_up_ticks = 0;

/* Module: Track Power-Up (Process 4.1). */
bool track_power_up(MovementStatus movement_status, bool dust_existence)
{
    bool power_up_active = false;

    if (movement_status == MOVEMENT_STATUS_FORWARD) {
        /*
         * B5, C3. Dust detected while a power-up is running leaves the count
         * unchanged; whether it should restart is open (Q4).
         */
        if (dust_existence && (remaining_power_up_ticks == 0)) {
            remaining_power_up_ticks = POWER_UP_DURATION_TICKS;
        }
        if (remaining_power_up_ticks > 0) {
            power_up_active = true;
            remaining_power_up_ticks--;
        }
    } else {
        /*
         * Avoiding: no powered-up cleaning (B3). The count is kept; whether it
         * should be cleared is open (Q5).
         */
    }

    return power_up_active;
}

/* Module: Reset Power-Up Timer (initial value of D3). */
void reset_power_up_timer(void)
{
    remaining_power_up_ticks = 0;
}

/* Read-only query for unit tests and the simulator. */
int get_remaining_power_up_ticks(void)
{
    return remaining_power_up_ticks;
}
