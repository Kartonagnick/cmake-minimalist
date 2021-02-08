
# 2020y-05m-24d. WorkSpace project.
# 2020y-08m-31d. WorkSpace project.
################################################################################
import_from(add/add_gmock_impl add_gmock)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_gmock(dir_gmock ver_gmock)
#
################################################################################

add_gmock(dir_gmock ver_gmock)
if(NOT dir_gmock)
    message(FATAL_ERROR "'gmock' not found")
endif()

################################################################################
