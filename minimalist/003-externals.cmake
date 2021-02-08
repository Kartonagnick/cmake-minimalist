
# 2020y-08m-24d. Workspace project.
################################################################################

macro(detect_externals)
    if(IS_DIRECTORY "${gDIR_SOURCE}/external")
        list(APPEND gDIRS_EXTERNALS "${gDIR_SOURCE}/external")
    endif()
    if(gDIR_WORKSPACE)
        if(IS_DIRECTORY "${gDIR_WORKSPACE}/external")
            list(APPEND gDIRS_EXTERNALS "${gDIR_WORKSPACE}/external")
        endif()
        set(long "${gDIR_WORKSPACE}/../long/workspace/external")
        get_filename_component(long "${long}" ABSOLUTE)
        if(IS_DIRECTORY "${long}")
            list(APPEND gDIRS_EXTERNALS "${long}")
        endif()
    endif()

    if(IS_DIRECTORY "C:/workspace/external")
        list(APPEND gDIRS_EXTERNALS "C:/workspace/external")
    endif()
    if(IS_DIRECTORY "C:/long/workspace/external")
        list(APPEND gDIRS_EXTERNALS "C:/long/workspace/external")
    endif()

    if(IS_DIRECTORY "C:/home/workspace/external")
        list(APPEND gDIRS_EXTERNALS "C:/home/workspace/external")
    endif()

    if(IS_DIRECTORY "C:/home/long/workspace/external")
        list(APPEND gDIRS_EXTERNALS "C:/home/long/workspace/external")
    endif()

    set(tmp)
    foreach(d ${gDIRS_EXTERNALS})
        string(STRIP "${d}" d)
        list(APPEND tmp "${d}")
    endforeach()
    set (gDIRS_EXTERNALS ${tmp})
    list(REMOVE_DUPLICATES gDIRS_EXTERNALS)

    foreach(d ${gDIRS_EXTERNALS})
        message(STATUS "[external] ${d}")
    endforeach()
endmacro()

################################################################################

