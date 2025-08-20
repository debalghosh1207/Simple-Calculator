cmake_minimum_required(VERSION 3.16)

# Version management
set(PROJECT_VERSION_MAJOR 1)
set(PROJECT_VERSION_MINOR 1)
set(PROJECT_VERSION_PATCH 0)
set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

project(basic-calculator VERSION ${PROJECT_VERSION})

set(SOURCE_FILES
    ./main/main_calc.cpp ./main/calculator/operations/operations.cpp
    ./main/calculator/calculator.cpp)

set(HEADER_FILES ./main/calculator/operations/operations.hpp
                 ./main/calculator/calculator.hpp)

set(HEADER_DIRECTORIES ./main/calculator/operations ./main/calculator/)

add_executable(${PROJECT_NAME} ${SOURCE_FILES} ${HEADER_FILES})

target_include_directories(${PROJECT_NAME} PUBLIC ${HEADER_DIRECTORIES})

# Configure version header
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/version.h.in"
    "${CMAKE_CURRENT_BINARY_DIR}/version.h"
)

target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

# Set install targets
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
