#include "issue_movement_output.h"

#include "hw_interface.h"

/* Direction that carries out each Movement Command (same meaning, Motor's type). */
static const Direction direction_for_command[] = {
    [MOVEMENT_COMMAND_FORWARD] = DIRECTION_FORWARD,
    [MOVEMENT_COMMAND_STOP] = DIRECTION_STOP,
    [MOVEMENT_COMMAND_TURN_RIGHT] = DIRECTION_TURN_RIGHT,
    [MOVEMENT_COMMAND_TURN_LEFT] = DIRECTION_TURN_LEFT,
    [MOVEMENT_COMMAND_BACKWARD] = DIRECTION_BACKWARD
};

/* Module: Issue Movement Output (SA Process 3.2.3, Direction part). */
void issue_movement_output(MovementCommand movement_command)
{
    drive_motor(direction_for_command[movement_command]);
}
