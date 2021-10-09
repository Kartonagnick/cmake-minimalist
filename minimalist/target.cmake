# [2021y-05m-20d][00:40:03] Idrisov D. R.
# 2021y-01m-18d. Workspace project.
# 2020y-08m-25d. Workspace project.
# 2020y-05m-24d. Workspace project.
################################################################################
# import_from_tools(view_variables)
# import_from_tools(format_string)
# import_from_tools(absolute make_file_absolute)
# include("${CMAKE_CURRENT_LIST_DIR}/cxx/cxx.cmake")
################################################################################

set(gPATH_TO_ADD_LIBRARIES "${CMAKE_CURRENT_LIST_DIR}/add")

macro(detect_target_path)
    if(tDIR_SOURCE)
        file(TO_CMAKE_PATH "${tDIR_SOURCE}" tDIR_SOURCE)
        format_string3("g" "${tDIR_SOURCE}" tDIR_SOURCE)
        file(TO_CMAKE_PATH "${tDIR_SOURCE}" tDIR_SOURCE)

        if(NOT IS_ABSOLUTE "${tDIR_SOURCE}") 
            get_filename_component(tDIR_SOURCE "${gDIR_SOURCE}/${tDIR_SOURCE}" ABSOLUTE)
        else()
            get_filename_component(tDIR_SOURCE "${tDIR_SOURCE}" ABSOLUTE)
        endif()
    else()
        set(tDIR_SOURCE ${gDIR_SOURCE})  
    endif() 

    if(NOT IS_DIRECTORY "${tDIR_SOURCE}")
        message(FATAL_ERROR "must be directory: '${tDIR_SOURCE}'")     
    endif()
endmacro()

################################################################################

#
#  Mission:
#    Make target of build
#
#  Usage:
#    make_target()
#
#    make_target(
#        PATH_TO_SOURCES "${gPATH_TO_SOURCES}/sample"
#    )
#
#  Prerequisites:
#    include(${CMAKE_CURRENT_LIST_DIR}/../tools/view_variables.cmake)
#

function(make_target)

    # set(options HEADER_ONLY VIEW_RESULT)
    set(options VIEW_RESULT)

    set(oneValueArgs 
        PATH_TO_SOURCES
        SPECIALIZATION
        LANGUAGE
        OUTPUT
        SHORT
        NAME
        TYPE
    )
    set(multiValueArgs 
        INCLUDES HEADERS SOURCES 
        RESOURCES PREPROCESSOR DEPENDENCIES 
        PATHS_LIBRARIES NAMES_LIBRARIES
        ADD_HEADERS ADD_SOURCES 
    )

    cmake_parse_arguments("target" "${options}" "${oneValueArgs}" 
        "${multiValueArgs}" ${ARGN}
    )

    foreach(variable ${options} ${oneValueArgs} ${multiValueArgs})
        set(t${variable} ${target_${variable}}) 
        # message(STATUS "parse: t${variable} = ${t${variable}}")
        unset(target_${variable})
    endforeach()

    set(tDIR_SOURCE ${tPATH_TO_SOURCES})

#--------
    detect_target_path()
#--------
    if(NOT tNAME)
        get_filename_component(tNAME "${tDIR_SOURCE}" NAME)
    endif() 
#--------
    if(TARGET ${tNAME})
        if(tVIEW_RESULT OR gDEBUG)
            view_variables(DESCRIPTION "${tNAME}")
            message(STATUS "already processed -> skip")
        endif()
        return()
    endif()
#--------
    set(src "${tDIR_SOURCE}")
    make_file_absolute("${src}" tHEADERS)
    make_file_absolute("${src}" tSOURCES)
    make_dir_absolute("${src}" tINCLUDES)
    make_dir_absolute("${src}" tRESOURCES)
    make_dir_absolute("${src}" tADD_HEADERS)
    make_dir_absolute("${src}" tADD_SOURCES)
#--------
    if(tHEADER_ONLY)
        set(tTYPE "HEADER_ONLY")
    elseif("${tTYPE}" STREQUAL "HEADER_ONLY")
        #--- skip
    else()
        foreach(cur src source sources)
            if(IS_DIRECTORY "${tDIR_SOURCE}/${cur}")
                list(APPEND tADD_SOURCES "${tDIR_SOURCE}/${cur}")
                list(APPEND tADD_HEADERS "${tDIR_SOURCE}/${cur}")
            endif()
        endforeach()
#        if(NOT tADD_SOURCES)
#            set(tADD_SOURCES "${tDIR_SOURCE}")
#        endif()
        foreach(cur ${tADD_SOURCES})
           cxx_cpp("${cur}" tSOURCES)
        endforeach()
    endif()
