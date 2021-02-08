
# 2020y-08m-19d. Workspace project.
################################################################################
#    include("${gPATH_CMAKE_MODULE}/tools/compare_versions.cmake")
################################################################################

#
#    sort_versions(var [value1 value2...]) 
#    sort_versions(ret "1.10.x" "0.0.2" "1.1.8")
#    sort_versions_less(ret "1.10.x" "0.0.2" "1.1.8")
#    get_max_version(ver "0.0.0" ${sorted})   # RESULTAT: empty
#    get_min_version(ver "0.0.0" ${sorted})   # RESULTAT: empty
#
#  Usage:
#
#    sort_versions_min_to_max(ret1 "1.10.x" "0.0.2" "1.1.8")
#    sort_versions_max_to_min(ret2 "1.10.x" "0.0.2" "1.1.8")
#    message(STATUS "ret1: ${ret1}")
#    message(STATUS "ret2: ${ret1}")
#
#  Output: 
#
#    -- 0.0.2;1.1.8;1.10.x
#    -- 1.10.x;1.1.8;0.02
#

#...............................................................................

function(sort_versions_min_to_max var)
    # message(STATUS "arguments: ${ARGC}")
    if(${ARGC} EQUAL 1)
        return()
    endif()

    set(beg 1)
    set(end ${ARGC})
    set(swapped TRUE)
    while (swapped AND (NOT beg EQUAL ${end}) )
        set(swapped FALSE)
        math(EXPR end "${end} - 1")

        # message(STATUS "beg = ${beg}, end = ${end}, a = ${ARGV${beg}}, b = ${ARGV${end}}")  

        if(end EQUAL 1)
            break()
        endif()

        math(EXPR last "${end} - 1")
        foreach(index RANGE ${beg} ${last})              
            math(EXPR right "${index} + 1")
            set(a "${ARGV${index}}")
            set(b "${ARGV${right}}")
            compare_versions("${a}" "${b}" result_sv)
            # message(STATUS "${index})  ${a} VS ${b} -> ${result_sv}")  
            if(result_sv STREQUAL "GREATER")
                set(ARGV${index} "${b}")
                set(ARGV${right} "${a}")
                set(swapped TRUE)
            endif()
        endforeach()
        # message(STATUS " -----")  
    endwhile()

    set(answer)
    math(EXPR last "${ARGC} - 1")
    foreach(index RANGE 1 "${last}")
        list(APPEND answer "${ARGV${index}}")
    endforeach(index)
    set("${var}" "${answer}" PARENT_SCOPE)

endfunction()

################################################################################

function(sort_versions_max_to_min var)
    # message(STATUS "arguments: ${ARGC}")
    if(${ARGC} EQUAL 1)
        return()
    endif()

    set(beg 1)
    set(end ${ARGC})
    set(swapped TRUE)
    while (swapped AND (NOT beg EQUAL ${end}) )
        set(swapped FALSE)
        math(EXPR end "${end} - 1")

        # message(STATUS "beg = ${beg}, end = ${end}, a = ${ARGV${beg}}, b = ${ARGV${end}}")  

        if(end EQUAL 1)
            break()
        endif()

        math(EXPR last "${end} - 1")
        foreach(index RANGE ${beg} ${last})              
            math(EXPR right "${index} + 1")
            set(a "${ARGV${index}}")
            set(b "${ARGV${right}}")
            compare_versions("${a}" "${b}" result_sv)
            # message(STATUS "${index})  ${a} VS ${b} -> ${result_sv}")  
            if(result_sv STREQUAL "LESS")
                set(ARGV${index} "${b}")
                set(ARGV${right} "${a}")
                set(swapped TRUE)
            endif()
        endforeach()
        # message(STATUS " -----")  
    endwhile()

    set(answer)
    math(EXPR last "${ARGC} - 1")
    foreach(index RANGE 1 "${last}")
        list(APPEND answer "${ARGV${index}}")
    endforeach(index)
    set("${var}" "${answer}" PARENT_SCOPE)

endfunction()

################################################################################

function(get_min_version_from_sorted_list result ver)
    math(EXPR end "${ARGC} - 1")

    if(end EQUAL 1)
        set("${result}" "" PARENT_SCOPE)
        return()
    endif()
    if(NOT ver)
        set("${result}" "${ARGV${end}}" PARENT_SCOPE)
        return()
    endif()

    unset(re)
    foreach(index RANGE ${end} ${end})              
        set(a "${ARGV${index}}")
        compare_versions("${ver}" "${a}" result_sv)
        # message(STATUS "${index}) ${ver} VS ${a} -> ${result_sv}")  
        if(result_sv STREQUAL "GREATER")
            break()
        endif()
        set(re "${a}")
    endforeach()
    set("${result}" "${re}" PARENT_SCOPE)
endfunction()

function(get_min_version result ver)
    sort_versions_min_to_max(versX ${ARGN})
    unset(reX)
    get_min_version_from_sorted_list(reX "${ver}" ${versX})
    set("${result}" "${reX}" PARENT_SCOPE)
endfunction()


################################################################################

