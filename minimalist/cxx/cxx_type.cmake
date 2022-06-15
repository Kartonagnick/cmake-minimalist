
# 2020y-05m-21d. Workspace project.
################################################################################

#
#  Mission:
#    Detect type of target
#

function(cxx_detect_type var_sources var_output)
    set(has_cpp)
    foreach(cpp ${${var_sources}})
        get_filename_component(ext "${cpp}" EXT)
        foreach(check .cpp .cc .cxx .c)
            if("${ext}" STREQUAL "${check}")
                set(has_cpp TRUE)
                get_filename_component(name "${cpp}" NAME_WE)
                if("${name}" STREQUAL "main")
                    set(${var_output}  "EXECUTABLE" PARENT_SCOPE) 
                    return()
                elseif("${name}" STREQUAL "dllmain")
                    set(${var_output}  "SHARED_LIBRARY" PARENT_SCOPE) 
                    return()
                endif()
            endif()
        endforeach()
    endforeach()
    if(has_cpp)
        set(${var_output} "STATIC_LIBRARY" PARENT_SCOPE) 
    elseif(tPRECOMPILED)
        set(${var_output} "STATIC_LIBRARY" PARENT_SCOPE) 
    else()
        set(${var_output} "HEADER_ONLY" PARENT_SCOPE) 
    endif()
    unset(has_cpp)
endfunction()

#-------------------------------------------------------------------------------

function(cxx_specialize target var_output)

    if(${var_output})
        return()
    endif()

    file(RELATIVE_PATH PATH_LIST "${gDIR_SOURCE}" "${target}")
    string(REPLACE "/"  ";" PATH_LIST "${PATH_LIST}")
    string(REPLACE "\\" ";" PATH_LIST "${PATH_LIST}")

    foreach(dir ${PATH_LIST})
        if("${dir}" MATCHES "test")
            set(${var_output} "UNIT_TEST" PARENT_SCOPE)
            return()

        elseif("${dir}" MATCHES "test_.*")
            set(${var_output} "UNIT_TEST" PARENT_SCOPE)
            return()

        elseif("${dir}" MATCHES ".*_test")
            set(${var_output} "UNIT_TEST" PARENT_SCOPE)
            return()

        elseif("${dir}" MATCHES "test-.*")
            set(${var_output} "UNIT_TEST" PARENT_SCOPE)
            return()

        elseif("${dir}" MATCHES ".*-test")
            set(${var_output} "UNIT_TEST" PARENT_SCOPE)
            return()
       endif()
    endforeach()
    set(${var_output} "" PARENT_SCOPE)
endfunction()

#-------------------------------------------------------------------------------

#
#  Mission:
#    Get short-tag type of target
#

function(cxx_short_type type spec var_output)

    if(${var_output})
        return()
    endif()

    if("${type}" STREQUAL "EXECUTABLE")
        if("${spec}" STREQUAL "UNIT_TEST")
            set(${var_output} "test" PARENT_SCOPE) 
        else()
            set(${var_output} "bin" PARENT_SCOPE) 
        endif()

    elseif("${type}" STREQUAL "SHARED_LIBRARY")
        if(MSVC)
            set(${var_output} "dll" PARENT_SCOPE) 
        else()
            set(${var_output} "so" PARENT_SCOPE) 
        endif()

    elseif("${type}" STREQUAL "STATIC_LIBRARY")
        set(${var_output} "lib" PARENT_SCOPE) 

    elseif("${type}" STREQUAL "HEADER_ONLY")
        set(${var_output} "hpp" PARENT_SCOPE) 
    else()
        message(FATAL_ERROR "invalid type of target: '${type}'")
    endif()
endfunction()

#-------------------------------------------------------------------------------

function(cxx_target name type)

    if("${type}" STREQUAL "EXECUTABLE")
        add_executable(${name} ${ARGN})

    elseif("${type}" STREQUAL "STATIC_LIBRARY")
        add_library(${name} STATIC ${ARGN})

    elseif("${type}" STREQUAL "SHARED_LIBRARY")
        add_library(${name} SHARED ${ARGN})

    elseif("${type}" STREQUAL "HEADER_ONLY")
        add_library("${name}" INTERFACE)
        target_compile_definitions("${name}" INTERFACE LIBRARY_HEADER_ONLY)
    else()
        message(FATAL_ERROR "invalid type: '${type}'")
    endif()

endfunction()

#-------------------------------------------------------------------------------
