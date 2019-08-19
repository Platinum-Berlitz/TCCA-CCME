include '1.f90'
! 编译命令：gfortran 1_1.f90 -o 1_1 && ./1_1

program project1_1
    use Module_1
    implicit none

    ! 定义离散区间和离散步长，用 n*2 矩阵构建 Hamiltonian
    real*8, parameter :: x_max = 2000D0, dx = 1D-1
    integer, parameter :: n = nint(x_max / dx)
    ! 能量和波函数初始猜测
    complex*16 :: H(2*n+1,2) = 0, Psi(2*n+1) = 1
    real*8 :: E_guess = -0.48

    open(10, file = '1_1_output.txt')
    call Hamiltonian(H, dx, 0D0, 1, 1D0, 1D0)
    call EigenVectors(H, Psi, E_guess)
    call Normalize(Psi)

    write(10, *) E_guess
    write(10, *) abs(Psi)**2
    print *, '计算完成，结果已保存到 1_1_output.txt'
end program