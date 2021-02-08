
# 2020y-05m-20d. Workspace project.
################################################################################

if(NOT COMMAND find_symptoms)
    include("${CMAKE_CURRENT_LIST_DIR}/001-symptoms.cmake")
    include("${CMAKE_CURRENT_LIST_DIR}/002-detect.cmake")
endif()

include("${CMAKE_CURRENT_LIST_DIR}/003-externals.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/004-compiler_tag.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/005-build_type.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/006-address_model.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/007-defines.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/008-compiler_keys.cmake")

################################################################################

#
#  Mission:
#    Set global project`s settings
#
#  Usage:
#    default_settings()
#

macro(default_settings)

    if(gDEBUG)
        message(STATUS "[default settings]")
    endif()
#--------
    set(CMAKE_CONFIGURATION_TYPES debug release)
#--------
    if(NOT gDIR_CMAKE_SCENARIO)
        message(FATAL_ERROR "'gDIR_CMAKE_SCENARIO' not specified")
    endif()
    if(NOT IS_DIRECTORY "${gDIR_CMAKE_SCENARIO}")
        message(FATAL_ERROR "'gDIR_CMAKE_SCENARIO' must be directory")
    endif()
    get_filename_component(gDIR_CMAKE_SCENARIO "${gDIR_CMAKE_SCENARIO}" ABSOLUTE)
#--------
    if(NOT gDIR_SOURCE)
        message(FATAL_ERROR "'gDIR_SOURCE' not specified")
    endif()
    if(NOT IS_DIRECTORY "${gDIR_SOURCE}")
        message(FATAL_ERROR "'gDIR_SOURCE' must be directory")
    endif()
    get_filename_component(gDIR_SOURCE "${gDIR_SOURCE}" ABSOLUTE)
#--------
    if(NOT gNAME_PROJECT)
       detect_name_project()
    endif()
    if(NOT gNAME_PROJECT)
        message(FATAL_ERROR "'gNAME_PROJECT' not specified")
    endif()
#--------
    if(NOT gDIR_WORKSPACE)
       detect_dir_workspace()
    endif()
#--------
    detect_externals()
#--------
    detect_compiler_tag()
#--------
    detect_build_type()
#--------
    if(NOT gADDRESS_MODEL)
        detect_address_model()
    endif()
#--------
    detect_defines()
#--------
    if(NOT gRUNTIME_CPP)
        set(gRUNTIME_CPP "dynamic")
    endif()
#--------
#    if(NOT gADDITIONAL)
#    endif()
#--------
    if(NOT gSUFFIX)
        set(gSUFFIX "{TARGET_TYPE}-{COMPILER_TAG}-{BUILD_TYPE}-{ADDRESS_MODEL}-{RUNTIME_CPP}/{TARGET_NAME}")
    endif()
#--------
    if(NOT gDIR_BUILD)
        set(gDIR_BUILD "${CMAKE_BINARY_DIR}")
    endif()
#--------
    if(NOT gDIR_PRODUCT)
        if(gDIR_WORKSPACE)
            set(gDIR_PRODUCT "${gDIR_WORKSPACE}/_products/${gNAME_PROJECT}")
        else()
            set(gDIR_PRODUCT "${CMAKE_BINARY_DIR}/../_products/${gNAME_PROJECT}")
        endif()
    endif()
    set(gDIR_PRODUCT "${gDIR_PRODUCT}/{SUFFIX}")
#--------
    if(gDEBUG)
        message(STATUS "  [gDIR_CMAKE_SCENARIO] ... '${gDIR_CMAKE_SCENARIO}'")
        message(STATUS "  [gDIR_SOURCE] ........... '${gDIR_SOURCE}'"        )
        message(STATUS "  [gNAME_PROJECT] ......... '${gNAME_PROJECT}'"      )
        message(STATUS "  [gDIR_BUILD] ............ '${gDIR_BUILD}'"         )
        message(STATUS "  [gDIR_PRODUCT] .......... '${gDIR_PRODUCT}'"       )
        message(STATUS "  [gVERSION] .............. '${gVERSION}'"           )
        message(STATUS "  [gSUFFIX] ............... '${gSUFFIX}'"            )
        message(STATUS "  [gCOMPILER_TAG] ......... '${gCOMPILER_TAG}'"      )
        message(STATUS "  [gBUILD_TYPE] ........... '${gBUILD_TYPE}'"        )
        message(STATUS "  [gADDRESS_MODEL] ........ '${gADDRESS_MODEL}'"     )
        message(STATUS "  [gRUNTIME_CPP] .......... '${gRUNTIME_CPP}'"       )
        foreach(d ${gDIRS_EXTERNALS})
            message(STATUS "  [EXTERNAL] .............. '${d}'")
        endforeach()
    endif()
#--------
    set_global_compiler_keys()
#--------
endmacro()

################################################################################
