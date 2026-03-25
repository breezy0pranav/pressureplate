#include "../include/array.h"

// Constructor
Array::Array(std::vector<float> data, std::vector<int> shape, Device device, DType dtype) {
    this->data = data;
    this->shape = shape;
    this->device = device;
    this->dtype = dtype;

    // Calculate strides
    strides.resize(shape.size());
    int stride = 1;
    for (int i = shape.size() - 1; i >= 0; i--) {
        strides[i] = stride;
        stride *= shape[i];
    }
}

// Total number of elements
int Array::size() const {
    int total = 1;
    for (int dim : shape) {
        total *= dim;
    }
    return total;
}

// Print the array
void Array::print() const {
    std::cout << "Array(shape=[";
    for (int i = 0; i < shape.size(); i++) {
        std::cout << shape[i];
        if (i < shape.size() - 1) std::cout << ", ";
    }
    std::cout << "], data=[";
    for (int i = 0; i < data.size(); i++) {
        std::cout << data[i];
        if (i < data.size() - 1) std::cout << ", ";
    }
    std::cout << "])" << std::endl;
}

// Element-wise add
Array Array::add(const Array& other) const {
    if (shape != other.shape) {
        throw std::invalid_argument("Shape mismatch: arrays must have the same shape");
    }
    std::vector<float> result(data.size());
    for (int i = 0; i < data.size(); i++) {
        result[i] = data[i] + other.data[i];
    }
    return Array(result, shape, device, dtype);
}

// Element-wise subtract
Array Array::subtract(const Array& other) const {
    if (shape != other.shape) {
        throw std::invalid_argument("Shape mismatch: arrays must have the same shape");
    }
    std::vector<float> result(data.size());
    for (int i = 0; i < data.size(); i++) {
        result[i] = data[i] - other.data[i];
    }
    return Array(result, shape, device, dtype);
}