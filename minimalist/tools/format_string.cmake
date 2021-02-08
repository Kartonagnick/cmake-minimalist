
# 2020y-05m-16d. Workspace project.
################################################################################

#
#  Mission:
#    Expand format string
#
#  Usage:
#    set(BUILD_TYPE debug) 
#    set(ADDRESS_MODEL 32)
#    format_string(
#        "foo/build/{BUILD_TYPE}-{ADDRESS_MODEL}/test" output
#    )
#    message(STATUS "result: ${output}")
#
#    result: foo/build/debug-32/test
#

macro(expand_format_string var)
    set(out ${var})
endmacro()

function(format_string prefix input_value output_variable)
#    string(REGEX REPLACE   "{[^{]*}" "$\\2" out "${input_value}")

    string(REGEX REPLACE   "({)([^{]*)(})" "\${${prefix}\\2}" out "${input_value}")
#    message(STATUS "  [format_string] out: '${out}'")
    expand_format_string(${out})

    string(REGEX REPLACE   "^(.*)/$" "\\1" out "${out}")
    string(REGEX REPLACE   "//" "/" out "${out}")
    string(REGEX REPLACE   "--" "-" out "${out}")
    string(REGEX REPLACE   "/-" "/" out "${out}")
    string(REGEX REPLACE   "-/" "/" out "${out}")

    set(${output_variable} ${out} PARENT_SCOPE)
endfunction()

function(format_string3 prefix input_value output_variable)
    format_string(${prefix} ${input_value} output)
    format_string(${prefix} ${output} output)
    format_string(${prefix} ${output} output)
    set(${output_variable} ${output} PARENT_SCOPE)
endfunction()

################################################################################

#
#  Mission:
#    Expand format string with eVARIABLES (or gVARIABLES)
#
#  Usage:
#    set(eBUILD_TYPE debug) 
#    set(eADDRESS_MODEL 32)
#    format_string_variables(
#        "foo/build/BUILD_TYPE-ADDRESS_MODEL/test" output
#        PREFIX "e"
#        OUTPUT variable_result 
#        VARIABLES
#            BUILD_TYPE
#            ADDRESS_MODEL
#        VIEW_RESULT
#    )
#    message(STATUS "result: ${variable_result}")
#
#    result: foo/build/debug-32/test
#

macro(format_string_variables)

    set(options        VIEW_RESULT    )
    set(oneValueArgs   PREFIX OUTPUT  )
    set(multiValueArgs INPUT VARIABLES)

    cmake_parse_arguments("format" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT format_PREFIX)
        set(format_PREFIX "g")
    endif()

    if(NOT format_VARIABLES)
        set(format_VARIABLES 
            NAME_OF_PROJECT
            PATH_TO_SOURCES PATH_TO_BUILD PATH_TO_PRODUCT
            COMPILER_TAG BUILD_TYPE ADDRESS_MODEL RUNTIME_CPP ADDITIONAL
        )
    endif()

    if(NOT format_OUTPUT)
        set(format_OUTPUT "format_result")
    endif()

    unset(${format_OUTPUT})

    foreach(value ${format_INPUT})
        foreach(variable ${format_VARIABLES})
            if(value MATCHES "${variable}")
                set(pvariable ${format_PREFIX}${variable})
                if(${pvariable})
                    # message(STATUS "debug: '${variable}' -> '${${pvariable}}'")
                    string(REGEX REPLACE "${variable}" "${${pvariable}}" value "${value}")
                else()
                    string(REGEX REPLACE "-${variable}"   ""  value "${value}")
                    string(REGEX REPLACE "\\.${variable}" ""  value "${value}")

                    string(REGEX REPLACE "${variable}-"   ""  value "${value}")
                    string(REGEX REPLACE "${variable}\\." ""  value "${value}")

                    string(REGEX REPLACE "/${variable}/"  "/" value "${value}")
                    string(REGEX REPLACE "/${variable}"   "/" value "${value}")

                    string(REGEX REPLACE "${variable}"    ""  value "${value}")
                endif()
            endif()
        endforeach()
        if(value)
            list(APPEND ${format_OUTPUT} ${value})
        endif()
    endforeach()

#    foreach(value ${${format_OUTPUT}})
#        message(STATUS "${format_OUTPUT}: ${value}")
#    endforeach()

endmacro()

################################################################################



