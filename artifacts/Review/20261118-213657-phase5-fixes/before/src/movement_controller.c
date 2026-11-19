#include "movement_controller.h"

#include "step_timer.h"

/*
 * Movement Controller group (SA Process 3.2.2).
 * Implements the Level 4 FSM (artifacts/SA/DFD/dfd_level_4_fsm.md).
 * Hidden data: the controller state.
 */
static ControllerState controller_state = CONTROLLER_STATE_FORWARD;

/* Movement Command issued while in each state (FSM "States" table). */
static const MovementCommand command_in_state[] = {
    [CONTROLLER_STATE_FORWARD] = MOVEMENT_COMMAND_FORWARD,
    [CONTROLLER_STATE_STOPPING] = MOVEMENT_COMMAND_STOP,
    [CONTROLLER_STATE_BACKING] = MOVEMENT_COMMAND_BACKWARD,
    [CONTROLLER_STATE_TURNING_RIGHT] = MOVEMENT_COMMAND_TURN_RIGHT,
    [CONTROLLER_STATE_TURNING_LEFT] = MOVEMENT_COMMAND_TURN_LEFT
};

/* Module: Movement Controller (FSM transitions T1-T14). */
MovementCommand movement_controller(SituationSignal situation_signal)
{
    const bool step_done = advance_step_timer();
    bool step_begins = false;

    if (controller_state == CONTROLLER_STATE_FORWARD) {
        if (situation_signal.front_blocked) {
            controller_state = CONTROLLER_STATE_STOPPING; /* T2 */
            step_begins = true;
        } /* else T1: keep going forward */
    } else if (step_done) {
        if ((controller_state == CONTROLLER_STATE_TURNING_RIGHT) ||
            (controller_state == CONTROLLER_STATE_TURNING_LEFT)) {
            controller_state = CONTROLLER_STATE_FORWARD; /* T12, T14 */
        } else {
            /*
             * A stop (T4-T6) or a backward step (T8-T10) has ended. Left and
             * right decide. The front is not consulted: after a stop it is
             * still blocked (C4), and after moving backward it may read clear
             * although the obstacle is still there (C9).
             */
            if (situation_signal.side_situation == SIDE_SITUATION_LEFT_OPEN) {
                controller_state = CONTROLLER_STATE_TURNING_LEFT; /* T5, T10 */
            } else if (situation_signal.side_situation == SIDE_SITUATION_BOTH_BLOCKED) {
                controller_state = CONTROLLER_STATE_BACKING; /* T6, T8 */
            } else {
                controller_state = CONTROLLER_STATE_TURNING_RIGHT; /* T4, T9 */
            }
            step_begins = true;
        }
    } else {
        /* T3, T7, T11, T13: the current step is still running. */
    }

    if (step_begins) {
        start_step_timer();
    }

    return command_in_state[controller_state];
}

/* Module: Reset Movement Controller (FSM transition T0). */
MovementCommand reset_movement_controller(void)
{
    controller_state = CONTROLLER_STATE_FORWARD;
    reset_step_timer();
    return command_in_state[controller_state];
}

/* Read-only query for unit tests and the simulator. */
ControllerState get_controller_state(void)
{
    return controller_state;
}
