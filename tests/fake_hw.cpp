#include "fake_hw.h"
FakeHw fake_hw;
void ResetFakeHw() { fake_hw = FakeHw{}; }
extern "C" {
InputEvent receive_input_event(InputMode mode) {
    InputEvent event;
    if (mode == INPUT_INITIAL_SENSORS && !fake_hw.initial_events.empty()) {
        event=fake_hw.initial_events.front(); fake_hw.initial_events.pop_front();
    } else if (mode == INPUT_INITIAL_SENSORS) {
        const bool values[]={fake_hw.front,fake_hw.left,fake_hw.right,fake_hw.dust};
        int index=fake_hw.initial_index++ % 4;
        event={static_cast<InputKind>(index), values[index]};
    } else if (!fake_hw.events.empty()) {
        event=fake_hw.events.front(); fake_hw.events.pop_front();
    } else {
        if (fake_hw.scripted || (fake_hw.running_index==0 &&
            fake_hw.ticks_to_deliver>=0 && fake_hw.ticks==fake_hw.ticks_to_deliver))
            std::longjmp(fake_hw.power_off,1);
        if(fake_hw.running_index==0 && fake_hw.before_tick)
            fake_hw.before_tick(fake_hw.ticks+1);
        const bool values[]={fake_hw.front,fake_hw.left,fake_hw.right,fake_hw.dust,false};
        int index=fake_hw.running_index;
        fake_hw.running_index=(index+1)%5;
        event={static_cast<InputKind>(index),values[index]};
    }
    const char *names[]={"front","left","right","dust","tick"};
    fake_hw.calls.push_back(names[event.kind]);
    switch(event.kind) {
    case INPUT_FRONT: ++fake_hw.front_reads; break;
    case INPUT_LEFT: ++fake_hw.left_reads; break;
    case INPUT_RIGHT: ++fake_hw.right_reads; break;
    case INPUT_DUST: ++fake_hw.dust_reads; break;
    case INPUT_TICK: ++fake_hw.ticks; break;
    }
    return event;
}
void drive_motor(Direction direction) {
    fake_hw.motor.push_back(direction); fake_hw.calls.push_back("motor");
    if(fake_hw.on_motor) fake_hw.on_motor();
}
void drive_cleaner(Clean clean) {
    fake_hw.cleaner.push_back(clean); fake_hw.calls.push_back("cleaner");
}
}
