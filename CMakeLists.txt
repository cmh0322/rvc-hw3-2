cmake_minimum_required(VERSION 3.20)
project(rvc LANGUAGES C CXX)

# Production code is C11, compiled with GCC. Tests are C++ with GoogleTest.
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(RVC_COVERAGE "Instrument the C code for gcov line and branch coverage" ON)

set(RVC_C_WARNINGS -Wall -Wextra -Wpedantic -Werror)
if(RVC_COVERAGE)
    set(RVC_COVERAGE_FLAGS --coverage -O0 -g)
endif()

# GCC 10 and later can write the call graph of each object file (.ci files).
# The call_hierarchy test compares it with the Structure Chart.
include(CheckCCompilerFlag)
check_c_compiler_flag(-fcallgraph-info RVC_HAS_CALLGRAPH_INFO)
if(RVC_HAS_CALLGRAPH_INFO)
    set(RVC_CALLGRAPH_FLAGS -fcallgraph-info)
endif()

# ---------------------------------------------------------------------------
# Production code: one source file per Structure Chart module or hidden-data
# group. The hardware interface (include/hw_interface.h) is declared only; its
# implementation is outside this design (requirement B6).
# ---------------------------------------------------------------------------
file(GLOB RVC_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c")
list(FILTER RVC_SOURCES EXCLUDE REGEX "/main\\.c$")

add_library(rvc_control STATIC ${RVC_SOURCES})
target_include_directories(rvc_control PUBLIC include)
target_compile_options(rvc_control PRIVATE ${RVC_C_WARNINGS} ${RVC_COVERAGE_FLAGS} ${RVC_CALLGRAPH_FLAGS})

# Main, the root module. It is compiled here but not linked into an executable:
# an executable also needs an implementation of the hardware interface.
add_library(rvc_main OBJECT src/main.c)
target_include_directories(rvc_main PRIVATE include)
target_compile_options(rvc_main PRIVATE ${RVC_C_WARNINGS} ${RVC_CALLGRAPH_FLAGS})

# ---------------------------------------------------------------------------
# Unit tests
# ---------------------------------------------------------------------------
enable_testing()
find_package(GTest REQUIRED)
include(GoogleTest)

# The same main.c, with main() renamed to rvc_main() so that a test can call it.
add_library(rvc_main_under_test OBJECT src/main.c)
target_include_directories(rvc_main_under_test PRIVATE include)
target_compile_definitions(rvc_main_under_test PRIVATE main=rvc_main)
target_compile_options(rvc_main_under_test PRIVATE ${RVC_C_WARNINGS} ${RVC_COVERAGE_FLAGS})

file(GLOB RVC_TEST_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp")
add_executable(rvc_tests ${RVC_TEST_SOURCES})
target_link_libraries(rvc_tests PRIVATE rvc_main_under_test rvc_control GTest::gtest GTest::gtest_main)
if(RVC_COVERAGE)
    target_link_options(rvc_tests PRIVATE --coverage)
endif()
gtest_discover_tests(rvc_tests DISCOVERY_MODE PRE_TEST)

# The implemented call hierarchy must match the approved Structure Chart.
if(RVC_HAS_CALLGRAPH_INFO)
    add_test(NAME call_hierarchy
        COMMAND ${CMAKE_COMMAND}
            -DOBJECT_DIR=${CMAKE_BINARY_DIR}/CMakeFiles
            -DEXPECTED=${CMAKE_CURRENT_SOURCE_DIR}/tests/expected_calls.txt
            -P ${CMAKE_CURRENT_SOURCE_DIR}/tests/check_call_hierarchy.cmake)
endif()

# ---------------------------------------------------------------------------
# Coverage: "cmake --build <build> --target coverage" runs the tests and
# writes <build>/coverage/summary.md.
# ---------------------------------------------------------------------------
if(RVC_COVERAGE)
    get_filename_component(RVC_COMPILER_DIR "${CMAKE_C_COMPILER}" DIRECTORY)
    find_program(RVC_GCOV gcov HINTS "${RVC_COMPILER_DIR}" NO_DEFAULT_PATH)
    find_program(RVC_GCOV gcov)
    add_custom_target(coverage
        COMMAND ${CMAKE_COMMAND}
            -DBUILD_DIR=${CMAKE_BINARY_DIR}
            -DGCOV=${RVC_GCOV}
            -DCTEST=${CMAKE_CTEST_COMMAND}
            -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/coverage.cmake
        DEPENDS rvc_tests rvc_main
        VERBATIM)
endif()
