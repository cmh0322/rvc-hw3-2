#ifndef SENSOR_STORE_H
#define SENSOR_STORE_H
#include "rvc_types.h"
#ifdef __cplusplus
extern "C" {
#endif
/* Sensor kinds/valid readings are boundary preconditions. Getters return copies. */
void reset_sensor_data(void);
bool inputs_ready(void);
void detect_obstacle(InputKind sensor, bool value);
void detect_dust(bool value);
ObstacleLocation get_obstacle_location(void);
DustExistence get_dust_existence(void);
void clear_pending_dust(void);
#ifdef __cplusplus
}
#endif
#endif
