/*
 * Data types of the RVC Controller.
 * Names and values follow artifacts/SA/data_dictionary.md.
 */
#ifndef RVC_TYPES_H
#define RVC_TYPES_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Obstacle Location: latest reading of the three obstacle sensors. */
typedef struct {
    bool front_obstacle;
    bool left_obstacle;
    bool right_obstacle;
} ObstacleLocation;

/* Obstacle Situation: classification of an Obstacle Location. */
typedef enum {
    OBSTACLE_SITUATION_CLEAR,       /* no front obstacle */
    OBSTACLE_SITUATION_RIGHT_OPEN,  /* front blocked, right clear */
    OBSTACLE_SITUATION_LEFT_OPEN,   /* front and right blocked, left clear */
    OBSTACLE_SITUATION_ALL_BLOCKED  /* front, left, and right blocked */
} ObstacleSituation;

/* Situation Signal: the Obstacle Situation as seen by the Movement Controller. */
typedef ObstacleSituation SituationSignal;

/* Movement Command: action chosen by the Movement Controller for one tick. */
typedef enum {
    MOVEMENT_COMMAND_FORWARD,
    MOVEMENT_COMMAND_STOP,
    MOVEMENT_COMMAND_TURN_RIGHT,
    MOVEMENT_COMMAND_TURN_LEFT,
    MOVEMENT_COMMAND_BACKWARD
} MovementCommand;

/* Direction: movement command sent to the Motor. */
typedef enum {
    DIRECTION_FORWARD,
    DIRECTION_BACKWARD,
    DIRECTION_TURN_LEFT,
    DIRECTION_TURN_RIGHT,
    DIRECTION_STOP
} Direction;

/* Movement Status: whether the RVC is moving forward or avoiding an obstacle. */
typedef enum {
    MOVEMENT_STATUS_FORWARD,
    MOVEMENT_STATUS_AVOIDING
} MovementStatus;

/* Clean: cleaning command sent to the Cleaner. */
typedef enum {
    CLEAN_START,
    CLEAN_STOP,
    CLEAN_POWER_UP
} Clean;

/* States of the Movement Controller (artifacts/SA/DFD/dfd_level_4_fsm.md). */
typedef enum {
    CONTROLLER_STATE_FORWARD,
    CONTROLLER_STATE_STOPPING,
    CONTROLLER_STATE_BACKING,
    CONTROLLER_STATE_TURNING_RIGHT,
    CONTROLLER_STATE_TURNING_LEFT
} ControllerState;

/* A stop, backward, or turn step lasts 5 ticks (C7, C6, C8). */
#define STEP_DURATION_TICKS 5

/* Step Ticks Elapsed while no step is running. */
#define STEP_TIMER_IDLE (-1)

/* Powered-up cleaning lasts 5 ticks (C3). */
#define POWER_UP_DURATION_TICKS 5

#ifdef __cplusplus
}
#endif

#endif /* RVC_TYPES_H */
