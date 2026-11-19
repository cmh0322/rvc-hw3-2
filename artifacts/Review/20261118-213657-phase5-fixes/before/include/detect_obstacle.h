/* Module: Detect Obstacle (SA Process 1). */
#ifndef DETECT_OBSTACLE_H
#define DETECT_OBSTACLE_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Reads the three obstacle sensors and returns them as one Obstacle Location. */
ObstacleLocation detect_obstacle(void);

#ifdef __cplusplus
}
#endif

#endif /* DETECT_OBSTACLE_H */
