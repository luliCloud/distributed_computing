To compile file using CUDA compiler succesfully, recommend run command in bash following this format:

```nvcc --compiler-bindir /usr/bin/g++ plus.cu ```

Recommend to name file by .cu instead of .cpp so that CUDA can recognize it as the nvcc compiled file. 