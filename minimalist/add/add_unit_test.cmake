
# 2021y-01m-18d. WorkSpace project.
################################################################################
# import_from(add/add_gmock_impl   add_gmock  )
# import_from(add/add_gtest_impl   add_gtest  )
# import_from(add/add_mygtest_impl add_mygtest)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    include this file to the project
#
################################################################################

add_gmock(dir_gmock ver_gmock)
if(NOT dir_gmock)
    add_gtest(dir_gtest ver_gtest)
    if(NOT dir_gtest)
        message(STATUS "not found: 'gmock'")
        message(STATUS "not found: 'gtest'")
        message(FATAL_ERROR "library for testing not found")
    endif()
endif()

include("${CMAKE_CURRENT_LIST_DIR}/add_mygtest.cmake")

################################################################################
