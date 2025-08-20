cmake_minimum_required(VERSION 3.16)

project(unit-tests)

set(SOURCE_FILES ./calc_test.cpp ../main/calculator/calculator.cpp
                 ../main/calculator/operations/operations.cpp)

set(HEADER_FILES ../main/calculator/calculator.hpp
                 ../main/calculator/operations/operations.hpp)

set(HEADER_DIRECTORIES ../main/calculator/operations ../main/calculator/)

add_executable(${PROJECT_NAME} ${SOURCE_FILES} ${HEADER_FILES})

target_include_directories(${PROJECT_NAME} PUBLIC ${HEADER_DIRECTORIES})
