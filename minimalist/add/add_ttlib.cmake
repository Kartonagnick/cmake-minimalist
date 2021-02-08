
# 2020y-05m-24d. WorkSpace project.
# 2020y-08m-31d. WorkSpace project.
################################################################################
import_from(add/add_ttlib_impl add_ttlib)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_ttlib(dir_ttlib ver_ttlib)
#
################################################################################
################################################################################

add_ttlib(dir_ttlib ver_ttlib)
if(NOT dir_ttlib)
    message(FATAL_ERROR "'ttlib' not found")
endif()

################################################################################
################################################################################