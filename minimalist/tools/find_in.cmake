
# 2020y-08m-21d. Workspace project.
# 2020y-08m-26d. Workspace project.
################################################################################

# import_from_tools(mask2regex)

################################################################################

#
#  Mission:
#    Find files and directories
#
#  Usage:
#
#    find_in(
#        dirs_output
#        files_output
#        WHERE_STARTED    "../.." "/../../../long" 
#        SCAN_INCLUDE     "*external*"
#        SCAN_EXCLUDE     "_.*"
#        DIRS_INCLUDE     "*"
#        DIRS_EXCLUDE     "_.*"
#        FILES_INCLUDE    "*.h*" "*.lib"
#        FILES_EXCLUDE    "_.*"
#        ONCE
#        DEBUG
#    )
#    foreach(d ${dirs_output})
#        message(STATUS "dir found: ${d}")
#    endforeach()
#
#    foreach(f ${files_output})
#        message(STATUS "file found: ${f}")
#    endforeach()
#

function(find_in dirs_output files_output)

    set(dirs_result)
    set(files_result)

    set(options ONCE DEBUG)
    set(oneValueArgs)
    set(multiValueArgs 
        WHERE_STARTED 
        SCAN_INCLUDE
        SCAN_EXCLUDE 
        DIRS_INCLUDE 
        DIRS_EXCLUDE 
        FILES_INCLUDE 
        FILES_EXCLUDE
    )

    cmake_parse_arguments(
        "fnd" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
    )

    unset(tmp)
    foreach(d ${fnd_WHERE_STARTED})
        get_filename_component(d "${d}" ABSOLUTE)
        list(APPEND tmp "${d}")
    endforeach()
    set(fnd_WHERE_STARTED ${tmp})

    mask2regex(fnd_SCAN_INCLUDE   ${fnd_SCAN_INCLUDE} )
    mask2regex(fnd_SCAN_EXCLUDE   ${fnd_SCAN_EXCLUDE} )
    mask2regex(fnd_DIRS_INCLUDE   ${fnd_DIRS_INCLUDE} )
    mask2regex(fnd_DIRS_EXCLUDE   ${fnd_DIRS_EXCLUDE} )
    mask2regex(fnd_FILES_INCLUDE  ${fnd_FILES_INCLUDE})
    mask2regex(fnd_FILES_EXCLUDE  ${fnd_FILES_EXCLUDE})

    if(fnd_DEBUG)
        view_variables(
            DESCRIPTION "find_in settings" 
            PREFIX      "fnd_"
            VARIABLES   
                ${oneValueArgs} 
                ${multiValueArgs} 
                ${options}
            VIEW_EMPTY
        )
    endif()

    set(scan_directories ${fnd_WHERE_STARTED})

    set(dirs_result)
    set(files_result)
    find_in_loop_(dirs_result files_result)

    set(${dirs_output}  ${dirs_result}  PARENT_SCOPE)
    set(${files_output} ${files_result} PARENT_SCOPE)
endfunction()


function(find_in_loop_ dirs_result files_result)
    set(again true)

    set(d_list)
    set(f_list)

    while(again)
        foreach(d ${scan_directories})
            # message(STATUS "cur: ${d}")
            FILE (GLOB content "${d}/*")
            unset(dirs_list)
            foreach(cur ${content})
                get_filename_component(name "${cur}" NAME)
                # message(STATUS "check-path: ${cur}")
                if(IS_DIRECTORY "${cur}")
                    need_skip_dir_(skip_d "${name}")
                    if(skip_d)
                        # message(STATUS "skip-dir: ${cur}")
                    else()
                        list(APPEND dirs_list ${cur})
                    endif()
                    if(skip_d)
                        need_skip_scan_(skip "${name}")
                        if(skip)
                            # message(STATUS "skip-scan: ${cur}")
                            continue()
                        endif()
                        list(APPEND scan_list ${cur})
                        # message(STATUS "add-scan: ${cur}")
                    endif()
                else()
                    need_skip_file_(skip "${name}")
                    if(skip)
                        # message(STATUS "skip-file: ${cur}")
                        continue()
                    endif()
                    list(APPEND f_list ${cur})
                    # message(STATUS "add-file: ${cur}")

                    if(fnd_ONCE)
                        set(${dirs_result}  ${d_list} PARENT_SCOPE)
                        set(${files_result} ${f_list} PARENT_SCOPE)
                        return()
                    endif()

                endif()
            endforeach()


            if(fnd_ONCE)
                if(dirs_list)
                    list(GET dirs_list 0 dd)
                    list(APPEND d_list "${dd}")
                    set(${dirs_result}  ${d_list} PARENT_SCOPE)
                    set(${files_result} ${f_list} PARENT_SCOPE)
                    return()
                endif()
            endif()

            list(APPEND d_list ${dirs_list})

            # foreach(dd ${dirs_list})
            #     list(APPEND d_list "${dd}")
            #     # message(STATUS "add-dir: ${dd}")
            # endforeach()
        endforeach()

        if(scan_list)
            # message(STATUS "---------------------")
            set(scan_directories ${scan_list})
            unset(scan_list)
        else()
            unset(again)
        endif()
    endwhile()

    set(${dirs_result}  ${d_list} PARENT_SCOPE)
    set(${files_result} ${f_list} PARENT_SCOPE)

endfunction()

function(need_skip_scan_ result name)
    foreach(exclude ${fnd_SCAN_EXCLUDE})
        if("${name}" MATCHES "${exclude}")
            set(${result} "TRUE" PARENT_SCOPE)
            return()
        endif()
    endforeach()

    foreach(include ${fnd_SCAN_INCLUDE})
        if("${name}" MATCHES "${include}")
            set(${result} "" PARENT_SCOPE)
            return()
        endif()
    endforeach()

    if(NOT fnd_SCAN_INCLUDE)
        set(${result} "" PARENT_SCOPE)
        return()
    endif()
    set(${result} "TRUE" PARENT_SCOPE)
endfunction()

function(need_skip_dir_ result name)
    foreach(exclude ${fnd_DIRS_EXCLUDE})
        if("${name}" MATCHES "${exclude}")
            set(${result} "TRUE" PARENT_SCOPE)
            return()
        endif()
    endforeach()
    foreach(include ${fnd_DIRS_INCLUDE})
        if("${name}" MATCHES "${include}")
            set(${result} "" PARENT_SCOPE)
            return()
        endif()
    endforeach()
    set(${result} "TRUE" PARENT_SCOPE)
endfunction()

function(need_skip_file_ result name)
    foreach(exclude ${fnd_FILES_EXCLUDE})
        if("${name}" MATCHES "${exclude}")
            set(${result} "TRUE" PARENT_SCOPE)
            return()
        endif()
    endforeach()
    foreach(include ${fnd_FILES_INCLUDE})
        if("${name}" MATCHES "${include}")
            set(${result} "" PARENT_SCOPE)
            return()
        endif()
    endforeach()
    set(${result} "TRUE" PARENT_SCOPE)
endfunction()
