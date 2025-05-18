from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize
import os

ext_modules = [
    Extension(
        "matmul",
        sources=["matmul.pyx", "matmul.cu"],
        language="c++",
        extra_compile_args={
            'gcc': ["-std=c++11"],
            'nvcc': ["-arch=sm_52", "--compiler-options", "-fPIC"]
        }
    )
]

from Cython.Distutils import build_ext
class custom_build_ext(build_ext):
    def build_extensions(self):
        self.compiler.src_extensions.append('.cu')
        original_compile = self.compiler.compile
        def compile(sources, *args, **kwargs):
            cu_sources = [s for s in sources if s.endswith('.cu')]
            other_sources = [s for s in sources if not s.endswith('.cu')]
            if cu_sources:
                for src in cu_sources:
                    obj = self.compiler.compile([src], extra_postargs=['--compiler-options', '-fPIC'], output_dir=self.build_temp)
                    self.compiler.object_files.extend(obj)
            return original_compile(other_sources, *args, **kwargs)
        self.compiler.compile = compile
        build_ext.build_extensions(self)

setup(
    name='matmul_cuda',
    ext_modules=cythonize(ext_modules),
    cmdclass={'build_ext': custom_build_ext}
)
