#include "controller.h"

#include "decide_actions.h"
#include "get_inputs.h"
#include "put_outputs.h"

/* Module: Controller (one control cycle per Tick). */
void controller(void)
{
    const ObstacleSituation situation = get_inputs();
    const Actions actions = decide_actions(situation);

    put_outputs(actions.movement_command, actions.clean);
}
