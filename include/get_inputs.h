#ifndef GET_INPUTS_H
#define GET_INPUTS_H
#include "rvc_types.h"
#ifdef __cplusplus
extern "C" {
#endif
/* Requires initial readiness. Returns a value-copy classification of D1. */
ObstacleSituation get_inputs(void);
#ifdef __cplusplus
}
#endif
#endif
