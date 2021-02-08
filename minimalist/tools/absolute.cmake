
# 2020y-05m-24d. Workspace project.
################################################################################

#
#  Mission:
#    Convert paths to absolute
#
#  Usage:
#    make_file_absolute("${gPATH_TO_SOURCES}" sources)
#    make_dir_absolute("${gPATH_TO_SOURCES}" includes)
#

################################################################################

function(make_file_absolute path variable)

    set(abs "${path}")
    if(NOT IS_ABSOLUTE "${abs}")
        message(FATAL_ERROR "must be absolute: '${abs}'")
    endif()

    set(tmp)
    foreach(cur ${${variable}})
        if(NOT IS_ABSOLUTE "${cur}")
            get_filename_component(cur "${abs}/${cur}" ABSOLUTE)
        else()
            get_filename_component(cur "${cur}" ABSOLUTE)
        endif()
        if(NOT EXISTS "${cur}")
            message(STATUS "[WARNING] not exist: '${cur}'")
        elseif(IS_DIRECTORY "${cur}")
            message(STATUS "[WARNING] should be file: '${cur}'")
        else()
            list(APPEND tmp "${cur}")
        endif()
    endforeach()
    set(${variable} ${tmp} PARENT_SCOPE)
endfunction()

#-------------------------------------------------------------------------------

function(make_dir_absolute path variable)

    set(abs "${path}")
    if(NOT IS_ABSOLUTE "${abs}")
        message(FATAL_ERROR "must be absolute: '${abs}'")
    endif()

    set(tmp)
    foreach(cur ${${variable}})
        if(NOT IS_ABSOLUTE "${cur}")
            get_filename_component(cur "${abs}/${cur}" ABSOLUTE)
        else()
            get_filename_component(cur "${cur}" ABSOLUTE)
        endif()
        if(NOT EXISTS "${cur}")
            message(STATUS "[WARNING] not exist: '${cur}'")
        elseif(NOT IS_DIRECTORY "${cur}")
            message(STATUS "[WARNING] should be directory: '${cur}'")
        else()
            list(APPEND tmp "${cur}")
        endif()
    endforeach()
    set(${variable} ${tmp} PARENT_SCOPE)
endfunction()

################################################################################
