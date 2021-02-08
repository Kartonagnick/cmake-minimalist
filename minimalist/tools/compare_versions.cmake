
# 2020y-08m-19d. Workspace project.
################################################################################

#
#  Usage:
#
#   compare_versions("1.10.1"   "1.10.1"   result)  ### EQUAL
#   compare_versions("1.10.1"   "1.10.2"   result)  ### LESS
#   compare_versions("1.10.2"   "1.10.1"   result)  ### GREATER
#   compare_versions("1.10.1"   "1.10.1.1" result)  ### LESS
#   compare_versions("1.10.x"   "1.10.1"   result)  ### GREATER
#   compare_versions("1.10.x"   "1.10.2"   result)  ### GREATER
#   compare_versions("1.10.x"   "1.10.1"   result)  ### GREATER
#   compare_versions("1.10.x"   "1.10.1.1" result)  ### GREATER
#   compare_versions("1.10.1"   "1.10.x"   result)  ### LESS
#   compare_versions("1.10.1"   "1.10.x"   result)  ### LESS
#   compare_versions("1.10.2"   "1.10.x"   result)  ### LESS
#   compare_versions("1.10.1.1" "1.10.x"   result)  ### LESS
#
#  Output: 
#
#    -- result: EQUAL
#    -- result: LESS
#    -- result: GREATER
#    -- result: LESS
#    -- result: GREATER
#    -- result: GREATER
#    -- result: GREATER
#    -- result: GREATER
#    -- result: LESS
#    -- result: LESS
#    -- result: LESS
#    -- result: LESS
#

#...............................................................................

function(is_uint value result)
    if(${value} MATCHES "^[0-9]+$")
        set(${result} "TRUE" PARENT_SCOPE)
    else()
        set(${result} "FALSE" PARENT_SCOPE)
    endif()
endfunction()

function(compare_versions v1 v2 result)

    if(v1 AND v2)
    else()
        if(v1)
            set(${result} "GREATER" PARENT_SCOPE)
        else()
            set(${result} "LESS" PARENT_SCOPE)
        endif()
        return()
    endif()

    string(REPLACE "." ";" list1 "${v1}")
    string(REPLACE "." ";" list2 "${v2}")

    list(LENGTH	list1 len1)
    list(LENGTH list2 len2)

    if(${len1} LESS ${len2})
         set(len ${len1})
    else()
         set(len ${len2})
    endif()

    math(EXPR len "${len} - 1")

    foreach(index RANGE 0 ${len})

        list(GET list1 ${index} cur1)
        list(GET list2 ${index} cur2)

        is_uint("${cur1}" is_uint_cur1)
        is_uint("${cur2}" is_uint_cur2)

        if(is_uint_cur1 AND is_uint_cur2)
            if(${cur1} EQUAL ${cur2})
                # message(STATUS "${index}) ${cur1} == ${cur2}")
                continue()
            elseif(${cur1} GREATER ${cur2})
                # message(STATUS " ${index}) ${cur1} > ${cur2}")
                set(${result} "GREATER" PARENT_SCOPE)
                return()
            else()
                # message(STATUS "${index}) ${cur1} < ${cur2}")
                set(${result} "LESS" PARENT_SCOPE)
                return()
            endif()

        elseif(NOT is_uint_cur1 AND NOT is_uint_cur2)
            if(${cur1} STREQUAL ${cur2})
                # message(STATUS "${index}) ${cur1} == ${cur2}")
                continue()
            elseif(${cur1} STRGREATER ${cur2})
                # message(STATUS " ${index}) ${cur1} > ${cur2}")
                set(${result} "GREATER" PARENT_SCOPE)
                return()
            else()
                # message(STATUS "${index}) ${cur1} < ${cur2}")
                set(${result} "LESS" PARENT_SCOPE)
                return()
            endif()

        elseif(is_uint_cur1 AND NOT is_uint_cur2)
            # message(STATUS "${index}) ${cur1} < ${cur2} (char)")
            set(${result} "LESS" PARENT_SCOPE)
            return()
        else()
            # message(STATUS "${index}) (char) ${cur1} > ${cur2}")
            set(${result} "GREATER" PARENT_SCOPE)
            return()
        endif()
    endforeach()

    if(${len1} EQUAL ${len2})
        set(${result} "EQUAL" PARENT_SCOPE)
    else()
        if(${len1} LESS ${len2})
            set(${result} "LESS" PARENT_SCOPE)
         else()
            set(${result} "GREATER" PARENT_SCOPE)
         endif()
    endif()
endfunction()

################################################################################
