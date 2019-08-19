include '3.f90'
! 编译命令：gfortran 3_8.f90 -o 3_8 && ./3_8

program project3_8
    use Module_3
    implicit none

    integer i, j, mode
    integer, parameter :: n = 128, k = 11
    real*8, parameter :: beta = 1D0
    real*8, parameter :: omega(n) = (/(2*sin(pi*i/2/(n+1)), i=1, n)/), B = 0.5
    real*8, parameter :: t_max = 100*pi/omega(11), dt = 0.01*pi/omega(11)
    integer, parameter :: nt = nint(t_max/dt)
    real*8 :: x(2*n) = (/(0D0, i=1, 2*n)/), q(2*n) = 0
    real*8 :: start, end, z1, z2

    open(10, file = '3_8_output.txt')
    call cpu_time(start)
    do mode = 0, 2, 2
        ! 给初始条件
        do i = 1, n
            z1 = pi*k*real(i-n/2)/(n+1)
            z2 = sqrt(1.5)*B*omega(k)*(i-n/2)
            q(i) = B*cos(z1)/cosh(z2)
            q(i+n) = B/cosh(z2)*(omega(k)*(1+0.1875*omega(k)**2*B**2) &
            *sin(z1)+sqrt(1.5)*B*cos(z1)*sin(pi*omega(k))*tanh(z2))
        end do
        ! 计算每一时刻的振幅
        do i = 1, nt
            if (mod(i,10) == 0) &
            write(10, *) real(q(1:n) ** 2,4)
            call Runge_Kutta(q, dt, mode, beta)
        end do
    end do

    call cpu_time(end)
    print *, '运行时间', end - start
    print *, '计算完成，结果已保存到 3_8_output.txt'
end program