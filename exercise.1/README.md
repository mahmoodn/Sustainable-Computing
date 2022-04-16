This repository contains some examples for energy measurments of a matrix multiplication with different configurations. They are

1- Three-loop implementation (single thread) with integer, float and double data types in C and Python.
2- A multi-thread implementation of the naive algorithm with OpenMP with different thread counts.
3- One implementation with `cblas_dgemm` from CBLAS in C.
4- One implementation with `matmul` from Numpy in Python.

The experiments use `perf` command. Please read the PDF file for more implementation.
