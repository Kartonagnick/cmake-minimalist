
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

function(cxx_copy_includes target type)

    if(tFORCE_INSTALL_HEADERS)
        set(d_prefix_dst "${tFORCE_INSTALL_HEADERS}")
    elseif(tINSTALL_HEADERS)
        set(d_prefix_dst "${tINSTALL_HEADERS}")
    else()
        if(gDEBUG)
            message(STATUS "[copy include] not required")
        endif()
        return()
    endif()

    if("${type}" STREQUAL "HEADER_ONLY")
        # nothing
    elseif("${type}" STREQUAL "STATIC_LIBRARY")
        # nothing
    else()
        if(gDEBUG)
            message(STATUS "[copy include] incompatible type -> cancel")
        endif()
        return()
    endif()

    set(tmp)
    foreach(dir ${ARGN})
        if(NOT IS_DIRECTORY "${dir}")
            message(FATAL_ERROR "must be directory: '${dir}'")
        endif()
        if(NOT IS_ABSOLUTE "${dir}")
            message(FATAL_ERROR "expected absolute path: '${dir}'")
        endif()
        list(APPEND tmp ${dir})
    endforeach()

    if(NOT tmp)
        if(gDEBUG)
            message(STATUS "[copy include] none")
        endif()
        return()
    endif()

    if(gDEBUG)
        message(STATUS "[copy include]")
    endif()

    foreach(d_src ${tmp})
        get_filename_component(d_parent "${d_src}" NAME)
        set(d_dst "${d_prefix_dst}/${d_parent}")

        if(NOT tFORCE_INSTALL_HEADERS AND IS_DIRECTORY "${d_dst}")
            if(gDEBUG)
              message(STATUS "  skip already exist: '${d_src}'")
            endif()
        else()
            if(gDEBUG)
                message(STATUS "  from: '${d_src}'")
                message(STATUS "  to:   '${d_dst}'")
            endif()
            add_custom_command(
                TARGET ${target}
                POST_BUILD
                COMMAND "${CMAKE_COMMAND}" -E copy_directory "${d_src}" "${d_dst}"
                COMMENT "Copying includes from ${d_src} to ${d_dst}\n"
                MAIN_DEPENDENCY "${d_dst}"
            )
        endif()
    endforeach()
endfunction()

################################################################################

