cmake_minimum_required(VERSION 3.15)
project(pressureplate)

set(CMAKE_CXX_STANDARD 17)

set(Python_EXECUTABLE "C:/Users/singh/AppData/Local/Programs/Python/Python313/python.exe")
set(pybind11_DIR "C:/Users/singh/AppData/Local/Programs/Python/Python313/Lib/site-packages/pybind11/share/cmake/pybind11")

find_package(Python COMPONENTS Interpreter Development REQUIRED)
find_package(pybind11 CONFIG REQUIRED)

include_directories(include)

# Test executable
add_executable(test_array
    src/array.cpp
    src/main.cpp
)

# Python module
pybind11_add_module(pressureplate
    src/array.cpp
    src/bindings.cpp
)
