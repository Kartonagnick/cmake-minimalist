
# 2020y-05m-14d. WorkSpace project.
################################################################################

#
#  Mission:
#    Determine adress model: 32 or 64 bits
#
#  Usage:
#    cxx_address_model()
#

macro(cxx_address_model)
    if(CMAKE_SIZEOF_VOID_P)
        if(CMAKE_SIZEOF_VOID_P MATCHES "8")
            set(gADDRESS_MODEL "64")    
        elseif(CMAKE_SIZEOF_VOID_P MATCHES "4")
            set(gADDRESS_MODEL "32" )
        endif()
    else()  
        set(gADDRESS_MODEL $ENV{eADDRESS_MODEL})
    endif()
    if(NOT gADDRESS_MODEL)
        message(STATUS "[gADDRESS_MODEL] ... ${gADDRESS_MODEL}")
        message(FATAL_ERROR "unknown address model")
    endif()
endmacro()

################################################################################

