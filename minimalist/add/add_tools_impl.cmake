
# 2021y-01m-19d. WorkSpace project.
################################################################################
# import_from_tools(find_external)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_tools()
#
################################################################################

function(add_tools dir_result ver_result)

    set(min_version)
    set(max_version)

    #--- example:
    #---   gCOMPILER_TAG can be 'msvc2019'
    #---   gCOMPILER_TAG can be 'msvc-2019'
    #--- after replacement: 
    #---   variable '_tag_' will store 'msvc2019'

    string(REGEX REPLACE   "-" "" _tag_ "${gCOMPILER_TAG}")

    find_external(
        dir_tools
        ver_tools
        "tools"
        WHERE_STARTED ${gDIRS_EXTERNALS}
        MIN_VERSION "${min_version}"
        MAX_VERSION "${max_version}"
        VERSION ""
        SYMPTOMS "include" "lib-${_tag_}-*"
    )

    if(dir_tools)
        commit_external("tools" "${dir_tools}")
        if(gDEBUG)
            if(ver_tools)
                message(STATUS "link: <${tNAME}> ---> <tools-${ver_tools}>")
            else()
                message(STATUS "link: <${tNAME}> ---> <tools>")
            endif()
            message(STATUS "tools: '${dir_tools}'")
        endif()
        set(${dir_result} "${dir_tools}" PARENT_SCOPE)
        set(${ver_result} "${ver_tools}" PARENT_SCOPE)
    else()
        message(STATUS "link: 'tools' not found")
        set(${dir_result} "" PARENT_SCOPE)
        set(${ver_result} "" PARENT_SCOPE)
    endif()

endfunction()

################################################################################
################################################################################
