#include "initialize_rvc.h"

#include "input_events.h"
#include "sensor_store.h"
#include "movement_controller.h"
#include "power_up_timer.h"

/* Module: Initialize RVC (power on; FSM transition T0). */
void initialize_rvc(void)
{
    reset_movement_controller();
    reset_power_up_timer();
    reset_sensor_data();
    acquire_initial_inputs();
}
