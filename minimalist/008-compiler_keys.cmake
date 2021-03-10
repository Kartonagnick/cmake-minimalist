
# 2014y-02m-20d. Workspace project.
# 2020y-08m-24d. Workspace project.
################################################################################

#
#  Mission:
#    Set compiler`s keys for 'global' or concrete 'target'
#
#  Usage:
#    set_global_compiler_keys()
#    set_target_compiler_keys(target)
#

#-------------------------------------------------------------------------------

set(gSTANDARD_CPP 17)

function(remove_duplicate variable)
    set(result)
    set(value ${${variable}})
    separate_arguments(value)
    list(REMOVE_DUPLICATES value)
    foreach(cur ${value})
        set(result "${result} ${cur}")
    endforeach()
    string(STRIP "${result}" result)
    set(${variable} "${result}" PARENT_SCOPE) 
endfunction()

#-------------------------------------------------------------------------------

function(cxx_msvc__cplusplus variable)
    # /Zc:__cplusplus is required to make __cplusplus accurate
    # /Zc:__cplusplus is available starting with Visual Studio 2017 version 15.7
    # (according to https://docs.microsoft.com/en-us/cpp/build/reference/zc-cplusplus)
    # That version is equivalent to _MSC_VER==1914
    # (according to https://docs.microsoft.com/en-us/cpp/preprocessor/predefined-macros?view=vs-2019)
    # CMake's ${MSVC_VERSION} is equivalent to _MSC_VER
    # (according to https://cmake.org/cmake/help/latest/variable/MSVC_VERSION.html#variable:MSVC_VERSION)
    if ((MSVC) AND (MSVC_VERSION GREATER_EQUAL 1914))
        target_compile_options(stxxl INTERFACE "/Zc:__cplusplus")
    endif()
endfunction()

function(cxx_compile_keys_msvc variable)
    set(value ${${variable}})

    if("${value}" MATCHES "/W[0-4]")
        string(REGEX REPLACE "/W[0-4]" "" value ${value})
    endif()

    if("${value}" MATCHES "/Zi")
        string(REGEX REPLACE "/Zi" "" value ${value})
    endif()

    if("${value}" MATCHES "/EH.*")
        string(REGEX REPLACE "/EH.*" "" value ${value})
    endif()

    if("${gRUNTIME_CPP}" STREQUAL "dynamic")
        if("${value}" MATCHES "/MT")
            string(REPLACE "/MT" "/MD" value "${value}")
        endif()

    elseif("${gRUNTIME_CPP}" STREQUAL "static")
        if("${value}" MATCHES "/MD")
            string(REPLACE "/MD" "/MT" value "${value}")
        endif()
    else()
        message(FATAL_ERROR "invalid 'gRUNTIME_CPP': ${gRUNTIME_CPP}")
    endif()

    set(${variable} "${value}" PARENT_SCOPE)
endfunction()

#-------------------------------------------------------------------------------

function(cxx_compile_keys_gcc variable)
    set(name ${variable})
    set(value ${${name}})

    if("${gRUNTIME_CPP}" STREQUAL "dynamic")
        if("${value}" MATCHES "-static-libstdc\\+\\+")
            string(REGEX REPLACE 
                "-static-libstdc\\+\\+" 
                "" 
                value 
                "${value}"
            )
        endif()

        if("${value}" MATCHES "-static-libgcc")
            string(REGEX REPLACE 
                "-static-libgcc" 
                "" 
                value 
                "${value}"
            )
        endif()

        if("${value}" MATCHES "-static")
            string(REGEX REPLACE 
                "-static" 
                "" 
                value 
                "${value}"
            )
        endif()

    elseif("${gRUNTIME_CPP}" STREQUAL "static")
        set(value "${value} -static-libgcc -static-libstdc++ -static")
    else()
        message(FATAL_ERROR "invalid 'gRUNTIME_CPP': ${gRUNTIME_CPP}")
    endif()

    set(keys1 "-pedantic -pedantic-errors -Wall -Weffc++ -Wextra -Werror")
    set(keys2 "-Wcast-align -Wold-style-cast -Wconversion -Wsign-conversion -Wcast-qual") 
    set(keys3 "-Woverloaded-virtual -Wctor-dtor-privacy -Wnon-virtual-dtor") 
    set(keys4 "-Winit-self -Wunreachable-code -Wunused-parameter -Wshadow")

    # set(keys55 "-Wundef") can not suppress

    set(keys5 "-Wpointer-arith -Wreturn-type -Wswitch -Wformat -Wundef")
    set(keys6 "-Wwrite-strings -Wchar-subscripts -Wredundant-decls")
    set(keys7 "-Wparentheses -Wmissing-include-dirs -Wempty-body -Wextra")

    set(keyExtraC "-Wclobbered -Wempty-body -Wignored-qualifiers -Wmissing-field-initializers -Wmissing-parameter-type -Wold-style-declaration")
    set(keyExtraCPP "-Woverride-init -Wsign-compare -Wtype-limits -Wuninitialized -Wunused-parameter -Wunused-but-set-parameter")

    # mingw920 broken with it:
    # set(keys8 "-Werror-implicit-function-declaration")

    # compile errors with it:
    # set(keys9 "-Winline")

    set(keys "${keys1} ${keys2} ${keys3} ${keys4} ${keys5} ${keys6} ${keys7}")

    set(value "${keys} ${value}")
    set(${name} "${value}" PARENT_SCOPE)

