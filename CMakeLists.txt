cmake_minimum_required(VERSION 3.18)
project(pressureplate LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)

set(Python_EXECUTABLE "/usr/bin/python3")
set(pybind11_DIR "/home/nash/.local/lib/python3.12/site-packages/pybind11/share/cmake/pybind11")

find_package(Python COMPONENTS Interpreter Development REQUIRED)
find_package(pybind11 CONFIG REQUIRED)
find_package(CUDAToolkit REQUIRED)

include_directories(include)

# Test executable
add_executable(test_array
    src/array.cpp
    src/main.cpp
)

# Python module
pybind11_add_module(pressureplate
    src/array.cpp
    src/array_gpu.cu
    src/bindings.cpp
)

target_link_libraries(pressureplate PRIVATE
    CUDA::cudart
    CUDA::cublas
)