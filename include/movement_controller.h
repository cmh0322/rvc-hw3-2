/*
 * Movement Controller group (SA Process 3.2.2, the Level 4 FSM).
 * Modules: Movement Controller, Reset Movement Controller.
 * Hidden data: the controller state. No other module can read or write it.
 */
#ifndef MOVEMENT_CONTROLLER_H
#define MOVEMENT_CONTROLLER_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Movement Controller: takes one FSM transition (T1-T14) for this Tick and
 * returns the Movement Command. Call it exactly once per Tick.
 */
MovementCommand movement_controller(SituationSignal situation_signal);

/*
 * Reset Movement Controller: FSM transition T0. Sets the state to Forward,
 * resets the step timer, and returns the initial Movement Command (Forward).
 */
MovementCommand reset_movement_controller(void);

/*
 * Read-only query for unit tests and the simulator. No production module
 * calls it.
 */
ControllerState get_controller_state(void);

#ifdef __cplusplus
}
#endif

#endif /* MOVEMENT_CONTROLLER_H */
