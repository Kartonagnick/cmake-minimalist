
# 2020y-08m-29d. Workspace project.
# 2021y-02m-08d. Workspace project.
################################################################################

# import_from_tools(compare_versions.cmake)

################################################################################

#
#  Mission:
#    Associative array
#
#  Usage:
#    map_set(versions "version1" "${path1}")   # add or update
#    map_add(versions "version2" "${path2}")   # if exist -> ignore
#    map_get(versions "version2" out_path)
#
#    map_view(example)
#
#    map_trim(example "1.8.1"  "1.8.9")
#    map_sort_min_max(example)
#    map_sort_max_min(example)
#    map_copy(example dst)
#  
#    foreach(val ${dst})
#        message(STATUS "version: ${val}")
#    endforeach()
#
#    map_front(example key_f front)
#    map_back(example  key_b back )
#
#    message(STATUS "key: ${key_f}; front: ${front}")
#    message(STATUS "key: ${key_b}; back: ${front}" )
#

################################################################################
################################################################################

function(map_set name key value)
    string(REGEX REPLACE " " "_" name_ ${name})
    string(REGEX REPLACE " " "_" key_  ${key} )

    set(map__${name_}__${key_} "${value}" PARENT_SCOPE)

    list(FIND mapkeys__${name_} "${key_}" index_)
    if("${index_}" STREQUAL "-1")
        list(APPEND mapkeys__${name_} "${key_}")
    endif()

    set(mapkeys__${name_} ${mapkeys__${name_}}  PARENT_SCOPE)
endfunction()

function(map_add name key value)
    string(REGEX REPLACE " " "_" name_ ${name})
    string(REGEX REPLACE " " "_" key_  ${key} )

    list(FIND mapkeys__${name_} "${key_}" index_)
    if(NOT "${index_}" STREQUAL "-1")
        return()
    endif()

    list(APPEND mapkeys__${name_} "${key_}")
    set(map__${name_}__${key_} "${value}" PARENT_SCOPE)
    set(mapkeys__${name_} ${mapkeys__${name_}}  PARENT_SCOPE)
endfunction()

function(map_get name key out_value)
    string(REGEX REPLACE " " "_" name_ ${name})
    string(REGEX REPLACE " " "_" key_  ${key} )
    set(${out_value} "${map__${name_}__${key_}}" PARENT_SCOPE)
endfunction()

function(map_sort_min_max name)
    string(REGEX REPLACE " " "_" name_ ${name})
    set(container mapkeys__${name_})
    sort_versions_min_to_max(${container} ${${container}})
    set(${container} ${${container}} PARENT_SCOPE)
endfunction()

function(map_sort_max_min name)
    string(REGEX REPLACE " " "_" name_ ${name})
    set(container mapkeys__${name_})
    sort_versions_max_to_min(${container} ${${container}})
    set(${container} ${${container}} PARENT_SCOPE)
endfunction()

function(map_copy name out_result)
    string(REGEX REPLACE " " "_" name_ ${name})
    set(dst_list)
    foreach(key ${mapkeys__${name_}})
        set(val "${map__${name_}__${key}}")
        if(val)
            list(APPEND dst_list ${val})
        endif()
    endforeach()
    set(${out_result} ${dst_list} PARENT_SCOPE)
endfunction()

function(map_clean name)
    string(REGEX REPLACE " " "_" name_ ${name})
    set(dst_list)
    foreach(key ${mapkeys__${name_}})
        set(map__${name_}__${key} "" PARENT_SCOPE)
    endforeach()
    set(mapkeys__${name_} "" PARENT_SCOPE)
endfunction()

function(map_front name out_key out_value)
    string(REGEX REPLACE " " "_" name_ ${name})
    list(GET mapkeys__${name_} 0 key)
    set(val "${map__${name_}__${key}}")
    set(${out_key}   ${key} PARENT_SCOPE)
    set(${out_value} ${val} PARENT_SCOPE)
endfunction()

function(map_back name out_key out_value)
    string(REGEX REPLACE " " "_" name_ ${name})
    list(LENGTH mapkeys__${name_} count)
    math(EXPR count "${count} - 1")
    list(GET mapkeys__${name_} ${count} key)    
    set(val "${map__${name_}__${key}}")
    set(${out_key}   ${key} PARENT_SCOPE)
    set(${out_value} ${val} PARENT_SCOPE)
endfunction()

function(map_trim name min_val max_val)
    string(REGEX REPLACE " " "_" name_ ${name})
    if(NOT mapkeys__${name_})
        return()
    endif()
     
    if(min_val)
        set(keys)
        foreach(key ${mapkeys__${name_}})
            compare_versions("${key}" "${min_val}" result_compare)
            if(result_compare STREQUAL "LESS")
                set(${map__${name_}__${key}} "" PARENT_SCOPE)
            else()
                list(APPEND keys "${key}")
            endif()
         endforeach()
    else()
        set(keys ${mapkeys__${name_}})
    endif()

    if(max_val)
        set(tmp)
        foreach(key ${keys})
            compare_versions("${key}" "${max_val}" result_compare)
            if(result_compare STREQUAL "GREATER")
                set(${map__${name_}__${key}} "" PARENT_SCOPE)
            else()
                list(APPEND tmp "${key}")
            endif()
        endforeach()
    else()
        set(tmp ${keys})
    endif()

    set(mapkeys__${name_} ${tmp} PARENT_SCOPE)
endfunction()

function(map_view title name)
    string(REGEX REPLACE " " "_" name_ ${name})
    set(keys ${mapkeys__${name_}})

    if(NOT mapkeys__${name_})
        message(STATUS "${title}empty")
        return()
    endif()

    foreach(key ${mapkeys__${name_}})
        set(val ${map__${name_}__${key}})
        message(STATUS "${title}${key} === ${val}")
    endforeach()
endfunction()

################################################################################
################################################################################
