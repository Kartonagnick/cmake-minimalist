
# 2019y-01m-23d. Selika. Workspace project.
################################################################################

#
#  Mission:
#    Get source files from directory
#

################################################################################

function(cxx_sources path var_output)
    if(NOT IS_ABSOLUTE "${path}")
        message(FATAL_ERROR "expected absolute path: '${path}'")
    endif()
    if(NOT IS_DIRECTORY "${path}")
        message(FATAL_ERROR "expected directory: '${path}'")
    endif()
    set(content)
    FILE (GLOB_RECURSE content 
        "${path}/*.c"
        "${path}/*.cpp"
        "${path}/*.h" 
        "${path}/*.hpp"
    )
    list(FILTER content EXCLUDE REGEX "^_.*")
    list(FILTER content EXCLUDE REGEX "^.*/_.*")
    set(${var_output} ${content} PARENT_SCOPE)
endfunction()

################################################################################