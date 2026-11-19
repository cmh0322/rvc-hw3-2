/* Module: Assess Obstacle Situation (SA Process 3.1). */
#ifndef ASSESS_OBSTACLE_SITUATION_H
#define ASSESS_OBSTACLE_SITUATION_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Classifies an Obstacle Location: whether the front is blocked, and whether
 * the right is open, only the left is open, or both sides are blocked.
 */
ObstacleSituation assess_obstacle_situation(ObstacleLocation obstacle_location);

#ifdef __cplusplus
}
#endif

#endif /* ASSESS_OBSTACLE_SITUATION_H */
