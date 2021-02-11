
# 2021y-02m-10d. WorkSpace project.
################################################################################
# import_from(add/add_sqlitedb_impl add_sqlitedb)
################################################################################
#
#  Mission: 
#    Detect: tPATH_LIBRARIES
#    Detect: tNAMES_LIBRARIES
#    Detect: tINCLUDES
#    Detect: tPREPROCESSOR
#
#  Usage:
#    add_sqlitedb(dir_sqlitedb ver_sqlitedb)
#
################################################################################

if(NOT "${gNAME_PROJECT}" STREQUAL "sqlitedb")
    add_sqlitedb(dir_sqlitedb ver_sqlitedb)
    if(NOT dir_sqlitedb)
        message(FATAL_ERROR "'sqlitedb' not found")
    endif()
endif()

################################################################################
