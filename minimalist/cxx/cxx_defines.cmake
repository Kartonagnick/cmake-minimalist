
# 2019y-01m-23d. Selika. Workspace project.
################################################################################
#
#  Mission:
#    Determine defines of preprocessor
#
################################################################################

function(cxx_defines target type)

    set(defines_ ${ARGN})
    separate_arguments(defines_)

    if(gDEBUG)
        foreach(cur ${defines_})
            message(STATUS "#defines: ${cur}")
        endforeach()
    endif()

    if("${gADDRESS_MODEL}" STREQUAL "64")
        if(MSVC OR MINGW OR CMAKE_GENERATOR MATCHES "[mM][iI][nN][Gg][wW]")
            set(tmp)
            foreach(cur ${defines_})
                if("${cur}" MATCHES "_USE_32BIT_TIME_T")
                    message(STATUS "#defines: '${cur}' removed for x64")
                else()
                    list(APPEND tmp "${cur}")
                endif()
            endforeach()
            set(defines_ ${tmp})

#            list(FIND defines_ "_USE_32BIT_TIME_T" find_)
#            if(find_)
#                message(STATUS "#defines: '_USE_32BIT_TIME_T' removed for x64  (f = ${find_})")
#                list(REMOVE_ITEM defines_ "_USE_32BIT_TIME_T")
#            endif()
        endif()
    endif()

#    message(STATUS "(debug) #defines: ${defines_}")

    if("${type}" STREQUAL "HEADER_ONLY")
        target_compile_definitions(${target} INTERFACE ${defines_})
    else()
        target_compile_definitions(${target} PRIVATE ${defines_})
    endif()

endfunction()

################################################################################

