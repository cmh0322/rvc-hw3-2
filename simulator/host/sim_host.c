/*
 * Simulator host: the hardware interface for the web simulator.
 *
 * This file implements the seven library modules of include/hw_interface.h
 * and links with the unchanged production code, including main(). It makes
 * no control decision. It only carries values between the production code and
 * the simulator, one line per Tick:
 *
 *   stdout  one JSON line with the outputs and the internal state, written
 *           each time main() waits for a Tick (the first line is the state
 *           after power on)
 *   stdin   one line "front left right dust" (each 0 or 1) per Tick
 *
 * End of input ends the program.
 */
#include <stdio.h>
#include <stdlib.h>

#include "hw_interface.h"
#include "movement_controller.h"
#include "power_up_timer.h"
#include "step_timer.h"

#define NOT_ISSUED (-1)

static const char *const direction_names[] = {
    [DIRECTION_FORWARD] = "Forward",
    [DIRECTION_BACKWARD] = "Backward",
    [DIRECTION_TURN_LEFT] = "Turn Left",
    [DIRECTION_TURN_RIGHT] = "Turn Right",
    [DIRECTION_STOP] = "Stop"
};

static const char *const clean_names[] = {
    [CLEAN_START] = "Start",
    [CLEAN_STOP] = "Stop",
    [CLEAN_POWER_UP] = "Power Up"
};

static const char *const state_names[] = {
    [CONTROLLER_STATE_FORWARD] = "Forward",
    [CONTROLLER_STATE_STOPPING] = "Stopping",
    [CONTROLLER_STATE_BACKING] = "Backing",
    [CONTROLLER_STATE_TURNING_RIGHT] = "TurningRight",
    [CONTROLLER_STATE_TURNING_LEFT] = "TurningLeft"
};

/* Sensor values of the current Tick, as given by the simulator. */
static int front_sensor = 0;
static int left_sensor = 0;
static int right_sensor = 0;
static int dust_sensor = 0;

/* What the production code sent during the current cycle. */
static int direction_issued = NOT_ISSUED;
static int clean_issued = NOT_ISSUED;

static int tick = 0;
static ControllerState state_before_cycle = CONTROLLER_STATE_FORWARD;

static void print_name(const char *key, const char *const names[], int value)
{
    if (value == NOT_ISSUED) {
        printf("\"%s\":null,", key);
    } else {
        printf("\"%s\":\"%s\",", key, names[value]);
    }
}

static void report_cycle(void)
{
    printf("{\"tick\":%d,", tick);
    print_name("direction", direction_names, direction_issued);
    print_name("clean", clean_names, clean_issued);
    printf("\"previous_state\":\"%s\",", state_names[state_before_cycle]);
    printf("\"state\":\"%s\",", state_names[get_controller_state()]);
    printf("\"step_ticks_elapsed\":%d,", get_step_ticks_elapsed());
    printf("\"remaining_power_up_ticks\":%d,", get_remaining_power_up_ticks());
    printf("\"sensors\":{\"front\":%d,\"left\":%d,\"right\":%d,\"dust\":%d}}\n",
           front_sensor, left_sensor, right_sensor, dust_sensor);
    fflush(stdout);
}

/* Library module: Wait For Tick. */
void wait_for_tick(void)
{
    char line[64];

    report_cycle();

    if (fgets(line, sizeof line, stdin) == NULL) {
        exit(EXIT_SUCCESS);
    }
    if (sscanf(line, "%d %d %d %d", &front_sensor, &left_sensor, &right_sensor, &dust_sensor) != 4) {
        fprintf(stderr, "sim_host: expected \"front left right dust\", got: %s", line);
        exit(EXIT_FAILURE);
    }

    tick++;
    state_before_cycle = get_controller_state();
    direction_issued = NOT_ISSUED;
    clean_issued = NOT_ISSUED;
}

/* Library modules: the four sensors. */
bool read_front_sensor(void)
{
    return front_sensor != 0;
}

bool read_left_sensor(void)
{
    return left_sensor != 0;
}

bool read_right_sensor(void)
{
    return right_sensor != 0;
}

bool read_dust_sensor(void)
{
    return dust_sensor != 0;
}

/* Library module: Drive Motor. */
void drive_motor(Direction direction)
{
    direction_issued = (int)direction;
}

/* Library module: Drive Cleaner. */
void drive_cleaner(Clean clean)
{
    clean_issued = (int)clean;
}
