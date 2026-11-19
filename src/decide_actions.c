#include "decide_actions.h"

#include "decide_cleaning.h"
#include "derive_movement_status.h"
#include "movement_controller.h"
#include "power_up_timer.h"

/* Module: Decide Actions (central branch). */
Actions decide_actions(ObstacleSituation obstacle_situation)
{
    Actions actions;

    /*
     * The Obstacle Situation is handed to the Movement Controller as the
     * Situation Signal (SA Process 3.2.1); the value is the same.
     */
    actions.movement_command = movement_controller(obstacle_situation);

    const MovementStatus movement_status = derive_movement_status(actions.movement_command);
    const bool power_up_active = track_power_up(movement_status);

    actions.clean = decide_cleaning(movement_status, power_up_active);

    return actions;
}
