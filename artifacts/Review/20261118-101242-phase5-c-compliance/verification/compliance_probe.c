/* Audit harness only: links unchanged production C; not a product/test-suite fix. */
#include <setjmp.h>
#include <stdio.h>
#include "controller.h"
#include "detect_dust.h"
#include "hw_interface.h"
#include "initialize_rvc.h"
#include "power_up_timer.h"

int rvc_audit_main(void);
static jmp_buf stop_main;
static bool front, left, right, dust;
static int reads[4], motor_calls, cleaner_calls;
static Direction direction;
static Clean clean;
bool read_front_sensor(void) { reads[0]++; return front; }
bool read_left_sensor(void) { reads[1]++; return left; }
bool read_right_sensor(void) { reads[2]++; return right; }
bool read_dust_sensor(void) { reads[3]++; return dust; }
void drive_motor(Direction value) { motor_calls++; direction=value; }
void drive_cleaner(Clean value) { cleaner_calls++; clean=value; }
void wait_for_tick(void) { longjmp(stop_main, 1); }

static void reset(void) {
    front=left=right=dust=false;
    for (int i=0;i<4;i++) reads[i]=0;
    motor_calls=cleaner_calls=0;
    initialize_rvc();
}
static void cycle(bool f, bool d) { front=f; dust=d; controller(); }
static int failures;
static void result(const char *id, int expected, int actual) {
    printf("{\"id\":\"%s\",\"expected\":%d,\"actual\":%d,\"passes\":%s}\n",
           id,expected,actual,expected==actual?"true":"false");
    failures += expected!=actual;
}
int main(void) {
    /* Stop at entry to the first clock wait; no Tick has been delivered. */
    if (setjmp(stop_main)==0) (void)rvc_audit_main();
    result("C13.initial_motor_commands",0,motor_calls);
    result("C13.initial_clean_commands",0,cleaner_calls);
    result("C12.initial_actual_sensor_reads",4,reads[0]+reads[1]+reads[2]+reads[3]);

    /* A dust sample is actually read during avoidance, then clears. */
    reset();
    cycle(true,true);
    for (int i=0;i<9;i++) cycle(true,false);
    cycle(false,false);
    result("C15.avoidance_only_dust_return_clean",CLEAN_POWER_UP,clean);
    result("C15.avoidance_only_dust_return_remaining",4,get_remaining_power_up_ticks());

    /* Pending new detection must override the saved partial boost. */
    reset();
    cycle(false,true); cycle(false,false); /* three ticks remain */
    cycle(true,true);
    for (int i=0;i<9;i++) cycle(true,false);
    cycle(false,false);
    result("C15.pending_overrides_paused_remaining",4,get_remaining_power_up_ticks());

    /* Even explicitly observing TRUE then FALSE through old Detect Dust loses it. */
    reset();
    dust=true; (void)detect_dust(); dust=false; (void)detect_dust();
    controller();
    result("C15.observed_true_false_before_tick",CLEAN_POWER_UP,clean);

    /* Controls: existing C11 and C16 paths still behave as specified. */
    reset(); cycle(false,true); cycle(false,false);
    cycle(true,false);
    for (int i=0;i<9;i++) cycle(true,false);
    cycle(false,false);
    result("C11.no_new_dust_resumes_remaining",2,get_remaining_power_up_ticks());
    reset(); left=right=true; cycle(false,false);
    result("C16.side_only_forward",DIRECTION_FORWARD,direction);
    result("C16.side_only_clean",CLEAN_START,clean);
    return failures ? 1 : 0;
}
