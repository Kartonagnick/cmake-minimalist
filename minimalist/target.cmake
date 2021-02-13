
# 2020y-05m-24d. Workspace project.
# 2020y-08m-25d. Workspace project.
# 2021y-01m-18d. Workspace project.
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
    cmake_parse_arguments("target" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

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
            view_variables(
                DESCRIPTION "${tNAME}" 
            )
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
    else()
        foreach(cur src source sources)
            if(IS_DIRECTORY "${tDIR_SOURCE}/${cur}")
                list(APPEND tADD_SOURCES "${tDIR_SOURCE}/${cur}")
                list(APPEND tADD_HEADERS "${tDIR_SOURCE}/${cur}")
            endif()
        endforeach()
        if(NOT tADD_SOURCES)
            set(tADD_SOURCES "${tDIR_SOURCE}")
        endif()
        foreach(cur ${tADD_SOURCES})
           cxx_cpp("${cur}" tSOURCES)
        endforeach()
    endif()
#--------
    if(IS_DIRECTORY "${tDIR_SOURCE}/include")
        list(APPEND tINCLUDES    "${tDIR_SOURCE}/include")
        list(APPEND tADD_HEADERS "${tDIR_SOURCE}/include")
    endif()
    if(NOT tADD_HEADERS)
        set(tADD_HEADERS "${tDIR_SOURCE}")
    endif()
    foreach(cur ${tADD_HEADERS})
        cxx_hpp("${cur}" tHEADERS)
    endforeach()
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
    if(tVIEW_RESULT OR gDEBUG)
        view_variables(
            DESCRIPTION "${tNAME}" 
            VARIABLES
                tDIR_SOURCE
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
    if(TARGET "${gNAME_PROJECT}")
        debug_message("${tNAME}: add dependency for '${gNAME_PROJECT}'")
        list(APPEND tDEPENDENCIES "${gNAME_PROJECT}")
    endif()
#--------
    cxx_target("${tNAME}" "${tTYPE}" ${tSOURCES} ${tHEADERS})
    if(tLANGUAGE)
        message(STATUS "${tNAME}: language: '${tLANGUAGE}'")
        set_target_properties(${tNAME} PROPERTIES LINKER_LANGUAGE ${tLANGUAGE})
    endif()
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

        #if(${CMAKE_GENERATOR} MATCHES "Makefiles")
        #    target_link_libraries(${tNAME} PUBLIC ${tDEPENDENCIES} static-libstdc++fs)
        #endif()

    endif()

    # if(MINGW)
    #       target_link_libraries(${tNAME} PUBLIC stdc++fs)
    # endif()
    #target_link_libraries(${tNAME} PRIVATE $<$<AND:$<CXX_COMPILER_ID:GNU>,$<VERSION_LESS:$<CXX_COMPILER_VERSION>,9.0>>:stdc++fs>)

    foreach(libname ${tNAMES_LIBRARIES})
        if(NOT "${gNAME_PROJECT}" STREQUAL "${libname}")
            include("${gPATH_TO_ADD_LIBRARIES}/add_${libname}.cmake")
        endif()
    endforeach()
#--------
    cxx_defines("${tNAME}" "${tTYPE}" ${tPREPROCESSOR})
    cxx_includes("${tNAME}" "${tTYPE}" ${tINCLUDES})
    if(NOT "${tTYPE}" STREQUAL "HEADER_ONLY")
        cxx_ouput_path("${tNAME}" "${tTYPE}" "${tSHORT}")
        cxx_output_pdb("${tNAME}" "${tSHORT}")
        cxx_resources("${tNAME}" tRESOURCES)
        cxx_precompiled("${tNAME}" tHEADERS)
        cxx_bigobj("${tNAME}" "${tTYPE}" "${tSPECIALIZATION}")
    endif()
#--------
    cxx_source_group("${tNAME}" "${tDIR_SOURCE}" tHEADERS)
    cxx_source_group("${tNAME}" "${tDIR_SOURCE}" tSOURCES)
endfunction()

################################################################################

function(_make_target)
    debug_message("  ignore target...")
endfunction()

################################################################################
