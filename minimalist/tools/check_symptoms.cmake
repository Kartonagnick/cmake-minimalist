
# 2020y-08m-21d. Workspace project.
# 2020y-08m-26d. Workspace project.
################################################################################

# import_from_tools(mask2regex)

################################################################################
#
#  Usage:
#
#    mask2regex(regex "_*" "*.h")
#    foreach(r ${regex})
#        message(STATUS "regex: ${r}")
#    endforeach()
#
#  Output: 
#
#    -- regex: $_.*^
#    -- regex: $.*\.h^
#

function(check_symptoms out_result dir)
    # message(STATUS "[check_symptoms] '${dir}'")
    # message(STATUS "  symptoms: '${ARGN}'")
    set(wilds)
    foreach(d ${ARGN})
        # message(STATUS "  (debug) check-symptom: '${d}'")
        string(FIND ${d} "*" result1)
        # message(STATUS "  (debug) result1: '${result1}'")
        if(NOT result1 EQUAL -1)
            list(APPEND wilds ${d})
        else() 
            string(FIND ${d} "?" result2)
            # message(STATUS "  (debug) result2: '${result2}'")
            if(NOT result2 EQUAL -1)
                list(APPEND wilds ${d})
            else()
                if(NOT EXISTS "${dir}/${d}")
                    # message(STATUS "(debug) symptom '${d}' not found")
                    set(${out_result} "" PARENT_SCOPE)
                    return()
                else()
                    # message(STATUS "(debug) symptom '${d}' successfully matched")
                endif()
            endif()
        endif()
    endforeach()

    if(wilds)
        mask2regex(wilds ${wilds})
    else()
        set(${out_result} "ON" PARENT_SCOPE)
        return()
    endif()

    FILE (GLOB content "${dir}/*")
    foreach(w ${wilds})
        set(found)
        foreach(f ${content})
            get_filename_component(name "${f}" NAME)
            if("${name}" MATCHES "${w}")
                set(found ON)
                break()
            else()
                # message(STATUS "(debug) '${name}' VS symptom '${w}' -> skip")
            endif()
        endforeach()
        if(found)
            # message(STATUS "(debug) symptom '${w}' successfully matched")
        else()
            # message(STATUS "(debug) symptom '${w}' not found")
            set(${out_result} "" PARENT_SCOPE)
            return()
        endif()
    endforeach()
    set(${out_result} "ON" PARENT_SCOPE)
endfunction()

################################################################################
