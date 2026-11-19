#ifndef TEST_INPUT_HELPERS_H
#define TEST_INPUT_HELPERS_H
#include "decide_actions.h"
#include "power_up_timer.h"
#include "input_events.h"
#include "sensor_store.h"
inline Actions TestActions(ObstacleSituation situation, bool dust) {
    detect_dust(dust); return decide_actions(situation);
}
inline bool TestPowerUp(MovementStatus status, bool dust) {
    detect_dust(dust); return track_power_up(status);
}
inline void Observe(bool f,bool l,bool r,bool d) {
    dispatch_sensor_input({INPUT_FRONT,f}); dispatch_sensor_input({INPUT_LEFT,l});
    dispatch_sensor_input({INPUT_RIGHT,r}); dispatch_sensor_input({INPUT_DUST,d});
}
#endif
