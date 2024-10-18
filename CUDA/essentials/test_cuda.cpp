#include <cuda_runtime.h>
#include <iostream>

int main() {
    int deviceCount = 0;
    cudaGetDeviceCount(&deviceCount);
    std::cout << "CUDA Device Count: " << deviceCount << std::endl;
    return 0;
}

/**
 * nvcc --compiler-bindir /usr/bin/g++ test_cuda.cpp -o test_cuda
 * 
 * must tell compiler using g++ as the main compiler for CPP code
 * 
 */