
# 2021y-01m-19d. WorkSpace project.
################################################################################
# import_from(add/add_tools_impl add_tools)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_tools(dir_tools ver_tools)
#
################################################################################

if(NOT "${gNAME_PROJECT}" STREQUAL "tools")
    add_tools(dir_tools ver_tools)
    if(NOT dir_tools)
        message(FATAL_ERROR "'tools' not found")
    endif()
endif()

################################################################################
