# cython: language_level=3
# distutils: language = c++

cdef extern from "matmul.cu":
    void matmul_kernel(float* A, float* B, float* C, int N)

import numpy as np
cimport numpy as np
from libc.stdlib cimport malloc, free

def matmul(np.ndarray[np.float32_t, ndim=2] A,
           np.ndarray[np.float32_t, ndim=2] B):
    cdef int N = A.shape[0]
    assert A.shape[1] == N and B.shape == (N, N)

    cdef np.ndarray[np.float32_t, ndim=2] C = np.zeros((N, N), dtype=np.float32)

    cdef float* d_A = <float*> malloc(N * N * sizeof(float))
    cdef float* d_B = <float*> malloc(N * N * sizeof(float))
    cdef float* d_C = <float*> malloc(N * N * sizeof(float))

    # Copiar datos
    for i in range(N):
        for j in range(N):
            d_A[i * N + j] = A[i, j]
            d_B[i * N + j] = B[i, j]

    # Lanzar kernel CUDA (esto requiere wrapper en `setup.py`, lo veremos)
    matmul_kernel(d_A, d_B, d_C, N)

    # Copiar resultados
    for i in range(N):
        for j in range(N):
            C[i, j] = d_C[i * N + j]

    free(d_A)
    free(d_B)
    free(d_C)
    return C
