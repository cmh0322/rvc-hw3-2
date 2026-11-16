/* Module: Derive Movement Status (SA Process 3.2.3, Movement Status part). */
#ifndef DERIVE_MOVEMENT_STATUS_H
#define DERIVE_MOVEMENT_STATUS_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Returns Forward when the Movement Command is Forward, otherwise Avoiding. */
MovementStatus derive_movement_status(MovementCommand movement_command);

#ifdef __cplusplus
}
#endif

#endif /* DERIVE_MOVEMENT_STATUS_H */
