#include "get_inputs.h"

#include "assess_obstacle_situation.h"
#include "detect_dust.h"
#include "detect_obstacle.h"

/* Module: Get Inputs (afferent branch). */
Inputs get_inputs(void)
{
    Inputs inputs;
    const ObstacleLocation obstacle_location = detect_obstacle();

    inputs.obstacle_situation = assess_obstacle_situation(obstacle_location);
    inputs.dust_existence = detect_dust();

    return inputs;
}
