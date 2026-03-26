#pragma once
#include<vector>
#include<stdexcept>
#include<numeric>
#include<iostream>

enum class Device{
    CPU,
    GPU
};

enum class DType{
    FLOAT32,
    FLOAT64
};

class Array{
    public:
    std::vector<float> data;
    std::vector<int> shape;
    std::vector<int> strides;
    Device device;
    DType dtype;
    //Constructing the Object 
    Array(std::vector<float> data,
      std::vector<int> shape,
      Device device = Device::CPU,
      DType dtype = DType::FLOAT32);

    int size() const;
    void print() const;
    // Element-wise operations
    Array add(const Array& other) const;
    Array subtract(const Array& other) const;
    // Matrix multiplication
    Array matmul(const Array& other) const;
};