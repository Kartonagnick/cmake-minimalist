
# 2021y-01m-18d. WorkSpace project.
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
#    add_mygtest()
#
################################################################################

function(add_mygtest dir_result ver_result)

    set(min_version)
    set(max_version)

    #--- example:
    #---   gCOMPILER_TAG can be 'msvc2019'
    #---   gCOMPILER_TAG can be 'msvc-2019'
    #--- after replacement: 
    #---   variable '_tag_' will store 'msvc2019'

    string(REGEX REPLACE   "-" "" _tag_ "${gCOMPILER_TAG}")

    find_external(
        dir_mygtest
        ver_mygtest
        "mygtest"
        WHERE_STARTED ${gDIRS_EXTERNALS}
        MIN_VERSION "${min_version}"
        MAX_VERSION "${max_version}"
        VERSION ""
        SYMPTOMS "include" "lib-${_tag_}-*"
    )

    if(dir_mygtest)
        commit_external("mygtest" "${dir_mygtest}")
        if(gDEBUG)
            if(ver_mygtest)
                message(STATUS "link: <${tNAME}> ---> <mygtest-${ver_mygtest}>")
            else()
                message(STATUS "link: <${tNAME}> ---> <mygtest>")
            endif()
            message(STATUS "mygtest: '${dir_mygtest}'")
        endif()
        set(${dir_result} "${dir_mygtest}" PARENT_SCOPE)
        set(${ver_result} "${ver_mygtest}" PARENT_SCOPE)
    else()
        message(STATUS "link: 'mygtest' not found")
        set(${dir_result} "" PARENT_SCOPE)
        set(${ver_result} "" PARENT_SCOPE)
    endif()

endfunction()

################################################################################
################################################################################
