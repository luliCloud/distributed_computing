#include <iostream>
#include <cuda_runtime.h>

// CUDA plus core function
// __global__ key word indicate this function running on GPU
// threadIdx, blockIdx and blockDim is CUDA build-in in core function. used for parallel computing index

/** CUDA允许多个块执行多个线程。多个block构成一个grid */
__global__ void add(int* a, int *b, int *c, int n) {
    /** index是每个线程在整个网格中的全局索引
     * blockDim.x: x方向上一个block有多少个threads
     * blockIdx.x: 当前线程属于哪个块
     * threadIdx.x: 当前线程在所属块中的索引。
     * blockDim.x：表示每个块中的线程数。因此，blockIdx.x * blockDim.x 就表示当前块的第一个线程的全局索引。
     * 例如，如果每个块有 256 个线程，那么对于块 0（blockIdx.x = 0），
     * 第一个线程的全局索引应该是 0，对于块 1（blockIdx.x = 1），第一个线程的全局索引应该是 256。
     * threadIdx.x：表示当前线程在块内的索引。它是一个从 0 到 blockDim.x - 1 的值。因此，threadIdx.x 
     * 就是在当前块内线程的编号。
     * 
     * 对于第一个块（blockIdx.x = 0）：

线程 0 的全局索引：threadIdx.x + blockIdx.x * blockDim.x = 0 + 0 * 256 = 0
线程 1 的全局索引：threadIdx.x + blockIdx.x * blockDim.x = 1 + 0 * 256 = 1
线程 255 的全局索引：threadIdx.x + blockIdx.x * blockDim.x = 255 + 0 * 256 = 255
     */
    int index = threadIdx.x + blockIdx.x * blockDim.x; // which block in which thread.
    
    if (index < n) {
        c[index] = a[index] + b[index]; // obtain val at this position.
    }
}

int main() {
    const int arraySize = 5;
    int a[arraySize] = {1,2,3,4,5};
    int b[arraySize] = {10,20,30,40,50};
    int c[arraySize] = {0};

    // GPU memory pointer
    int *d_a, *d_b, *d_c;

    // allocate GPU memory。 void** 指向指针的指针。因为&d_a 取到的是指针的地址
    cudaMalloc((void**)&d_a, arraySize * sizeof(int));
    cudaMalloc((void**)&d_b, arraySize * sizeof(int));
    cudaMalloc((void**)&d_c, arraySize * sizeof(int));

    // move data from CPU to GPU
    /**
     * d_a 是一个指向设备内存的指针，类型为 int*。
在调用 cudaMalloc() 时，你需要将指针的地址（&d_a）传递给该函数，这样 cudaMalloc() 可以修改这个指针，
让它指向分配到的设备内存。
由于 cudaMalloc() 需要的是 void** 类型的指针，而 d_a 是 int* 类型的指针，因此需要使用 (void**) 来进行类型转换。
     */
    cudaError_t err = cudaMemcpy(d_a, a, arraySize * sizeof(int), cudaMemcpyHostToDevice);
    if (err != cudaSuccess) {
        std::cerr << "CUDA memory allocation failed: " << cudaGetErrorString(err) << std::endl;
    }
    cudaError_t err2 = cudaMemcpy(d_b, b, arraySize * sizeof(int), cudaMemcpyHostToDevice);
    if (err2 != cudaSuccess) {
        std::cerr << "CUDA memory allocation failed: " << cudaGetErrorString(err2) << std::endl;
    }



    // call CUDA core function, every thread treat one ele
    int threadsPerBlock = 256; // 每个block有256个threads
    
    /** threadsPerBlock - 1 是为了向上取整。
     * 这一行代码的作用是计算 CUDA 网格（grid）中所需的块（blocks）数量。为了并行处理数据，我们通常将工作分配给多个线程，
     * 而线程被组织在块中。每个块中有多个线程，因此我们需要根据总的数据量和每个块中的线程数来确定需要多少个块。
     */
    int blocksPerGrid = (arraySize + threadsPerBlock - 1) / threadsPerBlock;
    add<<<blocksPerGrid, threadsPerBlock>>>(d_a, d_b, d_c, arraySize);

    // copy GPU back to CPU
    cudaMemcpy(c, d_c, arraySize * sizeof(int), cudaMemcpyDeviceToHost);

    // output result
    std::cout << "Results: ";
    for (int i = 0; i < arraySize; ++i) {
        std::cout << c[i] << " ";
    }
    std::cout << std::endl;

    // release GPU memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    return 0;
}
/**
 * nvcc --compiler-bindir /usr/bin/g++ plus.cu 
 * 
 * recommned to use .cu instead of .cpp, so nvcc knows how to deal with it.
 */