include '3.f90'
! 编译命令：gfortran 3_5.f90 -o 3_5 && ./3_5
! 运行时间：1 分钟

program project3_5
    use Module_3
    implicit none

    integer i, j, k
    integer, parameter :: n = 32, mode = 1
    real*8, parameter :: alpha = 2.5D-1
    real*8, parameter :: omega(n) = (/(2*sin(pi*i/2/(n+1)), i=1, n)/)
    real*8, parameter :: t_max = 8000*pi/omega(1), dt = 1D-1
    integer, parameter :: nt = nint(t_max/dt)
    real*8 :: E1(nt/1000) = 0, average(n) = 0
    real*8 :: x(2*n) = (/2D1, (0D0, i=2, 2*n)/), q(2*n) = 0
    real*8 :: start, end

    call cpu_time(start)
    open(10, file = '3_5_output.txt')
    q = x
    call Phonons_Reverse(q)
    
    do i = 1, nt
        if (mod(i,100000) == 0) &
        print *, '已演化', i, '步，共', nt, '步'
        call Runge_Kutta(q, dt, mode, alpha)
        x = q
        call Phonons(x)
        if (mod(i,1000) == 0) then
            E1(i/1000) = x(n+1)**2/2 + x(1)**2*omega(1)**2/2
        end if
        if (i > 0.5*t_max) then
            forall(j=1:n) average(j) = average(j) + &
            x(n+j)**2/2 + x(j)**2*omega(j)**2/2
        end if
    end do

    write(10, *) E1
    write(10, *) average / (nt/2)

    call cpu_time(end)
    print *, '运行时间：', end - start
    print *, '计算完成，结果已保存到 3_5_output.txt'
end program