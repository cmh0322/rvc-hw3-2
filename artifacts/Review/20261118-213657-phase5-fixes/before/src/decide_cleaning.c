#include "decide_cleaning.h"

/* Module: Decide Cleaning (SA Process 4.2). */
Clean decide_cleaning(MovementStatus movement_status, bool power_up_active)
{
    Clean clean;

    if (movement_status == MOVEMENT_STATUS_AVOIDING) {
        clean = CLEAN_STOP; /* B3 */
    } else if (power_up_active) {
        clean = CLEAN_POWER_UP; /* B5 */
    } else {
        clean = CLEAN_START; /* B1, B2; also resumes cleaning after avoidance (B3) */
    }

    return clean;
}
