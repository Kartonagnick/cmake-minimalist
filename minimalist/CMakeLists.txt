
# 2021y-02m-12d. WorkSpace project.
# Example user`s CMakeLists.txt
################################################################################
################################################################################

set(gDEBUG "$ENV{eDEBUG}")
cmake_minimum_required(VERSION 3.1)

include("${CMAKE_CURRENT_LIST_DIR}/setup.cmake")
cmake_scenario("minimalist")

project(${gNAME_PROJECT})

#--- if a testing framework is not available then ignore unit tests
set (gIGNORE_UNAVAILABLE_TESTS ON)

################################################################################
################################################################################

#--- example declaration general-target
make_target(

    #--- all settings will be used by default
)

#--- example declaration unit-test target
make_target(
    PATH_TO_SOURCES "test"

    #--- automatically link with 'mygtest', 'gmock', or 'gtest' 

    #--- automatically link with 'general-target' 
)


################################################################################
################################################################################

