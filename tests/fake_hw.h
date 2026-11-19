#ifndef FAKE_HW_H
#define FAKE_HW_H
#include <csetjmp>
#include <deque>
#include <functional>
#include <string>
#include <vector>
#include "hw_interface.h"
struct FakeHw {
    bool front=false,left=false,right=false,dust=false;
    int front_reads=0,left_reads=0,right_reads=0,dust_reads=0;
    std::vector<Direction> motor;
    std::vector<Clean> cleaner;
    std::vector<std::string> calls;
    int ticks=0,ticks_to_deliver=-1,initial_index=0,running_index=0;
    std::jmp_buf power_off;
    std::function<void(int)> before_tick;
    std::function<void()> on_motor;
    std::deque<InputEvent> initial_events,events;
    bool scripted=false;
};
extern FakeHw fake_hw;
void ResetFakeHw();
#endif
