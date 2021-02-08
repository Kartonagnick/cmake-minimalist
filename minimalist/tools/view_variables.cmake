
# 2020y-05m-14d. Workspace project.
################################################################################
#
#  Mission:
#    Beautifuly console output with data alignment
#
#  Usage:
#    view_variables(
#        DESCRIPTION "description" 
#        VARIABLES   INCLUDES HEADERS SOURCES
#        PREFIX      "target"
#        POINTS      "3"
#        VIEW_EMPTY
#    )
#
################################################################################

function(view_variables)
    cmake_parse_arguments(
        "view" 
        "VIEW_EMPTY;BLOCK" 
        "DESCRIPTION;PREFIX;POINTS;MAX_ITEMS" 
        "VARIABLES" 
        ${ARGN}
    )

    if(NOT view_MAX_ITEMS)
        set(view_MAX_ITEMS 10)
    endif()

    if(view_DESCRIPTION)
        message(STATUS "==================[${view_DESCRIPTION}]==================")
    else() 
        message(STATUS "==================[info]==================")
    endif()
    set(need_empty_line ON)

    set(maxlength 0)
    set(etalon_view_result "..................................................................................................")
    foreach(variable ${view_VARIABLES})
        string(LENGTH "${variable}" len)
        if(len GREATER maxlength)
            set(maxlength "${len}")
        endif()
    endforeach()

    set(points 3)
    if(view_POINTS)
        set(points "${view_POINTS}")
    endif()
    math(EXPR maxlength "${maxlength} + ${points}")

    foreach(variable ${view_VARIABLES})
        if(view_PREFIX)
            set(my_variable ${view_PREFIX}${variable})
        else()
            set(my_variable ${variable})
        endif()

        if(${my_variable})
            set(value "${${my_variable}}")              
            list(LENGTH ${my_variable} count)

            if(count GREATER 1)

                if(count LESS ${view_MAX_ITEMS})
                    set(max_count ${count})
                else()
                    set(max_count ${view_MAX_ITEMS})
                endif()

                set(index 1)
                message(STATUS "")

                if(view_BLOCK)
                    message(STATUS "  [${variable}]")
                else()
                    message(STATUS "  ${variable}" )
                endif()
 
                foreach(element ${value})
                    if(index LESS ${max_count})
                        message(STATUS "    |--- ${element}")
                    else()
                        if(index EQUAL ${count})
                            message(STATUS "     `-- ${element}")
                        else()
                            message(STATUS "    |--- ${element}")
                            message(STATUS "     `-- (more ${view_MAX_ITEMS} items...)")
                            break()
                        endif()
                    endif()
                    math(EXPR index "${index} + 1" )
                endforeach()
                set(need_empty_line ON)   
            else()
                string(LENGTH "${value}" len)
                if(len GREATER 50 OR view_BLOCK)
                    message(STATUS "")
                    if(view_BLOCK)
                        message(STATUS "  [${variable}]")
                    else()
                        message(STATUS "  ${variable}" )
                    endif()
                    message(STATUS "     `-- ${value}")
                    set(need_empty_line ON)   
                else()
                    if(need_empty_line)   
                        message(STATUS "")                
                        unset(need_empty_line)
                    endif()
                    string(LENGTH "${variable}" len)
                    math(EXPR len "${maxlength} - ${len}")
                    string(SUBSTRING "${etalon_view_result}" 0 "${len}" offset_view_result)
                    message(STATUS "  ${variable} ${offset_view_result} ${value}")
                endif()
            endif()
        else()
            if(view_VIEW_EMPTY)
                if(need_empty_line)   
                    message(STATUS "")                
                    unset(need_empty_line)
                endif()
                string(LENGTH "${variable}" len)
                math(EXPR len "${maxlength} - ${len}")
                string(SUBSTRING "${etalon_view_result}" 0 "${len}" offset_view_result)
                message(STATUS "  ${variable} ${offset_view_result} (none value)")
            endif()
        endif()
    endforeach()
    message(STATUS "")                
endfunction()

################################################################################
