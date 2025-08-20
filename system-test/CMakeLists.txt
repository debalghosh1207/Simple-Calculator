cmake_minimum_required(VERSION 3.16)

project(system-tests)

set(SOURCE_FILES ./calc_system_test.cpp)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})
