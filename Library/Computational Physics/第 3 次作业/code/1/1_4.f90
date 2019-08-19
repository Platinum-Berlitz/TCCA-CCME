include '1.f90'
! 编译命令：gfortran 1_4.f90 -o 1_4 && ./1_4
! 参考运行时间：15 秒

program project1_2
    use Module_1
    implicit none

    integer i, j
    real*8, parameter :: lambda = 400
    real*8, parameter :: omega = omega_au/lambda, Intensity = 1D14
    real*8, parameter :: E0 = sqrt(Intensity / 3.5094448314D16)
    integer, parameter :: Periods = 4
    real*8, parameter :: t_max = Periods * 2 * pi / omega, dt = 5D-2
    real*8, parameter :: x_max = 600D0, dx = 1D-1
    real*8, parameter :: b_max = 2D1, db = 1D-1
    real*8, parameter :: sigma = 0.2D0, x_0 = 0.75D0*x_max
    integer, parameter :: n = nint(x_max / dx), nb = nint(b_max / db), nt = nint(t_max / dt)
    complex*16 :: Psi(2*n+1) = 1, Psi_0(2*n+1) = 1, Fourier(nt), H(2*n+1,2) = 0, A2(nb) = 0
    real*8 :: x(2*n+1) = (/((i-n-1)*dx, i=1, 2*n+1)/), dV(2*n+1)
    real*8 :: ts(nt) = (/(i*dt, i=1, nt)/)
    real*8 :: f(2*n+1) = 1, d(nt) = 0, a(nt) = 0
    real*8 :: E_guess = -0.48, omega_harmonic, Et
    ! 窗函数
    real*8, parameter :: dt2 = 1, nt2 = nint(t_max / dt2), sigma_t = 15
    real*8 :: w(nt) = 0, t0
    real*8 :: start, end

    call cpu_time(start)

    call Absorption(f, x_0, sigma, dx)
    open(10, file = '1_4_output.txt')
    call Hamiltonian(H, dx, 0D0, Periods, omega, Intensity)
    call EigenVectors(H, Psi_0, E_guess)
    call Normalize(Psi_0)

    ! 这一部分与前面相同
    Psi = Psi_0
    dV = x*(x**2+2)**(-1.5)
    do i = 0, nt-1
        if (mod(i, 1000) == 0) &
        print *, '已演化', i, '步，共', nt, '步'
        Et = E(i*dt, Periods, omega, Intensity)
        call Propagator(Psi, i*dt, dt, dx, Periods, omega, Intensity)
        Psi = Psi * f
        call Normalize(Psi)
        a(i+1) = sum((Et-dV)*abs(Psi)**2)
    end do

    print *, '演化完成，开始计算谐波功率谱'
    ! 按时间逐个计算 Fourier 变换
    do i = 1, nint(t_max)-1
        t0 = i
        w = exp(-(ts-t0)**2/2/sigma_t**2)
        do j = 1, nb
            omega_harmonic = j*db*omega
            Fourier = exp(-Im*omega_harmonic*ts)
            A2(j) = dot_product(Fourier,a*w)/sqrt(2*pi)
        end do
        write(10, *) abs(A2)**2
    end do

    call cpu_time(end)
    print *, '运行时间：', end - start
    print *, '计算完成，结果已保存到 1_4_output.txt'
end program