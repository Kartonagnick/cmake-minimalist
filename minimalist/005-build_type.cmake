
# 2020y-08m-24d. Workspace project.
################################################################################

macro(detect_build_type)
    if(CMAKE_BUILD_TYPE)
        string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE) 
        if(${CMAKE_BUILD_TYPE} STREQUAL "relwithdebinfo")
            set(CMAKE_BUILD_TYPE "release")
        elseif(${CMAKE_BUILD_TYPE} STREQUAL "minsizerel")
            set(CMAKE_BUILD_TYPE "release")
        endif()

        if(gBUILD_TYPE AND NOT "${CMAKE_BUILD_TYPE}" STREQUAL "${gBUILD_TYPE}")
            message(STATUS "[WARNING] CMAKE_BUILD_TYPE = '${CMAKE_BUILD_TYPE}', gBUILD_TYPE = '${gBUILD_TYPE}'")
            message(STATUS "[WARNING] change: gBUILD_TYPE = '${CMAKE_BUILD_TYPE}'")
        endif()
        set(gBUILD_TYPE "${CMAKE_BUILD_TYPE}")
    else()
        if(NOT gBUILD_TYPE)
            set(gBUILD_TYPE "release")   
        endif()
        set(CMAKE_BUILD_TYPE "${gBUILD_TYPE}")
    endif()
endmacro()

################################################################################

