include '1.f90'
! 编译命令：gfortran 1_3.f90 -o 1_3 && ./1_3
! 参考运行时间：5 分钟

program project1_2
    use Module_1
    implicit none

    integer i, j
    ! 这些参数意义同前
    real*8, parameter :: lambda = 300
    real*8, parameter :: omega = omega_au/lambda, Intensity = 2D14
    real*8, parameter :: E0 = sqrt(Intensity / 3.5094448314D16)
    integer, parameter :: Periods = 48
    real*8, parameter :: t_max = Periods * 2 * pi / omega, dt = 5D-2
    real*8, parameter :: x_max = 2000D0, dx = 1D-1
    ! b 代表谐波频率的倍数（1 到 15）及其步长
    real*8, parameter :: b_max = 1.5D1, db = 1D-1
    real*8, parameter :: sigma = 0.2D0, x_0 = 0.75D0*x_max
    integer, parameter :: n = nint(x_max / dx), nb = nint(b_max / db), nt = nint(t_max / dt)
    complex*16 :: Psi(2*n+1) = 1, Psi_0(2*n+1) = 1, H(2*n+1,2) = 0
    real*8 :: f(2*n+1) = 1, ts(nt) = (/(i*dt, i=1, nt)/)
    ! 计算谐波需要用到的算符和 Fourier 基，A1/2 用来存储结果
    real*8 :: x(2*n+1) = (/((i-n-1)*dx, i=1, 2*n+1)/), dV(2*n+1) = 0
    complex*16 :: Fourier(nt), A1(nb) = 0, A2(nb) = 0
    real*8 :: d(nt) = 0, a(nt) = 0
    real*8 :: E_guess = -0.48, omega_harmonic, Et
    real*8 :: start, end

    call cpu_time(start)
    call Absorption(f, x_0, sigma, dx)
    open(10, file = '1_3_output.txt')
    call Hamiltonian(H, dx, 0D0, Periods, omega, Intensity)
    call EigenVectors(H, Psi_0, E_guess)
    call Normalize(Psi_0)

    ! 此部分结构与上题中一样，但增加了 d 和 a 的计算
    ! 由于 d 和 a 的算符是对角的，可以写成向量的形式
    Psi = Psi_0
    dV = x*(x**2+2)**(-1.5)
    do i = 0, nt-1
        if (mod(i, 1000) == 0) &
        print *, '已演化', i, '步，共', nt, '步'
        Et = E(i*dt, Periods, omega, Intensity)
        call Propagator(Psi, i*dt, dt, dx, Periods, omega, Intensity)
        Psi = Psi * f
        call Normalize(Psi)
        ! d 的算符是 x，a 的算符是 Et-dV，求期望即得
        d(i+1) = sum(x*abs(Psi)**2)
        a(i+1) = sum((Et-dV)*abs(Psi)**2)
    end do

    print *, '演化完成，开始计算谐波功率谱'
    ! 这里积分采用复化梯形公式计算，步长同演化步长
    do i = 1, nb
        omega_harmonic = i*db*omega
        Fourier = exp(-Im*omega_harmonic*ts)
        A1(i) = -dot_product(Fourier,d)*omega_harmonic**2/sqrt(2*pi)*dt
        A2(i) = dot_product(Fourier,a)/sqrt(2*pi)*dt
    end do

    write(10, *) '第一种方法：', abs(A1)**2
    write(10, *) '第二种方法：', abs(A2)**2

    call cpu_time(end)
    print *, '运行时间：', end - start
    print *, '计算完成，结果已保存到 1_3_output.txt'
end program