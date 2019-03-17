# 线性代数包教程
## 常见的线性代数包：LAPACK和BLAS
BLAS（基础线性代数子程序库）是含有大量线性代数运算的程序包，而LAPACK（线性代数包）是常见的数值线性代数方程求解包。BLAS和LAPACK都是用于线性代数运算的高性能数学库，基于FORTRAN语言。在C/C++中，可以使用其C接口：cblas和lapacke。  
## 安装方法
[BLAS](http://www.netlib.org/blas/#_cblas)中有BLAS的C接口头文件和CBLAS，下载即可。（Windows下的CBLAS使用下文的网址，但是头文件仍然相同）。
### Windows系统：
访问[LAPACK for Windows](http://icl.cs.utk.edu/lapack-for-windows/lapack/)，根据系统和需求下载BLAS库、LAPACK库、LAPACKE库和相应的头文件，将其放在编译器的库路径和头文件路径下，或者特定的路径下（需要手动调整）。
### Linux系统：
访问[LAPACK](http://www.netlib.org/lapack/#_lapack_version_3_8_0)，下载对应版本的压缩文件和头文件（LAPACK现自带LAPACK C接口）。之后做和Windows类似的操作使得编译器能够正确找到库和头文件。
## 使用
### BLAS的使用
关于BLAS的使用可以参见[BLAS wiki](https://en.wikipedia.org/wiki/Basic_Linear_Algebra_Subprograms)和[BLAS快速参考指南](http://www.netlib.org/blas/blasqr.pdf)。
### LAPACK的使用
LAPACK的使用见[LAPACK Users' Guide](http://www.netlib.org/lapack/lug/)和[LAPACKE](http://www.netlib.org/lapack/lapacke.html)。