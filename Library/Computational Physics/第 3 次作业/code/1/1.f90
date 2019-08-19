module Module_1

real*8, parameter :: pi = 3.1415926535897932384D0
complex*8, parameter :: Im = complex(0D0,1D0)
real*8, parameter :: E_au = 3.5094448314D16
real*8, parameter :: omega_au = 45.5633525316

contains

! 电场强度，作为周期数、频率、强度的函数
function E(t, Periods, omega, Intensity)
	implicit none
	integer Periods
	real*8 t, omega, Intensity, E

	E = sqrt(Intensity/E_au) * sin(omega*t) &
	 * (sin(omega*t/2/Periods))**2
	return
end function

! 波函数按 2-范数归一化
subroutine Normalize(v)
	real*8 norm
	complex*16 v(:)

	norm = sqrt(sum(abs(v)**2))
	v = v / norm
end subroutine Normalize

! 根据所给参数生成吸收函数
subroutine Absorption(f, x_0, sigma, dx)
	implicit none
	integer i, m, n
	real*8 f(:), x_0, sigma, dx, x

	n = size(f)
	m = (n + 1)/2
	do i = 1, n
		x = real(i-m,8)*dx
		if (abs(x) > x_0) &
		f(i) = exp(-(abs(x)-x_0)**2/sigma**2)
	end do
end subroutine

! 通过离散化构建 Hamiltonian
subroutine Hamiltonian(H, dx, t, Periods, omega, Intensity)
	implicit none
	integer n, i, m, Periods
	real*8 dx, t, omega, Intensity
	complex*16 H(:,:)

	n = size(H,1)
	m = (n + 1)/2
	! 动能部分
	forall(i=1:n) H(i,1) = -2
	forall(i=2:n) H(i,2) = 1
	H = H / (-2 * dx**2)
	! 势能部分（Columb 势和电势）
	forall(i=1:n) H(i,1) = H(i,1) - &
	1/sqrt((real(i-m,8)*dx)**2+2)
	do i = 1, n
		H(i,1) = H(i,1) + real(i-m,8)*dx*E(t, Periods, omega, Intensity)
	end do
end subroutine

! 反幂法求本征值
! 注意，对称三对角阵是以 n*2 矩阵的形式存储的
subroutine EigenVectors(H, v, p)
	implicit none
	integer i, j, k, n
	complex*16 :: H(:,:), v(:)
	complex*16, allocatable :: u(:)
	complex*16, allocatable :: A(:,:)
	real*8 p, lambda

	n = size(H,1)
	allocate(u(n),A(n,2))
	A = H

	! 原点位移
	forall(i=1:n) A(i,1) = A(i,1) - p
	u = 0
	! LDL^T 分解
	call LDL_Decomposition_Tridiagonal(A)
	do while (sum(abs(u-v)**2) > 1D-10)
		! 解方程
		u = v
		do i = 1, n
			v(i) = v(i) - a(i,2) * v(i-1)
		end do
		do i = n, 1, -1
			v(i) = v(i) / a(i,1) - a(i+1,2) * v(i+1)
		end do
		! 近似特征值
		lambda = 1 / maxval(abs(v))
		! 规定在0到90度范围函数平均值大于0
		if (real(sum(v(1:n/4))) < 0) lambda = -lambda
		v = v * lambda
	end do
	p = p + lambda
end subroutine

! 对称三对角阵的 LDL^T 分解
subroutine LDL_Decomposition_Tridiagonal(a)
	implicit none
	integer i, j, k, n
	complex*16 a(:,:)

	n = size(a,1)
	do i = 2, n
		! 非对角元
		a(i,2) = a(i,2) / a(i-1,1)
		! 对角元
		a(i,1) = a(i,1) - a(i,2)**2 * a(i-1,1)
	end do
end subroutine

! 传播子
subroutine Propagator(Psi, t, dt, dx, Periods, omega, Intensity)
	implicit none
	integer i, n, Periods
	complex*16 Psi(:)
	real*8 t, dt, dx, omega, Intensity
	complex*16, allocatable :: H(:,:), A(:,:), Psi_(:)

	n = size(Psi)
	allocate(H(n,2), A(n,2), Psi_(n))

	! 计算这一时刻的 Hamiltonian，并作矩阵乘法
	call Hamiltonian(H, dx, t, Periods, omega, Intensity)
	A = -Im*dt/2*H
	forall(i=1:n) A(i,1) = A(i,1) + 1

	Psi_ = A(:,1) * Psi
	Psi_(2:n) = Psi_(2:n) + A(2:n,2) * Psi(1:n-1)
	Psi_(1:n-1) = Psi_(1:n-1) + A(2:n,2) * Psi(2:n)
	Psi = Psi_

	! 计算下一时刻的 Hamiltonian，并解线性方程
	call Hamiltonian(H, dx, t+dt, Periods, omega, Intensity)
	A = Im*dt/2*H
	forall(i=1:n) A(i,1) = A(i,1) + 1
	call LDL_Decomposition_Tridiagonal(A)
	do i = 1, n
		Psi(i) = Psi(i) - A(i,2) * Psi(i-1)
	end do
	do i = n, 1, -1
		Psi(i) = Psi(i) / A(i,1) - A(i+1,2) * Psi(i+1)
	end do
end subroutine Propagator

end module