endfunction()

#-------------------------------------------------------------------------------

macro(set_global_compiler_keys)

    if(MSVC)

        # set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

        cxx_compile_keys_msvc(CMAKE_CXX_FLAGS)
        foreach(cfg ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${cfg} CONFIG)
            cxx_compile_keys_msvc(CMAKE_CXX_FLAGS_${CONFIG})
            cxx_compile_keys_msvc(CMAKE_C_FLAGS_${CONFIG})
        endforeach()

        set(post_keys)
        if(MSVC_VERSION GREATER "1900")
            # msvc2017 or latest
            set(post_keys "/permissive-")
        endif()

        if(MSVC_VERSION GREATER "1900" AND MSVC_VERSION LESS_EQUAL "1916")
            # msvc2017 only
            set(post_keys "${post_keys} /Zc:twoPhase-")
        endif()

        if(MSVC_VERSION GREATER "1500")
            # msvc2010 or latest
            set(begin_keys "/MP")
        endif()

        if(MSVC_VERSION GREATER "1600")
            # msvc2012 or latest
            set(begin_keys "/sdl ${begin_keys}")
        endif()


        if (MSVC_VERSION GREATER_EQUAL 1914)
            set(post_keys "${post_keys} /Zc:__cplusplus")
        endif()

        set(post_keys    "${post_keys} /D_UNICODE /DUNICODE")
        set(common_keys  "${begin_keys} /GR /W4 /WX /nologo /openmp /FC /EHa")
        set(release_keys "/Gy /Oi /O2 /Ob2 /Ot /Oy /DNDEBUG")
        set(debug_keys   "/Od /Ob0 /Zi /RTC1 /DDEBUG /D_DEBUG")

        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${common_keys} ${release_keys} ${post_keys}")
        set(CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS_DEBUG}   ${common_keys} ${debug_keys} ${post_keys}"  )
        set(CMAKE_CXX_FLAGS         "${CMAKE_CXX_FLAGS}         ${common_keys} ${post_keys}")

        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${common_keys} ${release_keys} ${post_keys}")
        set(CMAKE_C_FLAGS_DEBUG   "${CMAKE_C_FLAGS_DEBUG}   ${common_keys} ${debug_keys} ${post_keys}"  )
        set(CMAKE_C_FLAGS         "${CMAKE_C_FLAGS}         ${common_keys} ${post_keys}")

        unset(common_keys)
        unset(release_keys)
        unset(debug_keys)
        unset(post_keys)
    else()
        cxx_compile_keys_gcc(CMAKE_CXX_FLAGS)
        foreach(cfg ${CMAKE_CONFIGURATION_TYPES})
            string(TOUPPER ${cfg} CONFIG)
            cxx_compile_keys_gcc(CMAKE_CXX_FLAGS_${CONFIG})
        endforeach()

        # set(pre_keys "-std=c++17")

        if(gADDRESS_MODEL EQUAL "32")
            set(pre_keys "-m32")
        elseif(gADDRESS_MODEL EQUAL "64")
            set(pre_keys "-m64")
        else()
            message(STATUS "[gADDRESS_MODEL] ... ${gADDRESS_MODEL}")
            message(FATAL_ERROR "invalid address model")
        endif()

        # set(post_keys "-D_UNICODE -DUNICODE -Wno-trigraphs")
        set(post_keys "-D_UNICODE -DUNICODE")
        set(CMAKE_CXX_FLAGS_RELEASE "${pre_keys} ${CMAKE_CXX_FLAGS_RELEASE} -fopenmp -O3 -DNDEBUG              ${post_keys}")
        set(CMAKE_CXX_FLAGS_DEBUG   "${pre_keys} ${CMAKE_CXX_FLAGS_DEBUG}   -fopenmp -O0 -g3 -DDEBUG -D_DEBUG  ${post_keys}")
        set(CMAKE_CXX_FLAGS         "${pre_keys} ${CMAKE_CXX_FLAGS}         -fopenmp                           ${post_keys}")

        compare_versions(
            "${CMAKE_CXX_COMPILER_VERSION}"  "8.1.0" 
            compare_result
        )
        if(compare_result STREQUAL "LESS")
            link_libraries(stdc++fs)
        endif()

        unset(post_keys)
        unset(pre_keys)
    endif()

    remove_duplicate(CMAKE_CXX_FLAGS)
    remove_duplicate(CMAKE_CXX_FLAGS_RELEASE)
    remove_duplicate(CMAKE_CXX_FLAGS_DEBUG)

    set(CMAKE_CXX_STANDARD ${gSTANDARD_CPP})
    set(CMAKE_CXX_STANDARD_REQUIRED YES)
    set(CMAKE_CXX_EXTENSIONS NO)


    if(gVIEW_COMPILER_KEYS)
        message(STATUS "[compiler keys]")
        message(STATUS "  [CMAKE_CXX_STANDARD] c++${gSTANDARD_CPP}")

        message(STATUS "  [CMAKE_CXX_FLAGS]")
        message(STATUS "    '${CMAKE_CXX_FLAGS}'")

        message(STATUS "  [CMAKE_CXX_FLAGS_DEBUG]")
        message(STATUS "    '${CMAKE_CXX_FLAGS_DEBUG}'")

        message(STATUS "  [CMAKE_CXX_FLAGS_RELEASE]")
        message(STATUS "    '${CMAKE_CXX_FLAGS_RELEASE}'")
    endif()

