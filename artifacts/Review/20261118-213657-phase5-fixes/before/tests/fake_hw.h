// Test double for the hardware interface (include/hw_interface.h).
// Tests set the sensor values and inspect what was sent to the Motor and Cleaner.
#ifndef FAKE_HW_H
#define FAKE_HW_H

#include <csetjmp>
#include <functional>
#include <string>
#include <vector>

#include "hw_interface.h"

struct FakeHw {
    // Sensor values returned by the read_*_sensor functions.
    bool front = false;
    bool left = false;
    bool right = false;
    bool dust = false;

    // Number of times each sensor was read.
    int front_reads = 0;
    int left_reads = 0;
    int right_reads = 0;
    int dust_reads = 0;

    // Everything sent to the Motor and the Cleaner, in order.
    std::vector<Direction> motor;
    std::vector<Clean> cleaner;

    // Every hardware call, in order: "front", "left", "right", "dust",
    // "tick", "motor", "cleaner".
    std::vector<std::string> calls;

    // wait_for_tick: number of Ticks delivered so far.
    int ticks = 0;
    // When ticks_to_deliver >= 0, the call after that many Ticks jumps to
    // `power_off` instead of returning. This ends the endless loop of main().
    int ticks_to_deliver = -1;
    std::jmp_buf power_off;
    // Called just before each Tick is delivered, with the Tick number (1-based).
    std::function<void(int)> before_tick;
};

extern FakeHw fake_hw;

// Puts the fake back into its default condition.
void ResetFakeHw();

#endif  // FAKE_HW_H
