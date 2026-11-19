#include "detect_dust.h"

#include "hw_interface.h"

/* Module: Detect Dust (SA Process 2). */
bool detect_dust(void)
{
    return read_dust_sensor();
}
