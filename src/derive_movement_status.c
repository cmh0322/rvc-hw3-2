#include "derive_movement_status.h"

/* Module: Derive Movement Status (SA Process 3.2.3, Movement Status part). */
MovementStatus derive_movement_status(MovementCommand movement_command)
{
    MovementStatus movement_status;

    if (movement_command == MOVEMENT_COMMAND_FORWARD) {
        movement_status = MOVEMENT_STATUS_FORWARD;
    } else {
        /* Stop, turn, and backward are all part of avoiding an obstacle (B3). */
        movement_status = MOVEMENT_STATUS_AVOIDING;
    }

    return movement_status;
}