#--------
    if(IS_DIRECTORY "${tDIR_SOURCE}/include")
        list(APPEND tINCLUDES    "${tDIR_SOURCE}/include")
        list(APPEND tADD_HEADERS "${tDIR_SOURCE}/include")
    endif()
#    if(NOT tADD_HEADERS)
#        set(tADD_HEADERS "${tDIR_SOURCE}")
#    endif()
    foreach(cur ${tADD_HEADERS})
        cxx_hpp("${cur}" tHEADERS)
    endforeach()
    cxx_find_precompiled(tHEADERS tPRECOMPILED)
#--------
    foreach(dir resource resources)
        if(IS_DIRECTORY "${tDIR_SOURCE}/${dir}")
            list(APPEND tRESOURCES "${tDIR_SOURCE}/${dir}")
        endif()
    endforeach()
    if(tRESOURCES)
        list(REMOVE_DUPLICATES tRESOURCES)
    endif()
#--------
    if(NOT tTYPE)
        cxx_detect_type(tSOURCES tTYPE)
    endif()
    if("${tTYPE}" STREQUAL "HEADER_ONLY")
        set(tSPECIALIZATION)
    else()
        cxx_specialize("${tNAME}" tSPECIALIZATION)
    endif()
    cxx_short_type("${tTYPE}" "${tSPECIALIZATION}" tSHORT)
#--------
    if("${tSPECIALIZATION}" STREQUAL "UNIT_TEST")
        list(APPEND tNAMES_LIBRARIES "unit_test")
    endif()
#--------
    if(gDEFINES)
        list(APPEND tPREPROCESSOR ${gDEFINES})
        list(REMOVE_DUPLICATES tPREPROCESSOR)
    endif()
#--------
    set(gTARGETS_TYPE_${tNAME} "${tTYPE}" PARENT_SCOPE)
#--------
    if(tVIEW_RESULT OR gDEBUG)
        view_variables(
            DESCRIPTION "${tNAME}" 
            VARIABLES
                tDIR_SOURCE
                tOUTPUT
                tNAME
                tTYPE
                tSHORT
                tSPECIALIZATION
                tINCLUDES
                tHEADERS
                tSOURCES
                tRESOURCES
                tPREPROCESSOR
                tDEPENDENCIES 
                tPATHS_LIBRARIES
                tNAMES_LIBRARIES
                tADD_HEADERS
                tADD_SOURCES
                # tLANGUAGE
           VIEW_EMPTY
        )
    endif()
#--------
    if(tPRECOMPILED)
        if(NOT tSOURCES)
            set(tDUMMY "${CMAKE_BINARY_DIR}/dummy.cpp")
            if(NOT EXISTS "${tDUMMY}")
                debug_message("${tNAME}: create dummy.cpp")
                debug_message("${tNAME}: ${tDUMMY}")
                file(WRITE  "${tDUMMY}" "// workspace project\n")
                file(APPEND "${tDUMMY}" "// this file was created automatically\n")
                file(APPEND "${tDUMMY}" "// to support precompiled header\n")
                file(APPEND "${tDUMMY}" "// for header-only libraries\n")
            endif()
        endif()
    endif()
#--------
    cxx_target("${tNAME}" "${tTYPE}" ${tSOURCES} ${tHEADERS} ${tDUMMY})
    if(tLANGUAGE)
        message(STATUS "${tNAME}: language: '${tLANGUAGE}'")
        set_target_properties(${tNAME} PROPERTIES LINKER_LANGUAGE ${tLANGUAGE})
    endif()
#--------

if(TARGET "${gNAME_PROJECT}")
    if(NOT "${tNAME}" STREQUAL "${gNAME_PROJECT}")
        get_target_property(master_type ${gNAME_PROJECT} TYPE)
        if (${master_type} STREQUAL "INTERFACE_LIBRARY")
            if("${tTYPE}" STREQUAL "HEADER_ONLY")
                debug_message("${tNAME}: add headers from header-only '${gNAME_PROJECT}'")
                target_link_libraries(${tNAME} INTERFACE ${gNAME_PROJECT})
            else()
                debug_message("${tNAME}: add depency from headr-only '${gNAME_PROJECT}'")
                target_link_libraries(${tNAME} PUBLIC ${gNAME_PROJECT})
            endif()
        else()
            debug_message("${tNAME}: add depency '${gNAME_PROJECT}'")    
            target_link_libraries(${tNAME} PUBLIC ${gNAME_PROJECT})
        endif()
    endif()
endif()
    

