
# 2020y-05m-22d. Workspace project.
################################################################################

#
#  Mission:
#    Set precompile header
#
#  Usage:
#    cxx_precompiled(sampleTarget "C:/project/sample/source/pch.hpp")
#

################################################################################

function(cxx_add_precompiled target path_to_header)

    if(NOT IS_ABSOLUTE "${path_to_header}")
        message(FATAL_ERROR "must be absolute: '${path_to_header}'")
    endif()

    if(NOT EXISTS "${path_to_header}")
        message(FATAL_ERROR "not exist: '${path_to_header}'")
    endif()

    if(IS_DIRECTORY "${path_to_header}")
        message(FATAL_ERROR "must be file: '${path_to_header}'")
    endif()

    if(gDEBUG)
        message(STATUS "[precompiled]")
        message(STATUS "  ${path_to_header}")
    endif()

    target_precompile_headers(${tNAME} PRIVATE
        "$<$<COMPILE_LANGUAGE:CXX>:${path_to_header}>"
    )

    if("${type}" STREQUAL "HEADER_ONLY")
        target_compile_definitions(${target} INTERFACE "dPCH_USED=1")
    else()
        target_compile_definitions(${target} PRIVATE "dPCH_USED=1")
    endif()

endfunction()

################################################################################

function(cxx_find_precompiled var_headers var_result)
    foreach(cur ${${var_headers}})
        get_filename_component(name "${cur}" NAME_WE)
        foreach(check pch stdafx precompiled)
            if("${check}" STREQUAL "${name}")
                set(${var_result} "${cur}" PARENT_SCOPE)
                return()
            endif()
        endforeach()
    endforeach()		
endfunction()

################################################################################

function(cxx_precompiled target var_headers)
    foreach(cur ${${var_headers}})
        get_filename_component(name "${cur}" NAME_WE)
        foreach(check pch stdafx precompiled)
            if("${check}" STREQUAL "${name}")
                cxx_add_precompiled("${target}" "${cur}")
                return()
            endif()
        endforeach()
    endforeach()		
endfunction()

################################################################################
