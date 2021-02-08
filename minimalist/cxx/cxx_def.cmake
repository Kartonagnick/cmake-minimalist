
# 2019y-01m-23d. Selika. Workspace project.
# 2019y-08m-31d. Workspace project.
################################################################################

#
#  Mission:
#    Find and setup *.def files
#

################################################################################

function(cxx_def target type dirs_sources)
    if(MSVC AND "${type}" STREQUAL "SHARED_LIBRARY")
        set(def_files)
        foreach(dir ${dirs_sources})
            if(NOT IS_ABSOLUTE "${dir}")
                message(FATAL_ERROR "expected absolute path: '${dir}'")
            endif()
            if(NOT IS_DIRECTORY "${dir}")
                message(FATAL_ERROR "expected directory: '${dir}'")
            endif()

            set(content)
            FILE (GLOB_RECURSE content "${dir}/*.def")
            list(FILTER content EXCLUDE REGEX "^_.*")
            list(FILTER content EXCLUDE REGEX "^.*/_.*")

            if(content)
                list(APPEND def_files ${content})
            endif()
        endforeach()
        list(REMOVE_DUPLICATES def_files)

        foreach(file ${def_files})
            if(gDEBUG)
                message(STATUS "[def]")
                message(STATUS "    '${file}'")
            endif()
            set_target_properties(${target} 
                PROPERTIES 
                LINK_FLAGS "/DEF:\"${file}\""
            )
        endforeach()
    endif()

#    set_target_properties(${target} PROPERTIES LINK_FLAGS "/DEF:\"ExportedFunctions.def\" /NODEFAULTLIB:\"mfc110d\"")

endfunction()

################################################################################