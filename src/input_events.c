#include "input_events.h"
#include "controller.h"
#include "hw_interface.h"
#include "sensor_store.h"

void acquire_initial_inputs(void)
{
    while (!inputs_ready()) {
        dispatch_sensor_input(receive_input_event(INPUT_INITIAL_SENSORS));
    }
}
void dispatch_sensor_input(InputEvent event)
{
    if (event.kind == INPUT_DUST) detect_dust(event.value);
    else detect_obstacle(event.kind, event.value);
}
void dispatch_input_event(InputEvent event)
{
    if (event.kind == INPUT_TICK) controller();
    else dispatch_sensor_input(event);
}
