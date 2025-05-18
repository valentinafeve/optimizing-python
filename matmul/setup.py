from setuptools import setup
from Cython.Build import cythonize

setup(
    name="matrix_mult",
    ext_modules=cythonize("matrix_mult.pyx"),
)
