
# 2020y-05m-20d. Workspace project.
# 2020y-08m-27d. Workspace project.
################################################################################

#
#  Mission:
#    Load variables from the environment
#
#  Usage:
#
#    set(gENVIRONMENT_VARIABLES eEXAMPLE eDIR_WORKSPACE)
#    load_environment()
#

macro(load_environment)

    if(gDEBUG)
        message(STATUS "[load environment]")
    endif()

    if(NOT gENVIRONMENT_VARIABLES)
        set(gENVIRONMENT_VARIABLES 
            DIR_WORKSPACE
            DIRS_EXTERNALS
            DIR_SOURCE
            NAME_PROJECT
            DIR_BUILD
            DIR_PRODUCT
            VERSION
            SUFFIX
            COMPILER_TAG
            BUILD_TYPE
            ADDRESS_MODEL
            RUNTIME_CPP
            DEFINES
        )
    endif()

    foreach(variable ${gENVIRONMENT_VARIABLES})
        set(tmp "$ENV{e${variable}}")
        if(tmp)
            file(TO_CMAKE_PATH "${tmp}" g${variable})
            if(gDEBUG)
                message(STATUS "  load from environment: [g${variable}] ${g${variable}}")
            endif()
        endif()
    endforeach()
    unset(tmp)

endmacro()

################################################################################
