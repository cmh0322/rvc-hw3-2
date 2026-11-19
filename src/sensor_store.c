#include "sensor_store.h"

/* Sole owners of D1/D2. No writable state reference escapes this group. */
static ObstacleLocation location;
static DustExistence dust;
static bool valid[4];

void reset_sensor_data(void)
{
    /* Values in invalid slots are not observations. */
    for (int i = 0; i < 4; ++i) valid[i] = false;
    dust.pending = false;
}
bool inputs_ready(void)
{
    return valid[0] && valid[1] && valid[2] && valid[3];
}
void detect_obstacle(InputKind sensor, bool value)
{
    if (sensor == INPUT_FRONT) location.front_obstacle = value;
    else if (sensor == INPUT_LEFT) location.left_obstacle = value;
    else location.right_obstacle = value;
    valid[sensor] = true;
}
void detect_dust(bool value)
{
    dust.current = value;
    dust.pending = dust.pending || value;
    valid[INPUT_DUST] = true;
}
ObstacleLocation get_obstacle_location(void) { return location; }
DustExistence get_dust_existence(void) { return dust; }
void clear_pending_dust(void) { dust.pending = false; }
