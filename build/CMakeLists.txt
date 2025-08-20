cmake_minimum_required(VERSION 3.16)

project(basic-calculator)

set(SOURCE_FILES
    ../main/main_calc.cpp ../main/calculator/operations/operations.cpp
    ../main/calculator/calculator.cpp)

set(HEADER_FILES ../main/calculator/operations/operations.hpp
                 ../main/calculator/calculator.hpp)

set(HEADER_DIRECTORIES ../main/calculator/operations ../main/calculator/)

add_executable(${PROJECT_NAME} ${SOURCE_FILES} ${HEADER_FILES})

target_include_directories(${PROJECT_NAME} PUBLIC ${HEADER_DIRECTORIES})
