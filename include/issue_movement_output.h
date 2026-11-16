/* Module: Issue Movement Output (SA Process 3.2.3, Direction part). */
#ifndef ISSUE_MOVEMENT_OUTPUT_H
#define ISSUE_MOVEMENT_OUTPUT_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Converts a Movement Command into the Direction and sends it to the Motor. */
void issue_movement_output(MovementCommand movement_command);

#ifdef __cplusplus
}
#endif

#endif /* ISSUE_MOVEMENT_OUTPUT_H */
