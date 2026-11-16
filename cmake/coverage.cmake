# Runs the tests and measures line and branch coverage of the C code with gcov.
# Writes <build>/coverage/summary.md and prints it.
#
# usage: cmake -DBUILD_DIR=<build> -DGCOV=<gcov> -DCTEST=<ctest> -P cmake/coverage.cmake
if(NOT BUILD_DIR OR NOT GCOV OR NOT CTEST)
    message(FATAL_ERROR "BUILD_DIR, GCOV, and CTEST are required")
endif()

# Start from zero: remove the data of earlier runs.
file(GLOB_RECURSE old_data "${BUILD_DIR}/*.gcda")
if(old_data)
    file(REMOVE ${old_data})
endif()

# The test program writes its coverage data to the object file paths recorded
# at compile time. On Windows that fails when the path has non-ASCII characters.
# GCOV_PREFIX and GCOV_PREFIX_STRIP make it write to the same place through a
# path it can open: strip every directory level of the build directory (and the
# drive, which counts as one level), then put the build directory back in front.
string(REGEX MATCHALL "/" slashes "${BUILD_DIR}")
list(LENGTH slashes strip)
if(BUILD_DIR MATCHES "^[A-Za-z]:")
    math(EXPR strip "${strip} + 1")
endif()

execute_process(
    COMMAND "${CMAKE_COMMAND}" -E env "GCOV_PREFIX=${BUILD_DIR}" "GCOV_PREFIX_STRIP=${strip}"
            "${CTEST}" --test-dir "${BUILD_DIR}" --output-on-failure
    RESULT_VARIABLE test_result
    OUTPUT_VARIABLE test_output
    ERROR_VARIABLE test_output)
if(test_result)
    message(FATAL_ERROR "Tests failed; coverage was not measured.\n${test_output}")
endif()

file(GLOB_RECURSE data_files
    "${BUILD_DIR}/CMakeFiles/rvc_control.dir/*.gcda"
    "${BUILD_DIR}/CMakeFiles/rvc_main_under_test.dir/*.gcda")
if(NOT data_files)
    message(FATAL_ERROR "The tests wrote no coverage data (*.gcda) under ${BUILD_DIR}")
endif()
list(SORT data_files)

set(rows "")
set(notes "")
set(total_lines 0)
set(total_lines_hit 0)
set(total_branches 0)
set(total_branches_hit 0)

foreach(data_file IN LISTS data_files)
    execute_process(
        COMMAND "${GCOV}" -b --json-format --stdout "${data_file}"
        OUTPUT_VARIABLE json
        ERROR_QUIET
        ENCODING UTF-8
        RESULT_VARIABLE gcov_result)
    if(gcov_result)
        message(FATAL_ERROR "gcov failed for ${data_file}")
    endif()
    # The working directory is not needed, and its backslashes do not survive
    # a non-ASCII path on Windows.
    string(REGEX REPLACE "\"current_working_directory\": \"[^\"]*\", " "" json "${json}")

    string(JSON source_path GET "${json}" files 0 file)
    get_filename_component(source_name "${source_path}" NAME)
    string(JSON line_count LENGTH "${json}" files 0 lines)

    set(lines 0)
    set(lines_hit 0)
    set(branches 0)
    set(branches_hit 0)
    set(missed_lines "")
    set(missed_branch_lines "")

    math(EXPR last_line "${line_count} - 1")
    foreach(i RANGE 0 ${last_line})
        string(JSON number GET "${json}" files 0 lines ${i} line_number)
        string(JSON count GET "${json}" files 0 lines ${i} count)
        math(EXPR lines "${lines} + 1")
        if(count GREATER 0)
            math(EXPR lines_hit "${lines_hit} + 1")
        else()
            list(APPEND missed_lines ${number})
        endif()

        string(JSON branch_count LENGTH "${json}" files 0 lines ${i} branches)
        if(branch_count GREATER 0)
            math(EXPR last_branch "${branch_count} - 1")
            foreach(b RANGE 0 ${last_branch})
                string(JSON taken GET "${json}" files 0 lines ${i} branches ${b} count)
                math(EXPR branches "${branches} + 1")
                if(taken GREATER 0)
                    math(EXPR branches_hit "${branches_hit} + 1")
                else()
                    list(APPEND missed_branch_lines ${number})
                endif()
            endforeach()
        endif()
    endforeach()

    string(APPEND rows "| ${source_name} | ${lines_hit} / ${lines} | ${branches_hit} / ${branches} |\n")
    if(missed_lines)
        string(REPLACE ";" ", " text "${missed_lines}")
        string(APPEND notes "- ${source_name}: lines not executed: ${text}\n")
    endif()
    if(missed_branch_lines)
        list(REMOVE_DUPLICATES missed_branch_lines)
        string(REPLACE ";" ", " text "${missed_branch_lines}")
        string(APPEND notes "- ${source_name}: branch outcomes not taken on lines: ${text}\n")
    endif()

    math(EXPR total_lines "${total_lines} + ${lines}")
    math(EXPR total_lines_hit "${total_lines_hit} + ${lines_hit}")
    math(EXPR total_branches "${total_branches} + ${branches}")
    math(EXPR total_branches_hit "${total_branches_hit} + ${branches_hit}")
endforeach()

# Percentages with one decimal, by integer arithmetic.
function(percent hit total out)
    if(total EQUAL 0)
        set(${out} "n/a" PARENT_SCOPE)
        return()
    endif()
    math(EXPR tenths "(${hit} * 1000) / ${total}")
    math(EXPR whole "${tenths} / 10")
    math(EXPR fraction "${tenths} % 10")
    set(${out} "${whole}.${fraction}%" PARENT_SCOPE)
endfunction()
percent(${total_lines_hit} ${total_lines} line_percent)
percent(${total_branches_hit} ${total_branches} branch_percent)

if(NOT notes)
    set(notes "- None: every line was executed and every branch outcome was taken.\n")
endif()

set(summary
"# Coverage Summary

Measured with gcov on the C production code. A branch counts as covered when
that outcome was taken at least once.

| Source file | Lines executed | Branch outcomes taken |
|---|---|---|
${rows}| **Total** | **${total_lines_hit} / ${total_lines} (${line_percent})** | **${total_branches_hit} / ${total_branches} (${branch_percent})** |

## Uncovered code

${notes}")

file(MAKE_DIRECTORY "${BUILD_DIR}/coverage")
file(WRITE "${BUILD_DIR}/coverage/summary.md" "${summary}")
message("${summary}")
