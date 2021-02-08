
# 2020y-08m-29d. Workspace project.
# 2021y-01m-18d. Workspace project.
################################################################################

# import_from_tools(mask2regex)
# import_from_tools(check_symptoms.cmake)

# import_from_tools(compare_versions.cmake)
# import_from_tools(map.cmake)

################################################################################

#
#  Mission: 
#    Find external library
#
#  Usage:
#    find_external(
#        dir_output
#        "gtest"
#        WHERE_STARTED "external" "../external" 
#        SYMPTOMS "include" "lib-*"
#        MIN_VERSION 1.8.1
#        MAX_VERSION 1.10.x
#        VERSION 1.10.x
#        ONCE
#        DEBUG
#    )
#

################################################################################
################################################################################

macro(debug_find_external)
    if(fnd_DEBUG)
        message(STATUS "(debug) ${ARGN}")
    endif()
endmacro()

function(find_external dir_result ver_result name)

    if("${name}" STREQUAL "")
        message(FATAL_ERROR "empty 'name'")
    endif()

    set(${dir_result} "" PARENT_SCOPE)
    set(${ver_result} "" PARENT_SCOPE)

    # message(STATUS "find_external: '${name}'")

    set(options DEBUG)
    set(oneValueArgs VERSION MIN_VERSION MAX_VERSION)
    set(multiValueArgs WHERE_STARTED SYMPTOMS)

    cmake_parse_arguments(
        "fnd" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
    )

    # if(gDEBUG)
    #      set(fnd_DEBUG ON)
    # endif()
    # set(fnd_DEBUG ON)

    unset(tmp)
    foreach(d ${fnd_WHERE_STARTED})
        get_filename_component(d "${d}" ABSOLUTE)
        list(APPEND tmp "${d}")
    endforeach()
    set(fnd_WHERE_STARTED ${tmp})

    if(fnd_DEBUG)
        view_variables(
            DESCRIPTION "find_externl ${name}" 
            PREFIX      "fnd_"
            VARIABLES   
                ${oneValueArgs} 
                ${multiValueArgs} 
                ${options}
            VIEW_EMPTY
        )
    endif()

    set(dirs)
    foreach(d ${fnd_WHERE_STARTED})
        if(IS_DIRECTORY "${d}/${name}")
            check_symptoms(success "${d}/${name}" "ver-*")
            if(success)
                list(APPEND dirs "${d}/${name}")
            else()
                check_external_symptoms(success "${d}" "${name}")
                if(success)
                    debug_find_external("found-unversion: '${d}'")
                    set(${dir_result} "${d}" PARENT_SCOPE)
                    return()
                else()
                    debug_find_external("skip-unversion: '${d}'")
                endif()
            endif()
        endif()
    endforeach()

    if(NOT dirs)
        debug_find_external("find_external: '${name}' not found")
        return()
    endif()

    debug_find_external("check-version`s directories...")
    foreach(d ${dirs})
        debug_find_external("  [check] '${d}' ...")
        FILE (GLOB content "${d}/ver-*")
        foreach(p ${content})
            debug_find_external("  [check-ver] '${p}' ...")
            if(IS_DIRECTORY "${p}")
                check_external_symptoms(success "${p}" "${name}")
                if(success)
                    get_filename_component(dirversion "${p}" NAME)
                    string(REGEX REPLACE "^ver-" "" dirversion "${dirversion}")
                    map_add(versionsX "${dirversion}" "${success}")
                    debug_find_external("adding: '${dirversion}' -- ${success}")
                else()
                    debug_find_external("missing: '${p}'")
                endif()
            endif()
        endforeach()
    endforeach()

    if(fnd_DEBUG)
        map_view("(debug) founded: " versionsX)
    endif()

    map_trim(versionsX "${fnd_MIN_VERSION}" "${fnd_MAX_VERSION}")
    map_sort_max_min(versionsX)

    if(fnd_DEBUG)
        map_view("(debug) left: " versionsX)
    endif()

    map_front(versionsX key_front val_front)
    map_clean(versionsX)

    debug_find_external("select: '${val_front}'")
    set(${dir_result} "${val_front}" PARENT_SCOPE)
    set(${ver_result} "${key_front}" PARENT_SCOPE)
endfunction()

################################################################################

function(check_external_symptoms out_result dir name)
    if(IS_DIRECTORY "${dir}/${name}")
        set(x "${dir}/${name}")
    else()
        set(x "${dir}")
    endif()
    check_symptoms(success "${x}" ${fnd_SYMPTOMS})
    if(success)
        set(${out_result} "${x}" PARENT_SCOPE)
    else()
        set(${out_result} "" PARENT_SCOPE)
    endif()
endfunction()

################################################################################

function(commit_external name dir_library)

    set(dir "${dir_library}")
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
    set(prefix        "${dir}/lib-${gCOMPILER_TAG}")
    set(path_debug    "${prefix}-debug-${gADDRESS_MODEL}-${gRUNTIME_CPP}"  )
    set(path_relese   "${prefix}-release-${gADDRESS_MODEL}-${gRUNTIME_CPP}")

    target_link_libraries(${tNAME} 
        PUBLIC  "$<$<CONFIG:debug>:${name}${debug_postfix}>"
        PUBLIC  "$<$<CONFIG:release>:${name}>"
    )

    target_link_directories(${tNAME}    
        PUBLIC  "$<$<CONFIG:debug>:${path_debug}>"
        PUBLIC  "$<$<CONFIG:release>:${path_relese}>"
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
