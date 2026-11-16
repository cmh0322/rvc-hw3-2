#include "assess_obstacle_situation.h"

/* Module: Assess Obstacle Situation (SA Process 3.1). */
ObstacleSituation assess_obstacle_situation(ObstacleLocation obstacle_location)
{
    ObstacleSituation obstacle_situation;

    obstacle_situation.front_blocked = obstacle_location.front_obstacle;

    if (!obstacle_location.right_obstacle) {
        /* Right has priority over left (C1). */
        obstacle_situation.side_situation = SIDE_SITUATION_RIGHT_OPEN;
    } else if (!obstacle_location.left_obstacle) {
        obstacle_situation.side_situation = SIDE_SITUATION_LEFT_OPEN;
    } else {
        obstacle_situation.side_situation = SIDE_SITUATION_BOTH_BLOCKED;
    }

    return obstacle_situation;
}
