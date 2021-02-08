
# 2020y-05m-22d. Workspace project.
################################################################################

#
#  Mission:
#    Copy resource directory to product
#

################################################################################

function(cxx_resource target dir)

    if(NOT IS_DIRECTORY "${dir}")
        message(FATAL_ERROR "must be directory: '${dir}'")
    endif()
    if(NOT IS_ABSOLUTE "${dir}")
        message(FATAL_ERROR "expected absolute path: '${dir}'")
    endif()

    if(gDEBUG)
        message(STATUS "[copy resource]")
        message(STATUS "  copy from '${dir}' to '$<TARGET_FILE_DIR:${target}>'")
    endif()

    add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${dir} "$<TARGET_FILE_DIR:${target}>"
        COMMENT "Copying resource directory to output dir"
    )

endfunction()

################################################################################

function(cxx_resources target var_dirs)
    set(tmp)
    foreach(dir ${${var_dirs}})
        if(NOT IS_DIRECTORY "${dir}")
            message(FATAL_ERROR "must be directory: '${dir}'")
        endif()
        if(NOT IS_ABSOLUTE "${dir}")
            message(FATAL_ERROR "expected absolute path: '${dir}'")
        endif()
        list(APPEND tmp ${dir})
    endforeach()

    if(NOT tmp)
        return()
    endif()

    if(gDEBUG)
        message(STATUS "[copy resource]")
    endif()

    foreach(dir ${tmp})
        if(gDEBUG)
            message(STATUS "  resource: '${dir}'")
        endif()

        add_custom_command(
            TARGET ${target}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_directory ${dir} "$<TARGET_FILE_DIR:${target}>"
            COMMENT "Copying resource directory to output dir"
        )
    endforeach()
endfunction()
