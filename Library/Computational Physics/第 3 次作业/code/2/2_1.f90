include '2.f90'
! 编译命令：gfortran 2_1.f90 -o 2_1 && ./2_1
! 参考运行时间：4 分钟

program project2_1
    use Module_2
    implicit none

    integer i, j, mode, count, nSample
    ! 动量范围
    real*8, parameter :: p_max = 1.5D0, dp = 2D-2
    ! 时间步长及步数，每一步的时间值
    real*8, parameter :: dt = 1D-1
    integer, parameter :: nt = nint(4*T0/dt), np = nint(p_max/dp)
    real*8, parameter :: t(nt) = (/((i-nt/2)*dt, i = 1, nt)/)
    ! 每一次抽样的大小由权重乘以抽样常数决定，所以是 allocatable 对象
    real*8, allocatable :: Sample(:)
    ! 限制系统大小最大为 10^6 个电子
    integer, parameter :: Sampling_Constant = 100000, maximum = 1D6
    complex*16 System(maximum,2)
    ! （复）位置、（复）动量、（复）电场，其意义见文档
    real*8 r, p, p_inf, E
    complex*16 rc, pc, pc_inf, Ec
    real*8 a, L2, u, weight
    ! 分布矩阵
    integer :: Distribution(-np:np,-np:np), Dx, Dy
    integer Distribution_x(-np:np), Distribution_y(-np:np)
    real*8 start, end

    open(10, file = '2_1_output.txt')
    call cpu_time(start)
    do mode = 1, 2
        if (mode == 1) then
            print *, '线偏光计算开始'
        else
            print *, '椭偏光计算开始'
        end if
        count = 0
        System = 0
        Distribution = 0
        do i = 1, nt
            if (mod(i, 100) == 0) &
            print *, '已演化', i, '步，共', nt, '步'
            ! 计算电场强度
            Ec = Polarized_E(t(i), mode)
            ! 微分方程演化
            do j = 1, count
                call Runge_Kutta(System(j,:), t(i), dt, mode)
            end do
            ! 新增取样
            a = atan2(aimag(-Ec),real(-Ec)) ! 复电场幅角
            E = abs(Ec)
            if (E > 0.05) then ! 电场阈值
                weight = exp(-2.0/3.0/E)/(E**1.5) ! 权重
                nSample = nint(weight*Sampling_Constant)
                r = Ip / E
                rc = r * exp(Im*a)
                ! 新增一批电子并加入系统，count 统计总电子数
                allocate(Sample(nSample))
                Sample = 0
                call Monte_Carlo(E, Sample)
                do j = 1, nSample
                    count = count + 1
                    p = Sample(j)
                    pc = p * exp(Im*(a+pi/2))
                    ! 系统记录电子的初始复位置和复动量
                    System(count,:) = (/rc, pc/)
                end do
                deallocate(Sample)
            end if
        end do

        print *, '电离与演化结束，统计渐进动量'
        ! 电离 + 演化结束，现在计算渐进动量
        do i = 1, count
            rc = System(i,1)
            r = abs(rc)
            pc = System(i,2)
            p = abs(pc)
            ! 公式推导、u 和 L2 意义见文档
            if (p**2 > 2/r) then
                p_inf = sqrt(p**2 - 2/r)
                u = real(rc)*real(pc) + aimag(rc)*aimag(pc)
                L2 = r**2*p**2 - u**2
                pc_inf = p_inf / (1+p_inf**2*L2) * &
                (p_inf*(L2*pc+u*rc/r-r*pc)-p**2*rc+u*pc+rc/r)
                ! 将动量近似到格点，填入分布矩阵
                Dx = nint(real(pc_inf)/dp)
                Dy = nint(aimag(pc_inf)/dp)
                if (abs(Dx) <= np .and. abs(Dy) <= np) &
                Distribution(Dx,Dy) = Distribution(Dx,Dy) + 1
            end if
        end do

        ! 分布矩阵按列求和，得到 x- 和 y- 分布向量
        do i = -np, np
            Distribution_x(i) = sum(Distribution(i,:))
            Distribution_y(i) = sum(Distribution(:,i))
            write(10, *) Distribution(i,:)
        end do

        write(10, *) Distribution_y
        write(10, *) Distribution_x
    end do
    call cpu_time(end)
    print *, '运行时间', end - start
    print *, '计算完成，结果已保存到 2_1_output.txt'
end program