
# 2020y-09m-08d. WorkSpace project.
################################################################################
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_ttlib()
#
################################################################################

function(add_ttlib dir_result ver_result)

    set(min_version)
    set(max_version)

    find_external(
        dir_ttlib
        ver_ttlib
        "ttlib"
        WHERE_STARTED ${gDIRS_EXTERNALS}
        MIN_VERSION "${min_version}"
        MAX_VERSION "${max_version}"
        VERSION ""
        SYMPTOMS "include" "lib-${gCOMPILER_TAG}-*"
    )
    if(dir_ttlib)
        commit_external("ttlib" "${dir_gtest}" "d")
        if(gDEBUG)
            if(ver_ttlib)
                message(STATUS "link: <${tNAME}> ---> <ttlib-${ver_gtest}>")
            else()
                message(STATUS "link: <${tNAME}> ---> <ttlib>")
            endif()
        endif()
        set(${dir_result} "${dir_ttlib}" PARENT_SCOPE)
        set(${ver_result} "${ver_ttlib}" PARENT_SCOPE)
    else()
        message(STATUS "link: 'ttlib' not found")
        set(${dir_result} "" PARENT_SCOPE)
        set(${ver_result} "" PARENT_SCOPE)
    endif()

endfunction()

################################################################################
################################################################################
