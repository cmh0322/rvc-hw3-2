/* Simulator boundary for approved SD. stdin supplies actual initial sensor
 * events (all four kinds) before any Tick. Running sensor events and Tick are
 * handled in pipe receipt order; queued lines survive Controller execution.
 * stdout reports initial readiness then acknowledges every running event.
 * Sensor-only reports have no movement/cleaning command. EOF ends this adapter.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sensor_store.h"

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
    printf("\"pending_dust\":%s,", get_dust_existence().pending ? "true" : "false");
    printf("\"sensors\":{\"front\":%d,\"left\":%d,\"right\":%d,\"dust\":%d}}\n",
           front_sensor, left_sensor, right_sensor, dust_sensor);
    fflush(stdout);
}

/* Ordered stdin event stream. Initial mode never enables Tick delivery.
 * Each line is front/left/right/dust <0|1>, or tick. The pipe retains lines
 * while Controller runs. One report acknowledges each running event. */
InputEvent receive_input_event(InputMode mode)
{
    char line[128], name[16], extra;
    int value;
    if (mode == INPUT_RUNNING) report_cycle();
    if (fgets(line, sizeof line, stdin) == NULL) exit(EXIT_SUCCESS);
    InputEvent event;
    if (sscanf(line, " %15s %c", name, &extra) == 1 && strcmp(name,"tick") == 0) {
        if (mode != INPUT_RUNNING) {
            fprintf(stderr,"Tick before initial samples\n"); exit(EXIT_FAILURE);
        }
        event.kind = INPUT_TICK; event.value = false;
        tick++;
        state_before_cycle = get_controller_state();
    } else {
        if (sscanf(line," %15s %d %c",name,&value,&extra) != 2 || (value != 0 && value != 1)) {
            fprintf(stderr,"Invalid sensor event\n"); exit(EXIT_FAILURE);
        }
        if (strcmp(name,"front") == 0) {event.kind=INPUT_FRONT; front_sensor=value;}
        else if (strcmp(name,"left") == 0) {event.kind=INPUT_LEFT; left_sensor=value;}
        else if (strcmp(name,"right") == 0) {event.kind=INPUT_RIGHT; right_sensor=value;}
        else if (strcmp(name,"dust") == 0) {event.kind=INPUT_DUST; dust_sensor=value;}
        else {fprintf(stderr,"Invalid sensor kind\n"); exit(EXIT_FAILURE);}
        event.value = value != 0;
    }
    direction_issued = NOT_ISSUED;
    clean_issued = NOT_ISSUED;
    return event;
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
