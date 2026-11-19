/* Module: Get Inputs (afferent branch of the Structure Chart). */
#ifndef GET_INPUTS_H
#define GET_INPUTS_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* The two inputs the decisions of one cycle need. */
typedef struct {
    ObstacleSituation obstacle_situation;
    bool dust_existence;
} Inputs;

/*
 * Reads every sensor once and returns the Obstacle Situation and the
 * Dust Existence for this cycle.
 */
Inputs get_inputs(void);

#ifdef __cplusplus
}
#endif

#endif /* GET_INPUTS_H */