endmacro()

###############################################################################      

function(set_target_compiler_keys target)

    remove_duplicate(CMAKE_CXX_FLAGS_RELEASE)
    remove_duplicate(CMAKE_CXX_FLAGS_DEBUG)

    set(release "${CMAKE_CXX_FLAGS_RELEASE}")
    set(debug   "${CMAKE_CXX_FLAGS_DEBUG}"  )
    separate_arguments(release)
    separate_arguments(debug)

    target_compile_options(
        ${target} PRIVATE 
        "$<$<CONFIG:debug>:${debug}>" 
        "$<$<CONFIG:release>:${release}>"
    )

    set_target_properties(${tNAME} PROPERTIES
        CXX_STANDARD ${gSTANDARD_CPP}
        CXX_STANDARD_REQUIRED YES
        CXX_EXTENSIONS NO
    )

endfunction()

###############################################################################      

macro(__set_latest_standart)
    if(MSVC_VERSION GREATER_EQUAL "1900")
        include(CheckCXXCompilerFlag)
        CHECK_CXX_COMPILER_FLAG("/std:c++latest" _cpp_latest_flag_supported)
        if (_cpp_latest_flag_supported)
            add_compile_options("/std:c++latest")
        endif()
    endif()
endmacro()

function(__custom_enable_cxx17 TARGET)
    target_compile_features(${TARGET} PUBLIC cxx_std_17)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set_target_properties(${TARGET} PROPERTIES COMPILE_FLAGS "/std:c++latest")
    elseif (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set_target_properties(${TARGET} PROPERTIES COMPILE_FLAGS "-stdlib=libc++ -pthread")
        target_link_libraries(${TARGET} c++experimental pthread)
    endif()
endfunction()

macro(__example)
    if (MSVC)
        add_compile_options("$<$<CONFIG:DEBUG>:/MDd>")
    endif()
endmacro()

###############################################################################      


# g++ -std=c++1z -Wall -Wextra -Wunused  -Wmisleading-indentation -Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wuseless-cast -pedantic-errors -O3 main.cpp -lstdc++fs
