
# 2019y-01m-22d. Selika. Workspace project.
################################################################################

#
#  Mission:
#    Sets the runtime (static/dynamic) for msvc/gcc
#
#  Usage:
#    cxx_runtime()
#        by default used 'gLINK_RUNTIME_CPP'
#
#    cxx_runtime("dynamicRuntimeCPP")
#

macro(cxx_runtime target value)

    if(gDEBUG)
        message(STATUS "[runtime c++] '${value}'"
    endif()

    if("${value}" STREQUAL "static")

    elseif("${value}" STREQUAL "dynamic")

    else()
        message(FATAL_ERROR "invalid value of runtime cpp: '${value}'")
    endif()

    if(MSVC)
        cxx_runtime_msvc(value)
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        message(AUTHOR_WARNING "does not support clang yet!")
    else()
        cxx_runtime_gnu(value)
    endif()
endmacro()    

################################################################################

macro(cxx_runtime_msvc)
    if(${value} STREQUAL "dynamicRuntimeCPP")
        string(REPLACE "/MT" "/MD" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
        foreach(config ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${config} config)
            string(REPLACE "/MT" "/MD" CMAKE_CXX_FLAGS_${config} "${CMAKE_CXX_FLAGS}")
        endforeach()
    elseif(${value} STREQUAL "staticRuntimeCPP")
        string(REPLACE "/MD" "/MT" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
        foreach(config ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${config} config)
            string(REPLACE "/MD" "/MT" CMAKE_CXX_FLAGS_${config} "${CMAKE_CXX_FLAGS}")
        endforeach()
    else()
        message(FATAL "invalid crt: '${${value}}'")
    endif() 
endmacro()

################################################################################

macro(cxx_runtime_gnu_static flags)
	if(NOT ${flags} MATCHES "-static-libstdc\\+\\+")
        set(${flags} "${${flags}} -static-libstdc++")
    endif()
	
    if(NOT ${flags} MATCHES "-static-libgcc")
        set(${flags} "${${flags}} -static-libgcc")
    endif()
endmacro()

################################################################################

macro(cxx_runtime_gnu_dynamic flags)
    string(REGEX REPLACE 
        "-static-libstdc\\+\\+" 
        "" 
        ${flags} 
        "${${flags}}"
    )

    string(REGEX REPLACE 
        "-static-libgcc" 
        "" 
        ${flags} 
        "${${flags}}"
    )
endmacro()

################################################################################

macro(cxx_runtime_gnu value)
    if(${value} STREQUAL "dynamicRuntimeCPP")
        cxx_runtime_gnu_dynamic(CMAKE_CXX_FLAGS)
        foreach(config ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${config} config)
            cxx_runtime_gnu_dynamic(CMAKE_CXX_FLAGS_${config})
        endforeach()
    elseif(${value} STREQUAL "staticRuntimeCPP")
        cxx_runtime_gnu_static(CMAKE_CXX_FLAGS)
        foreach(config ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${config} config)
            cxx_runtime_gnu_static(CMAKE_CXX_FLAGS_${config})
        endforeach()
    else()
        message(FATAL "invalid crt: '${${value}}'")
    endif() 
endmacro()

################################################################################
