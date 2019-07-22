include '3.f90'
! 编译命令：gfortran 3_6.f90 -o 3_6 && ./3_6
! 运行时间：1 分钟

program project3_6
    use Module_3
    implicit none

    integer i, j, k
    integer, parameter :: n = 32, mode = 2
    real*8, parameter :: beta = 5D0
    real*8, parameter :: omega(n) = (/(2*sin(pi*i/2/(n+1)), i=1, n)/)
    real*8, parameter :: t_max = 4000*pi/omega(1), dt = 1D-1
    integer, parameter :: nt = nint(t_max/dt)
    real*8 :: E1(nt/1000) = 0, E3(nt/1000) = 0, E5(nt/1000) = 0, E7(nt/1000) = 0
    real*8 :: x(2*n) = 0, q(2*n) = 0
    real*8 :: Q1(2) = (/4D0, 6D0/)
    real*8 :: start, end

    call cpu_time(start)
    open(10, file = '3_6_output.txt')

    do k = 1, 2
        print *, '初始条件 Q1 = ', Q1(k), '时的计算'
        x = 0
        x(1) = Q1(k)
        q = x
        call Phonons_Reverse(q)

        do i = 1, nt
            if (mod(i,100000) == 0) &
            print *, '已演化', i, '步，共', nt, '步'
            call Runge_Kutta(q, dt, mode, beta)
            x = q
            call Phonons(x)
            if (mod(i,1000) == 0) then
                E1(i/1000) = x(n+1)**2/2 + x(1)**2*omega(1)**2/2
                E3(i/1000) = x(n+3)**2/2 + x(3)**2*omega(3)**2/2
                E5(i/1000) = x(n+5)**2/2 + x(5)**2*omega(5)**2/2
                E7(i/1000) = x(n+7)**2/2 + x(7)**2*omega(7)**2/2
            end if
        end do

        write(10, *) '初始条件 Q1 = ', Q1(k)
        write(10, *) E1
        write(10, *) E3
        write(10, *) E5
        write(10, *) E7
    end do

    call cpu_time(end)
    print *, '运行时间', end - start
    print *, '计算完成，结果已保存到 3_6_output.txt'
end program