#include "detect_obstacle.h"

#include "hw_interface.h"

/* Module: Detect Obstacle (SA Process 1). */
ObstacleLocation detect_obstacle(void)
{
    ObstacleLocation obstacle_location;

    obstacle_location.front_obstacle = read_front_sensor();
    obstacle_location.left_obstacle = read_left_sensor();
    obstacle_location.right_obstacle = read_right_sensor();

    return obstacle_location;
}
