
# 2020y-09m-03d. WorkSpace project.
################################################################################

#
#  Mission:
#    set /bigobj for msvc`s unit-tests
#

################################################################################

function(cxx_bigobj target type spec )
    if(MSVC AND "${type}" STREQUAL "EXECUTABLE" AND "${spec}" STREQUAL "UNIT_TEST")
        target_compile_options(${target} PRIVATE "/bigobj")
    endif()
endfunction()

################################################################################