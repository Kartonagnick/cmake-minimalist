
# 2020y-05m-21d. Workspace project.
################################################################################
#
#  Mission:
#    Groups source in a solution of Visual Studio ot QtCreator
#
################################################################################

function(cxx_source_group target_name path2target list_sources)
    if(CMAKE_GENERATOR MATCHES "Visual Studio")
        foreach(cur ${${list_sources}})
            file(RELATIVE_PATH result "${path2target}" "${cur}")
            get_filename_component(result ${result} DIRECTORY)
            string(REGEX REPLACE "/" "\\\\" result "${result}")
            source_group(${result} FILES ${cur})
        endforeach()
    else()
        list(LENGTH ${list_sources} count)
        if(count GREATER 0)
            list(GET ${list_sources} 0 item)
            file(RELATIVE_PATH item "${path2target}" "${item}")
            string(REGEX REPLACE "/" ";" item "${item}")
            list(GET item 0 item)
            source_group(${item} FILES ${${list_sources}})
        endif()
    endif()
endfunction()

################################################################################

#- do not use it
function(workaround)
    foreach(cur ${${list_sources}})
        file(RELATIVE_PATH result "${path2target}" "${cur}")
        get_filename_component(result ${result} DIRECTORY)
        source_group(${result} FILES ${cur})
        message(STATUS "group [${result}] ... ${cur}")
    endforeach()
endfunction()

################################################################################