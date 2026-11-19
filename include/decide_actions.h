/* Module: Decide Actions (central branch of the Structure Chart). */
#ifndef DECIDE_ACTIONS_H
#define DECIDE_ACTIONS_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* The two commands decided for one cycle. */
typedef struct {
    MovementCommand movement_command;
    Clean clean;
} Actions;

/*
 * Decides the Movement Command and the Clean command for this cycle from the
 * Obstacle Situation using the Sensor Store for dust. Call it exactly once per Tick.
 */
Actions decide_actions(ObstacleSituation obstacle_situation);

#ifdef __cplusplus
}
#endif

#endif /* DECIDE_ACTIONS_H */
