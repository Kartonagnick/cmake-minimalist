
# 2020y-05m-20d. Workspace project.
################################################################################

#
#  Mission:
#    Set target`s output path
#
#  Usage:
#    cxx_ouput_path_lib("${TARGET_NAME}" "STATIC_LIBRARY")
#

function(cxx_ouput_path_lib target short name_output)

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

    if("${gTARGET_NAME}" MATCHES "${short}")
        set(gTARGET_TYPE "")
    else()
        set(gTARGET_TYPE "${short}")
    endif()

    set(d_product "${gDIR_PRODUCT}/${gSUFFIX}")
    format_string3("g" "${d_product}" output)

    if(gDEBUG)
        message(STATUS "  common: ${output}")
    endif()

    set_target_properties(${target} 
        PROPERTIES 
        ARCHIVE_OUTPUT_DIRECTORY "${output}"
    )

    foreach(conf ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${conf} CONFIG ) 
        set(gBUILD_TYPE ${conf})
        format_string3("g" "${d_product}" output)
        if(gDEBUG)
            message(STATUS "  ${conf}: ${output}")
        endif()
        set_target_properties(${target} 
            PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_${CONFIG} "${output}"
        )
    endforeach()

    if(name_output)
        set_target_properties(${target} 
            PROPERTIES OUTPUT_NAME "${name_output}"
        )
        foreach(conf ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${conf} CONFIG ) 
            set_target_properties(${target} 
                PROPERTIES OUTPUT_NAME_${CONFIG} "${name_output}"
            )
        endforeach()
    endif()

endfunction()