#    if(TARGET "${gNAME_PROJECT}")
#        set(gTYPE_MASTER "${gTARGETS_TYPE_${gNAME_PROJECT}}")
#        if(gTYPE_MASTER)
#            if("${gTYPE_MASTER}" STREQUAL "HEADER_ONLY")
#                debug_message("${tNAME}: add headers from '${gNAME_PROJECT}'")
#                target_link_libraries(${tNAME} PUBLIC ${gNAME_PROJECT})
#                #target_link_libraries(${tNAME} INTERFACE ${gNAME_PROJECT})
#
#            elseif("${gTYPE_MASTER}" STREQUAL "STATIC_LIBRARY")
#                debug_message("${tNAME}: add depency '${gNAME_PROJECT}'")
#                target_link_libraries(${tNAME} PUBLIC ${gNAME_PROJECT})
#
#            else()
#                debug_message("${tNAME}: ignore '${gNAME_PROJECT}' its type is incompatible: ${gTYPE_MASTER}")
#            endif()
#        endif()
#    endif()
#--------
    cxx_def("${tNAME}" "${tTYPE}" "${tADD_SOURCES}")
#--------
    set(local_)
    set(external_)
    foreach(libname ${tDEPENDENCIES})
        if("${gNAME_PROJECT}" STREQUAL "${libname}")
            # message(STATUS "(debug) ${libname} VS ${gNAME_PROJECT} -> local (by gNAME_PROJECT)")
            list(APPEND local_ "${libname}")
        elseif(TARGET "${libname}")
            # message(STATUS "(debug) ${libname} VS ${gNAME_PROJECT} -> local (by TARGET)")
            list(APPEND local_ "${libname}")
        elseif(NOT EXISTS "${gPATH_TO_ADD_LIBRARIES}/add_${libname}.cmake")
            # message(STATUS "(debug) ${libname} VS ${gNAME_PROJECT} -> local (add_${libname} not found)")
            list(APPEND local_ "${libname}")
        else()
            # message(STATUS "(debug) ${libname} -> external")
            list(APPEND external_ "${libname}")
        endif()
    endforeach()

    list(APPEND tNAMES_LIBRARIES ${external_})
    set(tDEPENDENCIES ${local_})
    unset(local_)
    unset(external_)

    if(tDEPENDENCIES)
        list(REMOVE_DUPLICATES tDEPENDENCIES)
        target_link_libraries(${tNAME} PUBLIC ${tDEPENDENCIES})
    endif()

    foreach(libname ${tNAMES_LIBRARIES})
        if(NOT "${gNAME_PROJECT}" STREQUAL "${libname}")
            include("${gPATH_TO_ADD_LIBRARIES}/add_${libname}.cmake")
        endif()
    endforeach()
#--------
    if(NOT tOUTPUT)
        set(tOUTPUT "${tNAME}")
    endif()

    cxx_defines("${tNAME}" "${tTYPE}" ${tPREPROCESSOR})
    cxx_includes("${tNAME}" "${tTYPE}" ${tINCLUDES})
    if(NOT "${tTYPE}" STREQUAL "HEADER_ONLY")
        cxx_ouput_path("${tNAME}" "${tTYPE}" "${tSHORT}" "${tOUTPUT}")
        cxx_output_pdb("${tNAME}" "${tSHORT}" "${tOUTPUT}")
        cxx_resources("${tNAME}" tRESOURCES)
        cxx_bigobj("${tNAME}" "${tTYPE}" "${tSPECIALIZATION}")
    endif()

    if(tPRECOMPILED)
        cxx_add_precompiled("${tNAME}" "${tPRECOMPILED}")
    endif()
#--------
    cxx_source_group("${tNAME}" "${tDIR_SOURCE}" tHEADERS)
    cxx_source_group("${tNAME}" "${tDIR_SOURCE}" tSOURCES)

    unset(tVIEW_RESULT)
    unset(tPATH_TO_SOURCES)
    unset(tSPECIALIZATION)
    unset(tLANGUAGE)
    unset(tOUTPUT)
    unset(tSHORT)
    unset(tNAME)
    unset(tTYPE)

    unset(tINCLUDES)
    unset(tHEADERS)
    unset(tSOURCES)
    unset(tRESOURCES)
    unset(tPREPROCESSOR)
    unset(tDEPENDENCIES)
    unset(tPATHS_LIBRARIES)
    unset(tNAMES_LIBRARIES)

    unset(ADD_HEADERS)
    unset(ADD_SOURCES)
    unset(tDIR_SOURCE)
endfunction()

################################################################################

function(_make_target)
    debug_message("  ignore target...")
endfunction()

################################################################################
