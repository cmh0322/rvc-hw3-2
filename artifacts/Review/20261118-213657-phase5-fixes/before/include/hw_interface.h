/*
 * Hardware interface: the seven library modules of the Structure Chart.
 * Each stands for one terminator of the Context Diagram.
 *
 * These functions are declared only. Their implementation is outside this
 * design (requirement B6). Unit tests and the simulator supply their own.
 */
#ifndef HW_INTERFACE_H
#define HW_INTERFACE_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Read Front Sensor: true when an obstacle is detected in front. */
bool read_front_sensor(void);

/* Read Left Sensor: true when an obstacle is detected on the left. */
bool read_left_sensor(void);

/* Read Right Sensor: true when an obstacle is detected on the right. */
bool read_right_sensor(void);

/* Read Dust Sensor: true when dust is detected. */
bool read_dust_sensor(void);

/* Wait For Tick: returns when the next Tick of the Digital Clock occurs. */
void wait_for_tick(void);

/* Drive Motor: sends a Direction to the Motor. */
void drive_motor(Direction direction);

/* Drive Cleaner: sends a Clean command to the Cleaner. */
void drive_cleaner(Clean clean);

#ifdef __cplusplus
}
#endif

#endif /* HW_INTERFACE_H */
