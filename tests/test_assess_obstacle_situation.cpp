// Module: Assess Obstacle Situation (SA Process 3.1)
// Source: Process Specification 3.1; requirements B3, B4, C1, C9.
#include <gtest/gtest.h>

#include "assess_obstacle_situation.h"
#include "situations.h"

namespace {

ObstacleLocation Location(bool front, bool left, bool right) {
    ObstacleLocation location;
    location.front_obstacle = front;
    location.left_obstacle = left;
    location.right_obstacle = right;
    return location;
}

TEST(AssessObstacleSituation, ReportsWhetherTheFrontIsBlocked) {
    EXPECT_FALSE(assess_obstacle_situation(Location(false, false, false)).front_blocked);
    EXPECT_FALSE(assess_obstacle_situation(Location(false, true, true)).front_blocked);
    EXPECT_TRUE(assess_obstacle_situation(Location(true, false, false)).front_blocked);
    EXPECT_TRUE(assess_obstacle_situation(Location(true, true, true)).front_blocked);
}

// C1: with both sides clear, right has priority.
TEST(AssessObstacleSituation, BothSidesClearIsRightOpen) {
    EXPECT_EQ(kRightOpen, assess_obstacle_situation(Location(true, false, false)));
}

// B3: left blocked, right clear.
TEST(AssessObstacleSituation, LeftBlockedIsRightOpen) {
    EXPECT_EQ(kRightOpen, assess_obstacle_situation(Location(true, true, false)));
}

// B3: right blocked, left clear.
TEST(AssessObstacleSituation, RightBlockedIsLeftOpen) {
    EXPECT_EQ(kLeftOpen, assess_obstacle_situation(Location(true, false, true)));
}

// B4: obstacles in front, left, and right.
TEST(AssessObstacleSituation, FrontLeftAndRightBlockedIsAllBlocked) {
    EXPECT_EQ(kAllBlocked, assess_obstacle_situation(Location(true, true, true)));
}

// C9: the sides are classified even when the front is clear, so that the
// decision after moving backward can use left and right only.
TEST(AssessObstacleSituation, SidesAreClassifiedWhenTheFrontIsClear) {
    EXPECT_EQ(kClear, assess_obstacle_situation(Location(false, false, false)));
    EXPECT_EQ(kClear, assess_obstacle_situation(Location(false, true, false)));
    EXPECT_EQ(kFrontClearLeftOpen, assess_obstacle_situation(Location(false, false, true)));
    EXPECT_EQ(kFrontClearSidesBlocked, assess_obstacle_situation(Location(false, true, true)));
}

}  // namespace
