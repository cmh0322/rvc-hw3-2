#include "rvc_system_fixture.h"
namespace {
class ControllerTest : public RvcSystemTest {};
TEST_F(ControllerTest, OneTickOutputsMovementThenCleanWithoutPolling) {
    SetSensors(false,false,false,false); controller();
    EXPECT_EQ((std::vector<std::string>{"motor","cleaner"}),fake_hw.calls);
    EXPECT_EQ(0,fake_hw.front_reads+fake_hw.left_reads+fake_hw.right_reads+fake_hw.dust_reads);
}
TEST_F(ControllerTest, CurrentStateAndStoredInputsDriveTheTick) {
    SetSensors(false,false,false,true); ExpectCycles(1,DIRECTION_FORWARD,CLEAN_POWER_UP);
    SetObstacles(true,false,false); ExpectCycles(1,DIRECTION_STOP,CLEAN_STOP);
}
}
