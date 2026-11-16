#include "controller.h"
#include "hw_interface.h"
#include "initialize_rvc.h"

/*
 * Module: Main (root of the Structure Chart).
 * Initializes the system once, then runs one control cycle for every Tick.
 * The requirements define no shutdown event, so the loop does not end.
 */
int main(void)
{
    initialize_rvc();

    for (;;) {
        wait_for_tick();
        controller();
    }
}
