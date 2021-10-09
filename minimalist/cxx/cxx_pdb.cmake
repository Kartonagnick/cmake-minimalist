
# 2020y-05m-22d. Workspace project.
################################################################################

#
#  Mission:
#    Set path/name to output pdb file
#
#  Usage:
#    cxx_path_pdb(sampleTarget "C:\pdb")
#    cxx_name_pdb(sampleTarget "sample.pdb")
#

function(cxx_path_pdb target path_destination)

    if(NOT IS_ABSOLUTE ${path_destination})
        message(FATAL_ERROR "must be absolute: '${path_destination}'")
    endif()

    if(gDEBUG)
        message(STATUS "  pdb-directory: '${path_destination}'")
    endif()

    set_target_properties(${target} 
        PROPERTIES 
        PDB_OUTPUT_DIRECTORY 
        "${path_destination}"
    )

    foreach(conf ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${conf} CONFIG ) 
        set_target_properties(${target} 
            PROPERTIES 
            PDB_OUTPUT_DIRECTORY_${CONFIG} 
            "${path_destination}"
        )
    endforeach()

endfunction()

#-------------------------------------------------------------------------------

function(cxx_name_pdb target name)

    set(newName ${name})

    if(NOT newName)
        message(FATAL_ERROR "cxx_pdb_name: 'name' is not specified")
    endif()

    get_filename_component(ext "${newName}" EXT)
    if("${ext}" STREQUAL ".pdb")
        string(LENGTH "${newName}" len)
        math(EXPR len "${len} - 4")
        string(SUBSTRING "${name}" 0 ${len} newName)
    endif()

    if(gDEBUG)
        message(STATUS "  pdb-name: '${newName}.pdb'")
    endif()

    set_target_properties(${target} 
        PROPERTIES PDB_NAME "${newName}"
    )

    foreach(conf ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${conf} CONFIG ) 
        set_target_properties(${target} 
            PROPERTIES PDB_NAME_${CONFIG} "${newName}"
        )
    endforeach()
endfunction()

function(cxx_output_pdb target short name_output)
    if(gDEBUG)
        message(STATUS "[output pdb]")
    endif()

    if(name_output)
        if(gDEBUG)
            message(STATUS "  name_output: ${name_output}")
        endif()
        set(gTARGET_NAME "${name_output}")    
        set(name_pdb_output "${name_output}")    
    else()
        set(gTARGET_NAME "${target}")    
        set(name_pdb_output "${target}")    
    endif()


    if("${target}" MATCHES "${short}")
        set(gTARGET_TYPE "")
    else()
        set(gTARGET_TYPE "${short}")
    endif()

    format_string3("g" "${gDIR_PRODUCT}" output)

    if(gDEBUG)
        message(STATUS "  pdb-common: ${output}")
    endif()

    set_target_properties(${target} 
        PROPERTIES 
        COMPILE_PDB_NAME     "${name_pdb_output}"
        PDB_OUTPUT_DIRECTORY "${output}"
    )
    foreach(conf ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${conf} CONFIG ) 
        set(gBUILD_TYPE ${conf})
        format_string3("g" "${gDIR_PRODUCT}" output)
        if(gDEBUG)
            message(STATUS "  pdb-${conf}: ${output}")
        endif()
        set_target_properties(${target} 
            PROPERTIES 
            COMPILE_PDB_NAME "${name_pdb_output}"
            PDB_OUTPUT_DIRECTORY_${CONFIG} 
            "${output}"
        )
    endforeach()
endfunction()

