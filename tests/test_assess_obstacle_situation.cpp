// Module: Assess Obstacle Situation (SA Process 3.1)
// Source: Process Specification 3.1; requirements B3, B4, C1; assumption Q6.
#include <gtest/gtest.h>

#include "assess_obstacle_situation.h"

namespace {

ObstacleLocation Location(bool front, bool left, bool right) {
    ObstacleLocation location;
    location.front_obstacle = front;
    location.left_obstacle = left;
    location.right_obstacle = right;
    return location;
}

// Q6 assumption: left and right are ignored while the front is clear.
TEST(AssessObstacleSituation, FrontClearIsClearWhateverTheSides) {
    EXPECT_EQ(OBSTACLE_SITUATION_CLEAR, assess_obstacle_situation(Location(false, false, false)));
    EXPECT_EQ(OBSTACLE_SITUATION_CLEAR, assess_obstacle_situation(Location(false, true, false)));
    EXPECT_EQ(OBSTACLE_SITUATION_CLEAR, assess_obstacle_situation(Location(false, false, true)));
    EXPECT_EQ(OBSTACLE_SITUATION_CLEAR, assess_obstacle_situation(Location(false, true, true)));
}

// C1: with a front obstacle and both sides clear, right has priority.
TEST(AssessObstacleSituation, FrontBlockedBothSidesClearIsRightOpen) {
    EXPECT_EQ(OBSTACLE_SITUATION_RIGHT_OPEN, assess_obstacle_situation(Location(true, false, false)));
}

// B3: front and left blocked, right clear.
TEST(AssessObstacleSituation, FrontAndLeftBlockedIsRightOpen) {
    EXPECT_EQ(OBSTACLE_SITUATION_RIGHT_OPEN, assess_obstacle_situation(Location(true, true, false)));
}

// B3: front and right blocked, left clear.
TEST(AssessObstacleSituation, FrontAndRightBlockedIsLeftOpen) {
    EXPECT_EQ(OBSTACLE_SITUATION_LEFT_OPEN, assess_obstacle_situation(Location(true, false, true)));
}

// B4: obstacles in front, left, and right.
TEST(AssessObstacleSituation, FrontLeftAndRightBlockedIsAllBlocked) {
    EXPECT_EQ(OBSTACLE_SITUATION_ALL_BLOCKED, assess_obstacle_situation(Location(true, true, true)));
}

}  // namespace
