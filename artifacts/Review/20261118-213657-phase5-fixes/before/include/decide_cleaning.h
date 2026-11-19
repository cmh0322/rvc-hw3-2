/* Module: Decide Cleaning (SA Process 4.2). */
#ifndef DECIDE_CLEANING_H
#define DECIDE_CLEANING_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Chooses the Clean command for this tick: Stop while avoiding, Power Up while
 * power-up is active, otherwise Start.
 */
Clean decide_cleaning(MovementStatus movement_status, bool power_up_active);

#ifdef __cplusplus
}
#endif

#endif /* DECIDE_CLEANING_H */
