
# 2019y-01m-23d. Selika. Workspace project.
################################################################################

#
#  Mission:
#    Get header files from directory
#

################################################################################

function(cxx_hpp path var_output)

    set(result ${${var_output}})

    if(NOT IS_ABSOLUTE "${path}")
        message(FATAL_ERROR "expected absolute path: '${path}'")
    endif()
    if(NOT IS_DIRECTORY "${path}")
        message(FATAL_ERROR "expected directory: '${path}'")
    endif()
    set(content)
    FILE (GLOB_RECURSE content 
#        "${path}/*"                can not files without extension!!!
        "${path}/*.h"
        "${path}/*.hpp"
        "${path}/*.hxx"
    )
    list(FILTER content EXCLUDE REGEX "^_.*")
    list(FILTER content EXCLUDE REGEX "^.*/_.*")
    list(APPEND result ${content})

    if(result)
        list(REMOVE_DUPLICATES result)
    endif()

    set(${var_output} ${result} PARENT_SCOPE)

endfunction()

################################################################################