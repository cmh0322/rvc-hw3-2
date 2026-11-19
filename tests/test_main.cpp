#include "test_input_helpers.h"
#include "fake_hw.h"
#include "movement_controller.h"
#include <gtest/gtest.h>
extern "C" int rvc_main(void);
class MainTest : public ::testing::Test {
protected:
    void SetUp() override {ResetFakeHw();}
    static void Run(int ticks) {
        fake_hw.ticks_to_deliver=ticks;
        if(setjmp(fake_hw.power_off)==0) {rvc_main(); ADD_FAILURE()<<"Main returned";}
    }
};
TEST_F(MainTest, InitialSamplesBeforeAnyTickAndNoOutputs) {
    Run(0); EXPECT_EQ(0,fake_hw.ticks); EXPECT_TRUE(fake_hw.motor.empty());
    EXPECT_TRUE(fake_hw.cleaner.empty()); EXPECT_EQ(1,fake_hw.front_reads);
    EXPECT_EQ(1,fake_hw.left_reads); EXPECT_EQ(1,fake_hw.right_reads); EXPECT_EQ(1,fake_hw.dust_reads);
}
TEST_F(MainTest, OneCyclePerTickAndBlockedFirstTickStops) {
    fake_hw.front=true; Run(6);
    EXPECT_EQ((std::vector<Direction>{DIRECTION_STOP,DIRECTION_STOP,DIRECTION_STOP,
        DIRECTION_STOP,DIRECTION_STOP,DIRECTION_TURN_RIGHT}),fake_hw.motor);
    EXPECT_EQ(6u,fake_hw.cleaner.size());
}
TEST_F(MainTest, ReceiptOrderBeforeAndAfterTickIsRespected) {
    fake_hw.scripted=true;
    fake_hw.events={{INPUT_TICK,false},{INPUT_DUST,true},{INPUT_DUST,false},
        {INPUT_TICK,false},{INPUT_TICK,false}};
    Run(0);
    EXPECT_EQ((std::vector<Clean>{CLEAN_START,CLEAN_POWER_UP,CLEAN_POWER_UP}),fake_hw.cleaner);
    EXPECT_EQ(3,fake_hw.ticks);
}
TEST_F(MainTest, InitialPulseSurvivesUntilFirstForwardTick) {
    fake_hw.initial_events={{INPUT_DUST,true},{INPUT_DUST,false},{INPUT_FRONT,false},
        {INPUT_LEFT,false},{INPUT_RIGHT,false}};
    Run(1); EXPECT_EQ((std::vector<Clean>{CLEAN_POWER_UP}),fake_hw.cleaner);
}
TEST_F(MainTest, EventsReceivedDuringOutputWaitForNextTick) {
    fake_hw.scripted=true; fake_hw.events={{INPUT_TICK,false}};
    fake_hw.on_motor=[] {
        if(fake_hw.motor.size()==1) {
            fake_hw.events.push_back({INPUT_DUST,true});
            fake_hw.events.push_back({INPUT_DUST,false});
            fake_hw.events.push_back({INPUT_TICK,false});
        }
    };
    Run(0); EXPECT_EQ((std::vector<Clean>{CLEAN_START,CLEAN_POWER_UP}),fake_hw.cleaner);
}
TEST_F(MainTest, ManyQueuedPulsesAreNotDroppedOrAccumulated) {
    fake_hw.scripted=true;
    for(int i=0;i<100;i++) {fake_hw.events.push_back({INPUT_DUST,true});fake_hw.events.push_back({INPUT_DUST,false});}
    for(int i=0;i<6;i++) fake_hw.events.push_back({INPUT_TICK,false});
    Run(0);
    EXPECT_EQ((std::vector<Clean>{CLEAN_POWER_UP,CLEAN_POWER_UP,CLEAN_POWER_UP,
        CLEAN_POWER_UP,CLEAN_POWER_UP,CLEAN_START}),fake_hw.cleaner);
}
