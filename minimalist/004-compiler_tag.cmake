
# 2020y-08m-21d. Workspace project.
# 2020y-08m-24d. Workspace project.
# 2020y-08m-31d. Workspace project.
################################################################################

macro(check_version min max value)
    if(NOT MSVC_VERSION LESS ${min} AND NOT MSVC_VERSION GREATER ${max})
        set(gCOMPILER_TAG ${value} PARENT_SCOPE)
    endif()
endmacro()

################################################################################

#
#  Mission:
#    Detect compiler`s tag
#

################################################################################

function(detect_compiler_tag)

    set(need_detect)    
    if(NOT gCOMPILER_TAG)
        set(need_detect ON)    
    else()
        string(TOUPPER "${gCOMPILER_TAG}" up_tag)
        if("${up_tag}" STREQUAL "MSVC")
            set(need_detect ON)
        elseif("${up_tag}" STREQUAL "MINGW")
            set(need_detect ON)
        endif()
    endif() 

    if(NOT need_detect)
        return()
    endif()

    if(MSVC)
        check_version(0    1200 msvc60  ) 
        check_version(1201 1300 msvc70  ) 
        check_version(1301 1310 msvc71  ) 
        check_version(1311 1400 msvc2005) 
        check_version(1401 1500 msvc2008) 
        check_version(1501 1600 msvc2010) 
        check_version(1601 1700 msvc2012) 
        check_version(1701 1800 msvc2013)
        check_version(1801 1900 msvc2015)

        check_version(1901 1910 msvc2017)   # 15.0
        check_version(1911 1911 msvc2017)   # 15.3
        check_version(1912 1912 msvc2017)   # 15.5
        check_version(1913 1913 msvc2017)   # 15.6
        check_version(1914 1914 msvc2017)   # 15.7
        check_version(1915 1915 msvc2017)   # 15.8
        check_version(1916 1916 msvc2017)   # 15.9

        check_version(1917 1920 msvc2019)   # 16.0
        check_version(1921 1921 msvc2019)   # 16.1
        check_version(1922 1922 msvc2019)   # 16.2
        check_version(1923 1923 msvc2019)   # 16.3
        check_version(1924 1924 msvc2019)   # 16.4
        check_version(1925 1925 msvc2019)   # 16.5
        check_version(1926 1926 msvc2019)   # 16.6
        check_version(1927 1927 msvc2019)   # 16.7    
        check_version(1928 1928 msvc2019)   # 16.8    

    elseif(MINGW OR CMAKE_GENERATOR MATCHES "[mM][iI][nN][Gg][wW]")
        if(NOT CMAKE_CXX_COMPILER)
            message(FATAL_ERROR "'CMAKE_CXX_COMPILER' not specified")
        endif()
        set(gCOMPILER_TAG mingw)
        # message(STATUS "  ${CMAKE_CXX_COMPILER} -dumpversion")
        execute_process(COMMAND ${CMAKE_COMMAND} -E chdir "." "${CMAKE_CXX_COMPILER}" "-dumpversion"
            RESULT_VARIABLE res
            OUTPUT_VARIABLE out
            ERROR_VARIABLE  err
        )
        if(_err)
            message(FATAL_ERROR "${err}")
        endif()
        string(REGEX REPLACE   "\\." "" out "${out}")
        string(STRIP "${out}" out)
        set(gCOMPILER_TAG "mingw${out}" PARENT_SCOPE)
    endif()
endfunction()

################################################################################
################################################################################

