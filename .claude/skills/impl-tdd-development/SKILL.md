---
name: impl-tdd-development
description: Perform requirement-driven TDD for RVC.
---

# TDD Development

## Inputs
- docs/preliminary_requirements.md
- docs/requirements_clarifications.md
- artifacts/SA/event_list.md
- artifacts/SA/DFD/dfd_level_4_fsm.md
- artifacts/SA/process_specification.md
- artifacts/SD/structure_chart.md
- artifacts/SA/data_dictionary.md

## Test Environment
- Use GoogleTest as the unit testing framework.
- Write unit tests in C++ using GoogleTest.
- Keep production code in C11.
- Use CMake to configure and build the project.
- Use GCC for C code and G++ for GoogleTest.
- Use CTest to execute the test suite.
- Enable coverage instrumentation for C code.

## Test Design
1. Identify testable requirements.
2. Extract events and expected responses
   from the Event List.
3. Derive state transition tests from FSM.
4. Derive functional tests from
   Process Specifications.
5. Define expected outputs for each test.
6. Maintain requirement-to-test traceability.


## Testing Constraints
- Use GoogleTest for unit testing.
- Use CMake for build configuration.
- Keep production code in C11.
- Write GoogleTest code in C++.
- Use CTest for test execution.

## TDD Workflow
1. Write a failing test using GoogleTest (RED).
2. Build the test using CMake.
3. Run the test using CTest and verify
   that it fails for the expected reason.
4. Implement minimal C11 code (GREEN).
5. Rebuild using CMake and run CTest.
6. Verify that the test passes.
7. Refactor the implementation.
8. Rerun all affected tests.
9. Repeat until required behavior is implemented.

## Test Coverage
- Measure line coverage.
- Measure branch coverage.
- Identify uncovered code.
- Add tests for missing behaviors.
- Generate a coverage report.

## Completion Criteria
- All required tests pass.
- Test coverage is reported.
- Every requirement has corresponding
  verification evidence.
- Human approval is obtained.
