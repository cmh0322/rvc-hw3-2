#include "put_outputs.h"

#include "hw_interface.h"
#include "issue_movement_output.h"

/* Module: Put Outputs (efferent branch). */
void put_outputs(MovementCommand movement_command, Clean clean)
{
    issue_movement_output(movement_command);
    drive_cleaner(clean);
}