function(get_max_version_from_sorted_list result ver)
    math(EXPR end "${ARGC} - 1")

    if(end EQUAL 1)
        set("${result}" "" PARENT_SCOPE)
        return()
    endif()
    if(NOT ver)
        set("${result}" "${ARGV${end}}" PARENT_SCOPE)
        return()
    endif()

    unset(re)
    foreach(index RANGE 2 ${end})              
        set(a "${ARGV${index}}")
        compare_versions("${a}" "${ver}" result_sv)
        # message(STATUS "${index})  ${a} VS ${ver} -> ${result_sv}")  
        if(result_sv STREQUAL "GREATER")
            break()
        endif()
        set(re "${a}")
    endforeach()
    set("${result}" "${re}" PARENT_SCOPE)
endfunction()

function(get_max_version result ver)
    sort_versions_min_to_max(versX ${ARGN})
    unset(reX)
    get_max_version_from_sorted_list(reX "${ver}" ${versX})
    set("${result}" "${reX}" PARENT_SCOPE)
endfunction()

################################################################################

function(test_get_max_version)

    set(options        OPTION)
    set(oneValueArgs   MAX_VERSION EXPECTED)
    set(multiValueArgs VERSIONS)

    cmake_parse_arguments("myarg" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    foreach(variable ${options} ${oneValueArgs} ${multiValueArgs} UNPARSED_ARGUMENTS)
        set(t${variable} ${myarg_${variable}}) 
        unset(myarg_${variable})
        # message(STATUS "${variable}: ${t${variable}}")  
    endforeach()

    if(tUNPARSED_ARGUMENTS)
        message(STATUS "'UNPARSED_ARGUMENTS' must be empty")
        message(FATAL_ERROR "UNPARSED_ARGUMENTS: ${tUNPARSED_ARGUMENTS}")
    endif()

    get_max_version(result "${tMAX_VERSION}" ${tVERSIONS})
    if(NOT "${tEXPECTED}" STREQUAL "${result}")
        message(STATUS "[FAILED] max_version '${tMAX_VERSION}' from: '${tVERSIONS}' is '${result}', expected: '${tEXPECTED}'")  
    else()
        # message(STATUS "[PASSED] max_version '${tMAX_VERSION}' from: '${tVERSIONS}' is '${result}', expected: '${tEXPECTED}'")  
    endif()
endfunction()

function(test_all_get_min_version)
    test_get_max_version(MAX_VERSION "0.0.0"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED ""      )
    test_get_max_version(MAX_VERSION "0.2.9"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED ""      )
    test_get_max_version(MAX_VERSION "0.3.4"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "0.3.4" )
    test_get_max_version(MAX_VERSION "0.3.5"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "0.3.4" )
    test_get_max_version(MAX_VERSION "1.8.0"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "0.3.4" )
    test_get_max_version(MAX_VERSION "1.8.1"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.8.1" )
    test_get_max_version(MAX_VERSION "1.8.2"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.8.1" )
    test_get_max_version(MAX_VERSION "1.10.a" VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.8.1" )
    test_get_max_version(MAX_VERSION "1.10.2" VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.8.1" )
    test_get_max_version(MAX_VERSION "1.10.x" VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_max_version(MAX_VERSION "1.11.x" VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_max_version(MAX_VERSION ""       VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_max_version(MAX_VERSION "1.10.x" VERSIONS                      EXPECTED ""      )
endfunction()

################################################################################

function(test_get_min_version)

    set(options        OPTION)
    set(oneValueArgs   MIN_VERSION EXPECTED)
    set(multiValueArgs VERSIONS)

    cmake_parse_arguments("myarg" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    foreach(variable ${options} ${oneValueArgs} ${multiValueArgs} UNPARSED_ARGUMENTS)
        set(t${variable} ${myarg_${variable}}) 
        unset(myarg_${variable})
        # message(STATUS "${variable}: ${t${variable}}")  
    endforeach()

    if(tUNPARSED_ARGUMENTS)
        message(STATUS "'UNPARSED_ARGUMENTS' must be empty")
        message(FATAL_ERROR "UNPARSED_ARGUMENTS: ${tUNPARSED_ARGUMENTS}")
    endif()

    get_min_version(result "${tMIN_VERSION}" ${tVERSIONS})
    if(NOT "${tEXPECTED}" STREQUAL "${result}")
        message(STATUS "[FAILED] min_version '${tMIN_VERSION}' from: '${tVERSIONS}' is '${result}', expected: '${tEXPECTED}'")  
    else()
        # message(STATUS "[PASSED] min_version '${tMIN_VERSION}' from: '${tVERSIONS}' is '${result}', expected: '${tEXPECTED}'")  
    endif()
endfunction()

function(test_all_get_max_version)
    test_get_min_version(MIN_VERSION "0.0.0"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "0.2.9"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "0.3.4"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "0.3.5"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "1.8.0"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "1.8.1"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "1.8.2"  VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "1.10.a" VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "1.10.2" VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "1.10.x" VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "1.11.x" VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "")
    test_get_min_version(MIN_VERSION ""       VERSIONS 1.10.x  0.3.4  1.8.1 EXPECTED "1.10.x")
    test_get_min_version(MIN_VERSION "1.10.x" VERSIONS                      EXPECTED ""      )
endfunction()

################################################################################



