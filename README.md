# Pressureplate Version Alpha 1.0

Pressureplate is a Python library with a C++ backend for matrix operations with CPU and GPU support.

The goal of this project is to build a minimal high performance array system from scratch and understand how computation moves between CPU and GPU.

The core logic is written in C++ and exposed to Python using pybind11.

## What it currently supports

1. Custom Array class with shape and flat memory layout (default)
2. Element wise addition and subtraction
3. Matrix multiplication
4. Basic device flag (CPU / GPU)

# Benchmarks
Size        CPU(ms)   GPU(ms)
64x64       0.90      0.86
128x128     6.69      6.55
256x256     52.17     52.72
512x512     452.52    445.45
1024x1024   4710.98   4557.43

(read My thughts section to see why the speeds are so low even with a GPU)


# Documentation- Usage and Syntax

import pressureplate as pl
pl.Array(data, shape, device, dtype)   - Syntax to initialise an array

 Example of the above Syntax
 
a = pl.Array([1,2,3,4], [2, 2])

b = pl.Array([1,2,3,4], [2, 2], pl.Device.GPU)

c = pl.Array([1,2,3,4], [2, 2], pl.Device.GPU, pl.DType.FLOAT32)

a.print()

a.size()

a.shape()

a.data()

a.Device.CPU

a.Device.GPU

a.DType.FLOAT32

a.DType.FLOAT64

add= a+b

add.print()

sub= a-b

sub.print()

mul= a@b

mul.print()

# My thoughts and plans
the library has been working great as of now, although its a very early build and thats why there are only three methods defined for matrices, but i do have plans to expand this in fuutre and make it as future rich as possible, obv it would be difficult for me as a sole contributor for this project, so it would take a long time before we even think of something.

the thing is that even now we have not been able to succesfully build the GPU side effectively as doing anything with CUDA is already too frustating GPU and CPU are roughly the same speed. This is because our current implementation has a flaw, we're transferring data to GPU and back on every single operation. That transfer overhead cancels out the GPU speedup. I could have relesed the first alpha build with fixing this issue by writing a standalone CUDA benchmark in C++ that times raw CPU matmul vs cuBLAS directly, but the thing is i already rely heveaily on documentations and community or engines for my CUDA part and this issue now seems too overkill to fix, so i will fix it but not now. 

I did faced countless issues, even had to switch to linux Operating system in between because for some reason my MINGW Compiler and CUDA engine decided not to be compatible with each other on windows only. also CMake is someting that i again heavily relied on engines for as i literally have no idea how this thing work lol. 
