
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

function(cxx_ouput_path_exe target short)

    if(gDEBUG)
        message(STATUS "[output path]")
    endif()

    set(gTARGET_NAME "${target}")    
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

endfunction()


