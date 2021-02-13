
# 2020y-08m-24d. Workspace project.
################################################################################

message(STATUS "------------------------[minimalist]------------------------>")

# set(CMAKE_BUILD_PARALLEL_LEVEL "$ENV{NUMBER_OF_PROCESSORS}")
# if(${CMAKE_GENERATOR} MATCHES "Makefiles")
#    # set(CMAKE_MAKE_PROGRAM "${CMAKE_MAKE_PROGRAM} -j4")
#    # message(STATUS "[CMAKE_MAKE_PROGRAM] '${CMAKE_MAKE_PROGRAM}'")
#    # set(CMAKE_MAKE_PROGRAM "${CMAKE_MAKE_PROGRAM} -m32")
# endif()

get_filename_component(gDIR_TOOLS "${gDIR_CMAKE_SCENARIO}/tools" ABSOLUTE)
if(NOT IS_DIRECTORY "${gDIR_TOOLS}")
    message(STATUS "[gDIR_CMAKE_SCENARIO] ... '${gDIR_CMAKE_SCENARIO}'")
    message(STATUS "[gDIR_TOOLS] ............ '${gDIR_TOOLS}'")
    message(FATAL_ERROR "'gDIR_TOOLS' must be directory" )
endif()

macro(debug_message)
    if(gDEBUG)
        message(STATUS "${ARGN}") 
    endif()
endmacro()

macro(import_from_tools name)
    if("${ARGV1}" STREQUAL "")
        if(NOT COMMAND ${name})
            message(STATUS "[ADD COMMAND] '${name}'") 
            include("${gDIR_TOOLS}/${name}.cmake")
        endif()
    else()
        if(NOT COMMAND ${ARGV1})
            message(STATUS "[ADD COMMAND] '${ARGV1}' from '${name}'") 
            include("${gDIR_TOOLS}/${name}.cmake")
        endif()
    endif()
endmacro()

macro(import_from name)
    if("${ARGV1}" STREQUAL "")
        if(NOT COMMAND ${name})
            message(STATUS "[ADD COMMAND] '${name}'") 
            include("${gDIR_CMAKE_SCENARIO}/${name}.cmake")
        endif()
    else()
        if(NOT COMMAND ${ARGV1})
            message(STATUS "[ADD COMMAND] '${ARGV1}' from '${name}'") 
            include("${gDIR_CMAKE_SCENARIO}/${ARGV0}.cmake")
        endif()
    endif()
endmacro()

#-------------------------------------------------------------------------------

include("${CMAKE_CURRENT_LIST_DIR}/tools/compare_versions.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/tools/sort_versions.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/tools/map.cmake")

include("${CMAKE_CURRENT_LIST_DIR}/tools/absolute.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/tools/format_string.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/tools/mask2regex.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/tools/view_variables.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/tools/check_symptoms.cmake")

include("${CMAKE_CURRENT_LIST_DIR}/tools/find_external.cmake")

#-------------------------------------------------------------------------------
include("${CMAKE_CURRENT_LIST_DIR}/add/add_gmock_impl.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/add/add_gtest_impl.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/add/add_mygtest_impl.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/add/add_tools_impl.cmake")
#-------------------------------------------------------------------------------

include("${CMAKE_CURRENT_LIST_DIR}/cxx/cxx.cmake")

#-------------------------------------------------------------------------------

include("${CMAKE_CURRENT_LIST_DIR}/environment.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/default.cmake")
load_environment()
default_settings()

#-------------------------------------------------------------------------------

include("${gDIR_CMAKE_SCENARIO}/target.cmake")

################################################################################
################################################################################

