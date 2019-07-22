include '3.f90'
! 编译命令：gfortran 3_7.f90 -o 3_7 && ./3_7

program project3_7
    use Module_3
    implicit none

    integer i, j, k
    integer, parameter :: n = 16, mode = 2
    real*8, parameter :: beta = 1D0
    real*8, parameter :: omega(n) = (/(2*sin(pi*i/2/(n+1)), i=1, n)/)
    real*8, parameter :: t_max = 320*pi/omega(1), dt = 1D-1
    integer, parameter :: nt = nint(t_max/dt)
    real*8 :: E9(nt/100) = 0, E10(nt/100) = 0, E11(nt/100) = 0, E12(nt/100) = 0, E13(nt/100) = 0
    real*8 :: x(2*n) = 0, q(2*n) = 0
    real*8 :: start, end

    open(10, file = '3_7_output.txt')
    call cpu_time(start)
    x(11) = 1
    q = x
    call Phonons_Reverse(q)
    
    do i = 1, nt
        call Runge_Kutta(q, dt, mode, beta)
        x = q
        call Phonons(x)
        if (mod(i,100) == 0) then
            E9(i/100) = x(n+9)**2/2 + x(9)**2*omega(9)**2/2
            E10(i/100) = x(n+10)**2/2 + x(10)**2*omega(10)**2/2
            E11(i/100) = x(n+11)**2/2 + x(11)**2*omega(11)**2/2
            E12(i/100) = x(n+12)**2/2 + x(12)**2*omega(12)**2/2
            E13(i/100) = x(n+13)**2/2 + x(13)**2*omega(13)**2/2
        end if
    end do

    write(10, *) E9
    write(10, *) E10
    write(10, *) E11
    write(10, *) E12
    write(10, *) E13

    call cpu_time(end)
    print *, '运行时间', end - start
    print *, '计算完成，结果已保存到 3_7_output.txt'
end program