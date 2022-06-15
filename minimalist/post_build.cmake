
# 2022-06m-16. WorkSpace project.
################################################################################
################################################################################

message(STATUS "POST BUILD")
message(STATUS "[tNAME] ${tNAME}")
message(STATUS "[tDIR_SOURCE] ${tDIR_SOURCE}")
message(STATUS "[tINCLUDES]   ${tINCLUDES}"  )

message(STATUS "[tTYPE]   ${tTYPE}"  )

message(STATUS "[gADDRESS_MODEL] ${gADDRESS_MODEL}")
message(STATUS "[gBUILD_TYPE]    ${gBUILD_TYPE}"   )
message(STATUS "[gBUILD_TYPE2]   ${gBUILD_TYPE2}"  )
message(STATUS "[gRUNTIME_CPP]   ${gRUNTIME_CPP}"  )



set(tmp "$ENV{eCHECK}")
message(STATUS "[tmp]   ${tmp}"  )



#file(WRITE  "${f_targets}" "# WorkSpace project\n")
#file(APPEND "${f_targets}" "# This file was created automatically\n")
#file(APPEND "${f_targets}" "${tDIR_SOURCE}\n")
#file(APPEND "${f_targets}" "$<TARGET_FILE_DIR:${tNAME}>\n")

# COMMAND "${CMAKE_COMMAND}" -E echo "${tNAME}": "${tSHORT}": "${tDIR_SOURCE}": "$<TARGET_FILE_DIR:${tNAME}>" >> "${f_targets}" 

################################################################################
################################################################################
