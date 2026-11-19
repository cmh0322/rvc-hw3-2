#ifndef INPUT_EVENTS_H
#define INPUT_EVENTS_H
#include "rvc_types.h"
#ifdef __cplusplus
extern "C" {
#endif
void acquire_initial_inputs(void);
void dispatch_sensor_input(InputEvent event);
void dispatch_input_event(InputEvent event);
#ifdef __cplusplus
}
#endif
#endif
