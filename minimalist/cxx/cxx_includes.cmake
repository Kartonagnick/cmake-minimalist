
# 2019y-01m-23d. Selika. Workspace project.
################################################################################
#
#  Mission:
#    set path when searched headers
#    cxx_includes(someTarget "./include" "../include")
#
################################################################################

function(cxx_includes target type)

    set(collection)
    foreach(cur ${ARGN})
        if(IS_DIRECTORY "${cur}")
            list(APPEND collection ${cur})
        else()
             message(STATUS "[WARNING] not directory: ${cur}")
        endif()
    endforeach()

    if(NOT collection)
        return()
    endif()

    if(gDEBUG)
        message(STATUS "[include]")
        foreach(cur ${collection})
            message(STATUS "  '${cur}'")
        endforeach()
    endif()

    if("${type}" STREQUAL "HEADER_ONLY")
        target_include_directories(${target} INTERFACE ${collection})
    else()
        target_include_directories(${target} PUBLIC ${collection})
    endif()

endfunction()

################################################################################

