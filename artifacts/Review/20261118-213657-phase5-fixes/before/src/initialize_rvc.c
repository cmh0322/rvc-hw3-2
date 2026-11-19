#include "initialize_rvc.h"

#include "issue_movement_output.h"
#include "movement_controller.h"
#include "power_up_timer.h"

/* Module: Initialize RVC (power on; FSM transition T0). */
void initialize_rvc(void)
{
    const MovementCommand initial_command = reset_movement_controller();

    reset_power_up_timer();
    issue_movement_output(initial_command);
}
