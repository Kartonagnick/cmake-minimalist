
# 2020y-05m-20d. Workspace project.
################################################################################

#
#  Mission:
#    Set target`s output path
#
#  Usage:
#    cxx_ouput_path("${TARGET_NAME}" "EXECUTABLE")
#    cxx_ouput_path("${TARGET_NAME}" "SHARED_LIBRARY")
#    cxx_ouput_path("${TARGET_NAME}" "STATIC_LIBRARY")
#    cxx_ouput_path("${TARGET_NAME}" "HEADER_ONLY")
#    cxx_ouput_path("${TARGET_NAME}" "UNIT_TEST")
#

function(cxx_ouput_path target type short)

    if("${type}" STREQUAL "EXECUTABLE")
        cxx_ouput_path_exe(${target} ${short})

    elseif("${type}" STREQUAL "SHARED_LIBRARY")
        cxx_ouput_path_dll(${target} ${short})

    elseif("${type}" STREQUAL "STATIC_LIBRARY")
        cxx_ouput_path_lib(${target} ${short})

    elseif("${type}" STREQUAL "HEADER_ONLY")
        cxx_ouput_path_hpp(${target} ${short})

    else()
        message(FATAL_ERROR "invalid type of target: '${type}'")
    endif()

endfunction()


