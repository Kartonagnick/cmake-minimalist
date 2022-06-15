
# 2022y-06m-15d. Workspace project.
################################################################################

#
#  Mission:
#    Expand format string
#
#  Usage: the prefix 'g' is used by default
#    set(gBUILD_TYPE debug) 
#    set(gADDRESS_MODEL 32)
#    expand_value(
#        "foo/build/{BUILD_TYPE}-{ADDRESS_MODEL}/test" output
#    )
#    message(STATUS "result: ${output}")
#
#    result: foo/build/debug-32/test
#
#
#  Usage: can explicitly specify a prefix
#    set(xBUILD_TYPE debug) 
#    set(xADDRESS_MODEL 32)
#    expand_value(
#        "foo/build/{BUILD_TYPE}-{ADDRESS_MODEL}/test" output "x"
#    )
#    message(STATUS "result: ${output}")
#
#    result: foo/build/debug-32/test
#

macro(expand___ var)
    set(out ${var})
endmacro()

function(expand_value___ input_value prefix output_variable)
  unset(out)
  string(REGEX REPLACE "({)([^{]*)(})" "\${${prefix}\\2}" 
    out "${input_value}"
  )
  expand___(${out})
  if("${out}" STREQUAL "${input_value}") 
    string(REGEX REPLACE   "^(.*)/$" "\\1" out "${out}")
    string(REGEX REPLACE   "//" "/" out "${out}")
    string(REGEX REPLACE   "--" "-" out "${out}")
    string(REGEX REPLACE   "/-" "/" out "${out}")
    string(REGEX REPLACE   "-/" "/" out "${out}")
    set(${output_variable} "${out}" PARENT_SCOPE)
  else()
    expand_value___("${out}" "${prefix}" "${output_variable}")
    set(${output_variable} "${${output_variable}}" PARENT_SCOPE)
  endif()
endfunction()

macro(expand_value input_value output_variable)
  if(${ARGC} EQUAL 2)
    set(prefix "g")
  else()
    set(prefix ${ARGN})
  endif()
  if("${input_value}" STREQUAL "")
    set(${output_variable} "")
  else()
    expand_value___("${input_value}" "${prefix}" "${output_variable}")
  endif()
endmacro()

################################################################################

