/* Module: Put Outputs (efferent branch of the Structure Chart). */
#ifndef PUT_OUTPUTS_H
#define PUT_OUTPUTS_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Delivers the two decided commands: Direction to the Motor, Clean to the Cleaner. */
void put_outputs(MovementCommand movement_command, Clean clean);

#ifdef __cplusplus
}
#endif

#endif /* PUT_OUTPUTS_H */
