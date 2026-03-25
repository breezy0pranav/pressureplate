cmake_minimum_required(VERSION 3.15)
project(pressureplate)

set(CMAKE_CXX_STANDARD 17)

include_directories(include)

add_executable(test_array
    src/array.cpp
    src/main.cpp
)