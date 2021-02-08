
# 2020y-05m-14d. Workspace project.
################################################################################

#
#  Mission:
#    Determine adress model: 32 or 64 bits
#
#  Usage:
#    detect_address_model()
#

macro(detect_address_model)

    message(STATUS "([CMAKE_SIZEOF_VOID_P] ... ${CMAKE_SIZEOF_VOID_P}")

    if(CMAKE_SIZEOF_VOID_P)
        if(CMAKE_SIZEOF_VOID_P MATCHES "8")
            set(gADDRESS_MODEL "64")    
            message(STATUS "[gADDRESS_MODEL] ... ${gADDRESS_MODEL}  (auto detect)")
        elseif(CMAKE_SIZEOF_VOID_P MATCHES "4")
            set(gADDRESS_MODEL "32" )
            message(STATUS "[gADDRESS_MODEL] ... ${gADDRESS_MODEL}  (auto detect)")
        endif()
    else()  
        set(gADDRESS_MODEL $ENV{eADDRESS_MODEL})

        if(NOT gADDRESS_MODEL)
            message(STATUS "[gADDRESS_MODEL] ... ${gADDRESS_MODEL}")
            message(FATAL_ERROR "unknown address model")
        endif()

        if(gADDRESS_MODEL EQUAL "32")
            set(CMAKE_SIZEOF_VOID_P 8)
            message(STATUS "[gADDRESS_MODEL] ... ${gADDRESS_MODEL}  (from environment)")
        elseif(gADDRESS_MODEL EQUAL "64")
            set(CMAKE_SIZEOF_VOID_P 32)
            message(STATUS "[gADDRESS_MODEL] ... ${gADDRESS_MODEL}  (from environment)")
        else()
            message(STATUS "[gADDRESS_MODEL] ... ${gADDRESS_MODEL}")
            message(FATAL_ERROR "invalid address model")
        endif()
    endif()
endmacro()

################################################################################

