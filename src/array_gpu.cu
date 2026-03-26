#include "../include/array.h"
#include <cuda_runtime.h>
#include <cublas_v2.h>

// CUDA error checking macro
#define CUDA_CHECK(call) \
    if((call) != cudaSuccess) { \
        throw std::runtime_error(cudaGetErrorString(cudaGetLastError())); \
    }

// Element-wise add kernel
__global__ void add_kernel(const float* a, const float* b, float* result, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        result[i] = a[i] + b[i];
    }
}

// Element-wise subtract kernel
__global__ void subtract_kernel(const float* a, const float* b, float* result, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        result[i] = a[i] - b[i];
    }
}

// GPU add
Array gpu_add(const Array& a, const Array& b) {
    int n = a.size();
    float *d_a, *d_b, *d_result;

    CUDA_CHECK(cudaMalloc(&d_a, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_b, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_result, n * sizeof(float)));

    CUDA_CHECK(cudaMemcpy(d_a, a.data.data(), n * sizeof(float), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, b.data.data(), n * sizeof(float), cudaMemcpyHostToDevice));

    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    add_kernel<<<blocks, threads>>>(d_a, d_b, d_result, n);

    std::vector<float> result(n);
    CUDA_CHECK(cudaMemcpy(result.data(), d_result, n * sizeof(float), cudaMemcpyDeviceToHost));

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_result);

    return Array(result, a.shape, Device::GPU, a.dtype);
}

// GPU subtract
Array gpu_subtract(const Array& a, const Array& b) {
    int n = a.size();
    float *d_a, *d_b, *d_result;

    CUDA_CHECK(cudaMalloc(&d_a, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_b, n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_result, n * sizeof(float)));

    CUDA_CHECK(cudaMemcpy(d_a, a.data.data(), n * sizeof(float), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, b.data.data(), n * sizeof(float), cudaMemcpyHostToDevice));

    int threads = 256;
    int blocks = (n + threads - 1) / threads;
    subtract_kernel<<<blocks, threads>>>(d_a, d_b, d_result, n);

    std::vector<float> result(n);
    CUDA_CHECK(cudaMemcpy(result.data(), d_result, n * sizeof(float), cudaMemcpyDeviceToHost));

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_result);

    return Array(result, a.shape, Device::GPU, a.dtype);
}

// GPU matmul via cuBLAS
Array gpu_matmul(const Array& a, const Array& b) {
    int m = a.shape[0];
    int n = a.shape[1];
    int p = b.shape[1];

    float *d_a, *d_b, *d_result;

    CUDA_CHECK(cudaMalloc(&d_a, m * n * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_b, n * p * sizeof(float)));
    CUDA_CHECK(cudaMalloc(&d_result, m * p * sizeof(float)));

    CUDA_CHECK(cudaMemcpy(d_a, a.data.data(), m * n * sizeof(float), cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, b.data.data(), n * p * sizeof(float), cudaMemcpyHostToDevice));

    cublasHandle_t handle;
    cublasCreate(&handle);

    float alpha = 1.0f, beta = 0.0f;
    cublasSgemm(handle,
                CUBLAS_OP_N, CUBLAS_OP_N,
                p, m, n,
                &alpha,
                d_b, p,
                d_a, n,
                &beta,
                d_result, p);

    std::vector<float> result(m * p);
    CUDA_CHECK(cudaMemcpy(result.data(), d_result, m * p * sizeof(float), cudaMemcpyDeviceToHost));

    cublasDestroy(handle);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_result);

    return Array(result, {m, p}, Device::GPU, a.dtype);
}