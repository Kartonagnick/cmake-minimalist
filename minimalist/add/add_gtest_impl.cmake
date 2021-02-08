
# 2020y-05m-24d. WorkSpace project.
# 2020y-08m-31d. WorkSpace project.
################################################################################
# import_from(add/add_gmock_impl add_gmock)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_gtest()
#
################################################################################

function(add_gtest dir_result ver_result)

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

    find_external(
        dir_gtest
        ver_gtest
        "gtest"
        WHERE_STARTED ${gDIRS_EXTERNALS}
        MIN_VERSION "${min_version}"
        MAX_VERSION "${max_version}"
        VERSION ""
        SYMPTOMS "include" "lib-${gCOMPILER_TAG}-*"
    )
    if(dir_gtest)
        commit_external("gtest" "${dir_gtest}" "d")
        if(gDEBUG)
            if(ver_gtest)
                message(STATUS "link: <${tNAME}> ---> <gtest-${ver_gtest}>")
            else()
                message(STATUS "link: <${tNAME}> ---> <gtest>")
            endif()
            message(STATUS "gmock: '${dir_gtest}'")
        endif()
        set(${dir_result} "${dir_gtest}" PARENT_SCOPE)
        set(${ver_result} "${ver_gtest}" PARENT_SCOPE)
    else()
        message(STATUS "link: 'gtest' not found")
        set(${dir_result} "" PARENT_SCOPE)
        set(${ver_result} "" PARENT_SCOPE)
    endif()

endfunction()

################################################################################
################################################################################
