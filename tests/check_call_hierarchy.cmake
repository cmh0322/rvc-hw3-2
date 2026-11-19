# Compares the calls GCC recorded for the production code (-fcallgraph-info,
# *.ci files) with the calls of the approved Structure Chart.
#
# usage: cmake -DOBJECT_DIR=<build>/CMakeFiles -DEXPECTED=<expected_calls.txt>
#              -P check_call_hierarchy.cmake
if(NOT OBJECT_DIR OR NOT EXPECTED)
    message(FATAL_ERROR "OBJECT_DIR and EXPECTED are required")
endif()

# Calls in the compiled code. main.c is taken from rvc_main, where main() keeps its name.
file(GLOB_RECURSE ci_files "${OBJECT_DIR}/rvc_control.dir/*.ci" "${OBJECT_DIR}/rvc_main.dir/*.ci")
if(NOT ci_files)
    message(FATAL_ERROR "No call graph files (*.ci) found under ${OBJECT_DIR}")
endif()

set(actual "")
foreach(ci_file IN LISTS ci_files)
    # Ninja may retain .ci files for sources removed since an earlier configure.
    # All production sources of these targets are src/*.c (CMakeLists.txt).
    get_filename_component(ci_name "${ci_file}" NAME)
    string(REGEX REPLACE "\\.ci$" "" source_name "${ci_name}")
    if(NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/../src/${source_name}")
        continue()
    endif()
    file(STRINGS "${ci_file}" edges REGEX "^edge:" ENCODING UTF-8)
    foreach(edge IN LISTS edges)
        # Calls from compiler-generated helpers (coverage setup) have a path as
        # their source name and do not match.
        if(edge MATCHES "sourcename: \"([A-Za-z0-9_]+)\" targetname: \"([A-Za-z0-9_]+)\"")
            set(caller "${CMAKE_MATCH_1}")
            set(callee "${CMAKE_MATCH_2}")
            if(NOT callee MATCHES "^__")
                list(APPEND actual "${caller} -> ${callee}")
            endif()
        endif()
    endforeach()
endforeach()
list(REMOVE_DUPLICATES actual)

# Calls in the Structure Chart.
set(expected "")
file(STRINGS "${EXPECTED}" lines)
foreach(line IN LISTS lines)
    if(line MATCHES "^([A-Za-z0-9_]+) +([A-Za-z0-9_]+)$")
        list(APPEND expected "${CMAKE_MATCH_1} -> ${CMAKE_MATCH_2}")
    endif()
endforeach()

set(missing ${expected})
list(REMOVE_ITEM missing ${actual})
set(unexpected ${actual})
list(REMOVE_ITEM unexpected ${expected})

list(LENGTH expected expected_count)
list(LENGTH actual actual_count)
if(missing OR unexpected)
    string(REPLACE ";" "\n  " missing_text "${missing}")
    string(REPLACE ";" "\n  " unexpected_text "${unexpected}")
    message(FATAL_ERROR
        "Call hierarchy differs from the Structure Chart.\n"
        "In the chart but not in the code:\n  ${missing_text}\n"
        "In the code but not in the chart:\n  ${unexpected_text}")
endif()
message(STATUS "Call hierarchy matches the Structure Chart: ${actual_count} of ${expected_count} calls.")
