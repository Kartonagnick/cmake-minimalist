
# 2020y-05m-24d. WorkSpace project.
# 2020y-08m-31d. WorkSpace project.
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
#    add_gmock()
#
################################################################################

function(add_gmock dir_result ver_result)

    set(min_version)
    set(max_version)

    if("${gCOMPILER_TAG}" STREQUAL     "msvc2008")
        set(max_version "1.8.x")
    elseif("${gCOMPILER_TAG}" STREQUAL "msvc2010")
        set(max_version "1.8.x")
    elseif("${gCOMPILER_TAG}" STREQUAL "msvc2012")
        set(max_version "1.8.x")
    elseif("${gCOMPILER_TAG}" STREQUAL "msvc2013")
        set(max_version "1.8.x")
    endif()

    string(REGEX REPLACE   "-" "" _tag_ "${gCOMPILER_TAG}")

    find_external(
        dir_gmock
        ver_gmock
        "gmock"
        WHERE_STARTED ${gDIRS_EXTERNALS}
        MIN_VERSION "${min_version}"
        MAX_VERSION "${max_version}"
        VERSION ""
        SYMPTOMS "include" "lib-${_tag_}-*"
    )

    if(dir_gmock)
        commit_external("gmock" "${dir_gmock}" "d")
        if(gDEBUG)
            if(ver_gmock)
                message(STATUS "link: <${tNAME}> ---> <gmock-${ver_gmock}>")
            else()
                message(STATUS "link: <${tNAME}> ---> <gmock>")
            endif()
            message(STATUS "gmock: '${dir_gmock}'")
        endif()
        set(${dir_result} "${dir_gmock}" PARENT_SCOPE)
        set(${ver_result} "${ver_gmock}" PARENT_SCOPE)
    else()
        message(STATUS "link: 'gmock' not found")
        set(${dir_result} "" PARENT_SCOPE)
        set(${ver_result} "" PARENT_SCOPE)
    endif()

endfunction()

################################################################################
################################################################################
