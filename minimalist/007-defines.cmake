
# 2020y-08m-25d. Workspace project.
################################################################################

#
#  Mission:
#    Determine defines of preprocessor
#
#  Usage:
#    detect_defines()
#

macro(detect_defines)

    if (gADDRESS_MODEL EQUAL 32)
        add_definitions(-DdX32=1)
     elseif(gADDRESS_MODEL EQUAL 64)
        add_definitions(-DdX64=1)
    endif()

    if(${gRUNTIME_CPP} STREQUAL "dynamic")
        # message(STATUS "detect_defines: dynamic")
        add_compile_options("$<$<CONFIG:RELEASE>:-DdCRT_TXT=MD>")
        add_compile_options("$<$<CONFIG:RELEASE>:-DdCRT_VAL=1>")

        add_compile_options("$<$<CONFIG:DEBUG>:-DdCRT_TXT=MDd>")
        add_compile_options("$<$<CONFIG:DEBUG>:-DdCRT_VAL=3>")
    else()
        # message(STATUS "detect_defines: static")
        add_compile_options("$<$<CONFIG:RELEASE>:-DdCRT_TXT=MT>")
        add_compile_options("$<$<CONFIG:RELEASE>:-DdCRT_VAL=2>")

        add_compile_options("$<$<CONFIG:DEBUG>:-DdCRT_TXT=MTd>")
        add_compile_options("$<$<CONFIG:DEBUG>:-DdCRT_VAL=4>")
    endif()

    add_definitions(-D_UNICODE -DUNICODE)

    set(defines_ ${gDEFINES})
    separate_arguments(defines_)
    foreach(cur ${defines_})
        if(${cur} STREQUAL "STABLE_RELEASE")
            set(gSTABLE_RELEASE "ON")
            break()
        endif()
    endforeach()
    unset(defines_)

    if(MSVC)
        if(NOT MSVC_VERSION LESS 0 AND NOT MSVC_VERSION GREATER 1700)
            # msvc2012 or older
            add_definitions(-D_VARIADIC_MAX=10)
        endif()
    endif()

endmacro()

################################################################################

