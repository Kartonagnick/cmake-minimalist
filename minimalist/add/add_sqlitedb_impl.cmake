
# 2021y-02m-10d. WorkSpace project.
################################################################################
# import_from_sqlitedb(find_external)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_sqlitedb()
#
################################################################################

function(add_sqlitedb dir_result ver_result)

    set(min_version)
    set(max_version)

    #--- example:
    #---   gCOMPILER_TAG can be 'msvc2019'
    #---   gCOMPILER_TAG can be 'msvc-2019'
    #--- after replacement: 
    #---   variable '_tag_' will store 'msvc2019'

    string(REGEX REPLACE   "-" "" _tag_ "${gCOMPILER_TAG}")

    find_external(
        dir_sqlitedb
        ver_sqlitedb
        "sqlitedb"
        WHERE_STARTED ${gDIRS_EXTERNALS}
        MIN_VERSION "${min_version}"
        MAX_VERSION "${max_version}"
        VERSION ""
        SYMPTOMS "include" "${_tag_}-*"
    )

    if(dir_sqlitedb)
        commit_sqlitedb("sqlitedb" "${dir_sqlitedb}")
        if(gDEBUG)
            if(ver_sqlitedb)
                message(STATUS "link: <${tNAME}> ---> <sqlitedb-${ver_tools}>")
            else()
                message(STATUS "link: <${tNAME}> ---> <sqlitedb>")
            endif()
            message(STATUS "sqlitedb: '${dir_sqlitedb}'")
        endif()
        set(${dir_result} "${dir_sqlitedb}" PARENT_SCOPE)
        set(${ver_result} "${ver_sqlitedb}" PARENT_SCOPE)
    else()
        message(STATUS "link: 'sqlitedb' not found")
        set(${dir_result} "" PARENT_SCOPE)
        set(${ver_result} "" PARENT_SCOPE)
    endif()

endfunction()

################################################################################

function(commit_sqlitedb name dir)

    if(IS_DIRECTORY "${dir}")
        # message(STATUS "'${name}' found in: '${dir}'")
    else()
        message(FATAL_ERROR "external library '${name}' not found")
    endif()

    if(${ARGC} GREATER 2)
        set(debug_postfix "${ARGV2}")
    else()
        unset(debug_postfix)
    endif()

    set(path_include  "${dir}/include")

    set(prefix_debug   "${gCOMPILER_TAG}-debug-${gADDRESS_MODEL}-${gRUNTIME_CPP}")
    set(prefix_release "${gCOMPILER_TAG}-release-${gADDRESS_MODEL}-${gRUNTIME_CPP}"  )

    set(path_debug     "${dir}/${prefix_debug}"  )
    set(path_release   "${dir}/${prefix_release}")

    target_link_libraries(${tNAME} 
        PUBLIC  "sqlite3"
        PUBLIC  "sqlitedb"
    )

    target_link_directories(${tNAME}    
        PUBLIC  "$<$<CONFIG:debug>:${path_debug}/lib-sqlite3>"
        PUBLIC  "$<$<CONFIG:debug>:${path_debug}/lib-sqlitedb>"

        PUBLIC  "$<$<CONFIG:release>:${path_release}/lib-sqlite3>"
        PUBLIC  "$<$<CONFIG:release>:${path_release}/lib-sqlitedb>"
    )

    target_include_directories(${tNAME} PUBLIC  
        "${path_include}"
    )

    string(TOUPPER ${name} UP_NAME) 
    target_compile_definitions(${tNAME} PUBLIC  
        d${UP_NAME}_LIBRARY_USED_
    )

endfunction()

################################################################################
