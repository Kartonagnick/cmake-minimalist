
# 2021y-01m-18d. WorkSpace project.
################################################################################
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
#    add_mygtest(dir_mygtest ver_mygtest)
#
################################################################################

if(NOT "${gNAME_PROJECT}" STREQUAL "mygtest")
    add_mygtest(dir_mygtest ver_mygtest)
    if(NOT dir_mygtest)
        message(FATAL_ERROR "'mygtest' not found")
    endif()
endif()

################################################################################
