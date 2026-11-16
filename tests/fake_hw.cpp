#include "fake_hw.h"

FakeHw fake_hw;

void ResetFakeHw() {
    fake_hw.front = false;
    fake_hw.left = false;
    fake_hw.right = false;
    fake_hw.dust = false;
    fake_hw.front_reads = 0;
    fake_hw.left_reads = 0;
    fake_hw.right_reads = 0;
    fake_hw.dust_reads = 0;
    fake_hw.motor.clear();
    fake_hw.cleaner.clear();
    fake_hw.calls.clear();
    fake_hw.ticks = 0;
    fake_hw.ticks_to_deliver = -1;
    fake_hw.before_tick = nullptr;
}

extern "C" {

bool read_front_sensor(void) {
    ++fake_hw.front_reads;
    fake_hw.calls.push_back("front");
    return fake_hw.front;
}

bool read_left_sensor(void) {
    ++fake_hw.left_reads;
    fake_hw.calls.push_back("left");
    return fake_hw.left;
}

bool read_right_sensor(void) {
    ++fake_hw.right_reads;
    fake_hw.calls.push_back("right");
    return fake_hw.right;
}

bool read_dust_sensor(void) {
    ++fake_hw.dust_reads;
    fake_hw.calls.push_back("dust");
    return fake_hw.dust;
}

void wait_for_tick(void) {
    if (fake_hw.ticks_to_deliver >= 0 && fake_hw.ticks == fake_hw.ticks_to_deliver) {
        std::longjmp(fake_hw.power_off, 1);
    }
    ++fake_hw.ticks;
    if (fake_hw.before_tick) {
        fake_hw.before_tick(fake_hw.ticks);
    }
    fake_hw.calls.push_back("tick");
}

void drive_motor(Direction direction) {
    fake_hw.motor.push_back(direction);
    fake_hw.calls.push_back("motor");
}

void drive_cleaner(Clean clean) {
    fake_hw.cleaner.push_back(clean);
    fake_hw.calls.push_back("cleaner");
}

}  // extern "C"
