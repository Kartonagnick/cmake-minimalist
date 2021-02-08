
# 2020y-05m-24d. WorkSpace project.
# 2020y-08m-31d. WorkSpace project.
################################################################################
import_from(add/add_gtest_impl add_gtest)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_gtest(dir_gtest ver_gtest)
#
################################################################################
################################################################################

add_gmock(dir_gmock ver_gmock)
if(NOT dir_gmock)
    add_gtest(dir_gtest ver_gtest)
    if(NOT dir_gtest)
        message(FATAL_ERROR "'gtest' not found")
    endif()
endif()

################################################################################
################################################################################