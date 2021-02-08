
# 2019y-01m-23d. Selika. Workspace project.
# 2020y-08m-31d. Workspace project.
################################################################################

#
#  Mission:
#    Find and setup *.rc files
#

################################################################################

function(cxx_rc target type dirs_sources)
    set(rc_files)
    if(MSVC AND "${type}" STREQUAL "SHARED_LIBRARY")
        foreach(dir ${dirs_sources})
            if(NOT IS_ABSOLUTE "${dir}")
                message(FATAL_ERROR "expected absolute path: '${dir}'")
            endif()
            if(NOT IS_DIRECTORY "${dir}")
                message(FATAL_ERROR "expected directory: '${dir}'")
            endif()

            set(content)
            FILE (GLOB_RECURSE content "${dir}/*.rc")
            list(FILTER content EXCLUDE REGEX "^_.*")
            list(FILTER content EXCLUDE REGEX "^.*/_.*")

            if(content)
                list(APPEND rc_files ${content})
            endif()
        endforeach()
        list(REMOVE_DUPLICATES rc_files)

        foreach(file ${rc_files})
            if(gDEBUG)
                message(STATUS "[rc]")
                message(STATUS "    '${file}'")
            endif()
            # set_target_properties(${target} PROPERTIES LINK_FLAGS "/DEF:\"${file}\"")
        endforeach()
    endif()

#    set_target_properties(${target} PROPERTIES LINK_FLAGS "/DEF:\"ExportedFunctions.def\" /NODEFAULTLIB:\"mfc110d\"")

endfunction()

################################################################################