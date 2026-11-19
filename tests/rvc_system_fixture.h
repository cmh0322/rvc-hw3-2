#include "test_input_helpers.h"
// Fixture for tests that drive the whole system through Controller, one call
// per Tick, with the fake hardware as the only test double.
#ifndef RVC_SYSTEM_FIXTURE_H
#define RVC_SYSTEM_FIXTURE_H

#include <gtest/gtest.h>

#include "controller.h"
#include "fake_hw.h"
#include "initialize_rvc.h"

class RvcSystemTest : public ::testing::Test {
protected:
    // Initialize real samples, then begin Tick-level output assertions.
    void SetUp() override {
        ResetFakeHw();
        initialize_rvc();
        ResetFakeHw();
    }

    static void SetSensors(bool front, bool left, bool right, bool dust) {
        fake_hw.front = front;
        fake_hw.left = left;
        fake_hw.right = right;
        fake_hw.dust = dust;
        Observe(front,left,right,dust);
    }

    static void SetObstacles(bool front, bool left, bool right) {
        fake_hw.front = front;
        fake_hw.left = left;
        fake_hw.right = right;
        dispatch_sensor_input({INPUT_FRONT,front});
        dispatch_sensor_input({INPUT_LEFT,left});
        dispatch_sensor_input({INPUT_RIGHT,right});
    }

    // Runs `count` cycles (Ticks) and expects each to send exactly one
    // `direction` to the Motor and one `clean` to the Cleaner.
    static void ExpectCycles(int count, Direction direction, Clean clean) {
        for (int cycle = 1; cycle <= count; ++cycle) {
            const size_t motor_before = fake_hw.motor.size();
            const size_t cleaner_before = fake_hw.cleaner.size();
            controller();
            ASSERT_EQ(motor_before + 1, fake_hw.motor.size()) << "cycle " << cycle << " of " << count;
            ASSERT_EQ(cleaner_before + 1, fake_hw.cleaner.size()) << "cycle " << cycle << " of " << count;
            EXPECT_EQ(direction, fake_hw.motor.back()) << "cycle " << cycle << " of " << count;
            EXPECT_EQ(clean, fake_hw.cleaner.back()) << "cycle " << cycle << " of " << count;
        }
    }
};

#endif  // RVC_SYSTEM_FIXTURE_H
