include '1.f90'
! 编译命令：gfortran 1_2.f90 -o 1_2 && ./1_2
! 参考运行时间：1 分钟

program project1_2
    use Module_1
    implicit none

    integer i, j
    real*8, parameter :: omega = 1D0, Intensity = 1D16
    real*8, parameter :: E0 = sqrt(Intensity / 3.5094448314D16)
    integer, parameter :: Periods = 18
    ! 定义时间跨度和步长、空间跨度和步长、波矢跨度和步长
    real*8, parameter :: t_max = Periods * 2 * pi / omega, dt = 5D-2
    real*8, parameter :: x_max = 2000D0, dx = 1D-1
    real*8, parameter :: k_max = 2.5D0, dk = 1D-2
    real*8, parameter :: sigma = 0.2D0, x_0 = 0.75D0*x_max
    integer, parameter :: n = nint(x_max / dx), nk = nint(k_max / dk), nt = nint(t_max / dt)
    real*8 :: x(2*n+1) = (/((i-n-1)*dx, i=1, 2*n+1)/)
    real*8 :: k(2*nk+1) = (/((i-nk-1)*dk, i=1, 2*nk+1)/)
    ! 定义初态、含时态、终态、动量本征态波函数；定义概率幅
    complex*16 :: Psi_0(2*n+1) = 1, H(2*n+1,2) = 0
    complex*16 :: Psi(2*n+1) = 1, Psi_f(2*n+1) = 0, Psi_k(2*n+1) = 0
    real*8 :: P(0:nt) = 0, Pk(2*nk+1) = 0, f(2*n+1) = 1
    real*8 :: E_guess = -0.48
    real*8 :: start, end

    call cpu_time(start)
    ! 创建吸收函数
    call Absorption(f, x_0, sigma, dx)
    open(10, file = '1_2_output.txt')
    ! 初态
    call Hamiltonian(H, dx, 0D0, Periods, omega, Intensity)
    call EigenVectors(H, Psi_0, E_guess)
    call Normalize(Psi_0)

    ! 开始演化
    Psi = Psi_0
    P(0) = 1D0
    do i = 0, nt-1
        if (mod(i,100) == 0) &
        print *, '已演化', i, '步，共', nt, '步'
        ! 传播一步，并吸收，然后归一
        call Propagator(Psi, i*dt, dt, dx, Periods, omega, Intensity)
        Psi = Psi * f
        call Normalize(Psi)
        P(i+1) = abs(dot_product(conjg(Psi_0),Psi))**2
    end do

    print *, '演化完成，开始计算末态动量谱'
    ! 传播完成，计算终态并归一
    Psi_f = Psi - dot_product(conjg(Psi_0),Psi) * Psi_0
    call Normalize(Psi_f)
    ! 获得动量谱
    do i = 1, 2*nk+1
        Psi_k = exp(Im*k(i)*x)
        call Normalize(Psi_k)
        Pk(i) = abs(dot_product(Psi_f,Psi_k))**2
    end do

    write(10, *) '布居数：', P
    write(10, *) '动量谱：', Pk
    call cpu_time(end)
    print *, '运行时间：', end - start
    print *, '计算完成，结果已保存到 1_2_output.txt'
end program