include '3.f90'
! 编译命令：gfortran 3_4.f90 -o 3_4 && ./3_4
! 运行时间：1 分钟

program project3_4
    use Module_3
    implicit none

    integer i, j, k
    ! 给出参数，mode = 1 代表 α 模型
    integer, parameter :: n = 32, mode = 1
    real*8, parameter :: alpha = 2.5D-1
    real*8, parameter :: omega(4) = (/(2*sin(pi*i/2/(n+1)), i=1, 4)/)
    real*8, parameter :: t_max = 8000*pi/omega(1), dt = 1D-1
    integer, parameter :: nt = nint(t_max/dt)
    ! 模式能量统计
    real*8 :: E1(nt/1000) = 0
    real*8 :: x(2*n) = (/4D0, (0D0, i=2, 2*n)/), q(2*n) = 0
    real*8 :: start, end

    call cpu_time(start)
    open(10, file = '3_4_output.txt')
    ! 将声子的初值转化为坐标初值
    q = x
    call Phonons_Reverse(q)

    ! 进行演化
    do i = 1, nt
        if (mod(i,100000) == 0) &
        print *, '已演化', i, '步，共', nt, '步'
        call Runge_Kutta(q, dt, mode, alpha)
        ! 每演化一步，计算一次能量
        x = q
        call Phonons(x)
        if (mod(i,1000) == 0) then
            E1(i/1000) = x(n+1)**2/2 + x(1)**2*omega(1)**2/2
        end if
    end do

    write(10, *) E1

    call cpu_time(end)
    print *, '运行时间：', end - start
    print *, '计算完成，结果已保存到 3_4_output.txt'
end program