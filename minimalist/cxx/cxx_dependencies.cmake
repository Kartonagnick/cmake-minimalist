
# 2019y-01m-23d. Selika. Workspace project.
################################################################################
#
#  Mission:
#    Determine dependencies
#
################################################################################

function(cxx_dependencies target)
    set(coll ${ARGN})
    if(NOT coll)
        return()
    endif()

    list(REMOVE_DUPLICATES coll)

    if(gDEBUG)
        foreach(cur ${coll})
            message(STATUS "dependencies: ${cur}")
        endforeach()
    endif()
    target_link_libraries(${target} PUBLIC ${coll})
endfunction()

################################################################################

