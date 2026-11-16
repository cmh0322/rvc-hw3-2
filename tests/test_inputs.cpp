// Input branch: Detect Obstacle (SA Process 1), Detect Dust (SA Process 2),
// Get Inputs (afferent coordinator)
// Source: Process Specifications 1 and 2; Structure Chart sections 3.4 and 5;
// requirements B3, B4, B5, C1.
#include <algorithm>
#include <string>
#include <vector>

#include <gtest/gtest.h>

#include "detect_dust.h"
#include "detect_obstacle.h"
#include "fake_hw.h"
#include "get_inputs.h"

namespace {

class InputsTest : public ::testing::Test {
protected:
    void SetUp() override { ResetFakeHw(); }

    static void SetObstacleSensors(bool front, bool left, bool right) {
        fake_hw.front = front;
        fake_hw.left = left;
        fake_hw.right = right;
    }
};

// ---- Detect Obstacle --------------------------------------------------------

TEST_F(InputsTest, DetectObstacle_ReportsNoObstacleWhenNoSensorDetectsOne) {
    SetObstacleSensors(false, false, false);
    const ObstacleLocation location = detect_obstacle();
    EXPECT_FALSE(location.front_obstacle);
    EXPECT_FALSE(location.left_obstacle);
    EXPECT_FALSE(location.right_obstacle);
}

TEST_F(InputsTest, DetectObstacle_CopiesTheFrontSensorToTheFrontField) {
    SetObstacleSensors(true, false, false);
    const ObstacleLocation location = detect_obstacle();
    EXPECT_TRUE(location.front_obstacle);
    EXPECT_FALSE(location.left_obstacle);
    EXPECT_FALSE(location.right_obstacle);
}

TEST_F(InputsTest, DetectObstacle_CopiesTheLeftSensorToTheLeftField) {
    SetObstacleSensors(false, true, false);
    const ObstacleLocation location = detect_obstacle();
    EXPECT_FALSE(location.front_obstacle);
    EXPECT_TRUE(location.left_obstacle);
    EXPECT_FALSE(location.right_obstacle);
}

TEST_F(InputsTest, DetectObstacle_CopiesTheRightSensorToTheRightField) {
    SetObstacleSensors(false, false, true);
    const ObstacleLocation location = detect_obstacle();
    EXPECT_FALSE(location.front_obstacle);
    EXPECT_FALSE(location.left_obstacle);
    EXPECT_TRUE(location.right_obstacle);
}

TEST_F(InputsTest, DetectObstacle_ReadsEachObstacleSensorOnceAndNotTheDustSensor) {
    detect_obstacle();
    EXPECT_EQ(1, fake_hw.front_reads);
    EXPECT_EQ(1, fake_hw.left_reads);
    EXPECT_EQ(1, fake_hw.right_reads);
    EXPECT_EQ(0, fake_hw.dust_reads);
}

// ---- Detect Dust ------------------------------------------------------------

TEST_F(InputsTest, DetectDust_ReportsDustWhenTheSensorDetectsIt) {
    fake_hw.dust = true;
    EXPECT_TRUE(detect_dust());
}

TEST_F(InputsTest, DetectDust_ReportsNoDustWhenTheSensorDetectsNone) {
    fake_hw.dust = false;
    EXPECT_FALSE(detect_dust());
}

TEST_F(InputsTest, DetectDust_ReadsOnlyTheDustSensorOnce) {
    detect_dust();
    EXPECT_EQ(1, fake_hw.dust_reads);
    EXPECT_EQ(0, fake_hw.front_reads + fake_hw.left_reads + fake_hw.right_reads);
}

// ---- Get Inputs -------------------------------------------------------------

TEST_F(InputsTest, GetInputs_ClearPathAndNoDust) {
    SetObstacleSensors(false, false, false);
    fake_hw.dust = false;
    const Inputs inputs = get_inputs();
    EXPECT_EQ(OBSTACLE_SITUATION_CLEAR, inputs.obstacle_situation);
    EXPECT_FALSE(inputs.dust_existence);
}

TEST_F(InputsTest, GetInputs_ReturnsTheSituationAssessedFromTheSensors) {
    SetObstacleSensors(true, true, false);
    EXPECT_EQ(OBSTACLE_SITUATION_RIGHT_OPEN, get_inputs().obstacle_situation);

    SetObstacleSensors(true, false, true);
    EXPECT_EQ(OBSTACLE_SITUATION_LEFT_OPEN, get_inputs().obstacle_situation);

    SetObstacleSensors(true, true, true);
    EXPECT_EQ(OBSTACLE_SITUATION_ALL_BLOCKED, get_inputs().obstacle_situation);
}

TEST_F(InputsTest, GetInputs_ReturnsTheDustExistence) {
    fake_hw.dust = true;
    EXPECT_TRUE(get_inputs().dust_existence);
}

TEST_F(InputsTest, GetInputs_DustAndObstaclesAreReportedIndependently) {
    SetObstacleSensors(true, true, true);
    fake_hw.dust = true;
    const Inputs inputs = get_inputs();
    EXPECT_EQ(OBSTACLE_SITUATION_ALL_BLOCKED, inputs.obstacle_situation);
    EXPECT_TRUE(inputs.dust_existence);
}

// Structure Chart, design decision 1: every sensor is read once per cycle.
TEST_F(InputsTest, GetInputs_ReadsEverySensorExactlyOnce) {
    get_inputs();
    EXPECT_EQ(1, fake_hw.front_reads);
    EXPECT_EQ(1, fake_hw.left_reads);
    EXPECT_EQ(1, fake_hw.right_reads);
    EXPECT_EQ(1, fake_hw.dust_reads);
}

// Structure Chart 3.1: Detect Obstacle is called before Detect Dust.
TEST_F(InputsTest, GetInputs_ReadsTheObstacleSensorsBeforeTheDustSensor) {
    get_inputs();
    ASSERT_EQ(4u, fake_hw.calls.size());
    EXPECT_EQ("dust", fake_hw.calls.back());
    std::vector<std::string> first_three(fake_hw.calls.begin(), fake_hw.calls.begin() + 3);
    std::sort(first_three.begin(), first_three.end());
    EXPECT_EQ((std::vector<std::string>{"front", "left", "right"}), first_three);
}

}  // namespace
