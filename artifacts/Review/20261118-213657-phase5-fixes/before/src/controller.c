#include "controller.h"

#include "decide_actions.h"
#include "get_inputs.h"
#include "put_outputs.h"

/* Module: Controller (one control cycle per Tick). */
void controller(void)
{
    const Inputs inputs = get_inputs();
    const Actions actions = decide_actions(inputs.obstacle_situation, inputs.dust_existence);

    put_outputs(actions.movement_command, actions.clean);
}
