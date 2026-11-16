#include "assess_obstacle_situation.h"

/* Module: Assess Obstacle Situation (SA Process 3.1). */
ObstacleSituation assess_obstacle_situation(ObstacleLocation obstacle_location)
{
    ObstacleSituation obstacle_situation;

    if (!obstacle_location.front_obstacle) {
        /* Left and right are ignored while the front is clear (Q6 assumption). */
        obstacle_situation = OBSTACLE_SITUATION_CLEAR;
    } else if (!obstacle_location.right_obstacle) {
        /* Right has priority over left (C1). */
        obstacle_situation = OBSTACLE_SITUATION_RIGHT_OPEN;
    } else if (!obstacle_location.left_obstacle) {
        obstacle_situation = OBSTACLE_SITUATION_LEFT_OPEN;
    } else {
        obstacle_situation = OBSTACLE_SITUATION_ALL_BLOCKED; /* B4 */
    }

    return obstacle_situation;
}
