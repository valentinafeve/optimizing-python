def matmul(list A, list B):
    cdef int i, j, k
    cdef int n = len(A)
    cdef int p = len(A[0])
    cdef int m = len(B[0])

    # Verificación simple
    if p != len(B):
        raise ValueError("Dimensiones incompatibles")

    # Crear matriz resultado con ceros
    C = [[0.0 for _ in range(m)] for _ in range(n)]

    # Multiplicación clásica
    for i in range(n):
        for j in range(m):
            for k in range(p):
                C[i][j] += A[i][k] * B[k][j]

    return C
