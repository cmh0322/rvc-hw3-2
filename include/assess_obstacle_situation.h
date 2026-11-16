/* Module: Assess Obstacle Situation (SA Process 3.1). */
#ifndef ASSESS_OBSTACLE_SITUATION_H
#define ASSESS_OBSTACLE_SITUATION_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Classifies an Obstacle Location as Clear, Right Open, Left Open, or
 * All Blocked. Left and right are considered only when the front is blocked.
 */
ObstacleSituation assess_obstacle_situation(ObstacleLocation obstacle_location);

#ifdef __cplusplus
}
#endif

#endif /* ASSESS_OBSTACLE_SITUATION_H */
