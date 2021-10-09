
# 2020y-05m-20d. Workspace project.
################################################################################

#
#  Mission:
#    Set target`s output path
#
#  Usage:
#    cxx_ouput_path_exe("${TARGET_NAME}" "EXECUTABLE")
#    cxx_ouput_path_exe("${TARGET_NAME}" "UNIT_TEST")
#

function(cxx_ouput_path_exe target short name_output)

    if(gDEBUG)
        message(STATUS "[output path]")
    endif()

    if(name_output)
        if(gDEBUG)
            message(STATUS "  name_output: ${name_output}")
        endif()
        set(gTARGET_NAME "${name_output}")    
    else()
        set(gTARGET_NAME "${target}")    
    endif()


    if("${target}" MATCHES "${short}")
        set(gTARGET_TYPE "")
    else()
        set(gTARGET_TYPE "${short}")
    endif()
    format_string3("g" "${gDIR_PRODUCT}" output)

    if(gDEBUG)
        message(STATUS "  common: ${output}")
    endif()

    set_target_properties(${target} 
        PROPERTIES 
        RUNTIME_OUTPUT_DIRECTORY "${output}"
    )

    foreach(conf ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${conf} CONFIG ) 
        set(gBUILD_TYPE ${conf})
        format_string3("g" "${gDIR_PRODUCT}" output)
        if(gDEBUG)
            message(STATUS "  ${conf}: ${output}")
        endif()
        set_target_properties(${target} 
            PROPERTIES 
            RUNTIME_OUTPUT_DIRECTORY_${CONFIG} 
            "${output}"
        )
    endforeach()

    if(name_output)
        set_target_properties(${target} 
            PROPERTIES OUTPUT_NAME "${name_output}"
        )
        foreach(conf ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${conf} CONFIG ) 
            set_target_properties(${target} 
                PROPERTIES OUTPUT_NAME "${name_output}"
            )
        endforeach()
    endif()

endfunction()


