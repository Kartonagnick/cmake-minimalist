
# 2020y-08m-21d. Workspace project.
# 2020y-08m-26d. Workspace project.
################################################################################
#
#  Usage:
#
#    mask2regex(regex "_*" "*.h")
#    foreach(r ${regex})
#        message(STATUS "regex: ${r}")
#    endforeach()
#
#  Output: 
#
#    -- regex: $_.*^
#    -- regex: $.*\.h^
#

function(mask2regex out_result)
    unset(result)
    foreach(mask ${ARGN})
        set(regex "${mask}")
        string(REPLACE "\\"   "\\\\" regex "${regex}" )
        string(REPLACE "^"    "\\^"  regex "${regex}" )
        string(REPLACE "."    "\\."  regex "${regex}" )
        string(REPLACE "$"    "\\$"  regex "${regex}" )
        string(REPLACE "|"    "\\|"  regex "${regex}" )
        string(REPLACE "("    "\\("  regex "${regex}" )
        string(REPLACE ")"    "\\)"  regex "${regex}" )
        string(REPLACE "{"    "\\{"  regex "${regex}" )
        string(REPLACE "}"    "\\}"  regex "${regex}" )
        string(REPLACE "["    "\\["  regex "${regex}" )
        string(REPLACE "]"    "\\]"  regex "${regex}" )
        string(REPLACE "*"    "\\*"  regex "${regex}" )
        string(REPLACE "+"    "\\+"  regex "${regex}" )
        string(REPLACE "?"    "\\?"  regex "${regex}" )
        string(REPLACE "/"    "\\/"  regex "${regex}" )
        string(REPLACE "\\?"  "."    regex "${regex}" )
        string(REPLACE "\\*"  ".*"   regex "${regex}" )
        set(regex "^${regex}$")
        list(APPEND result "${regex}")
    endforeach()
    set(${out_result} ${result} PARENT_SCOPE)
endfunction()

################################################################################
