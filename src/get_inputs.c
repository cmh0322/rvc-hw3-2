#include "get_inputs.h"

#include "assess_obstacle_situation.h"
#include "sensor_store.h"

/* Module: Get Inputs (afferent branch). */
ObstacleSituation get_inputs(void)
{
    const ObstacleLocation location = get_obstacle_location();
    return assess_obstacle_situation(location);
}
