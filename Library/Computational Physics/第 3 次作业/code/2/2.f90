module Module_2

real*8, parameter :: pi = 3.1415926535897932384D0
complex*16, parameter :: Im = complex(0D0,1D0)
real*8, parameter :: omega = 5.7D-2
real*8, parameter :: T0 = 2*pi/omega
real*8, parameter :: A0 = 1.325D0
real*8, parameter :: Ip = 5D-1

contains

! Monte Carlo 抽样子程序
subroutine Monte_Carlo(E, Sample)
	implicit none
	integer :: count, n
	real*8 E, sigma
	real*8 Sample(:)
	real*8 u1, u2, v
	
	sigma = sqrt(E/2)

	call random_seed()
	count = 1
	n = size(Sample)
	do while(count < n)
		! 舍选抽样法
		! 抽到符合条件电子放入 Sample
		! 直到 Sample 抽满
		call random_number(u1)
		v = 10*sigma*u1 - 5*sigma
		call random_number(u2)
		if (u2 < exp(-v**2/E)) then
			Sample(count) = v
			count = count + 1
		end if
	end do
end subroutine Monte_Carlo

! 复电场计算函数
! mode = 1 是线偏光，= 2 是椭偏光
function Polarized_E(t, mode) result(E)
	implicit none
	integer mode
	real*8 t
	complex*16 E

	! 公式推导见文档
	if (mode == 1) then
		E = - A0 *(cos(omega*t/8)**2 * omega* cos(omega*t) - &
			sin(omega*t/4)*omega/8 * sin(omega*t))
	else
		E = - A0 * complex(&
			(cos(omega*t/8)**2 * omega* cos(omega*t) - &
			sin(omega*t/4)*omega/8 * sin(omega*t)) *sqrt(0.8), &
			(-cos(omega*t/8)**2 * omega* sin(omega*t) - &
			sin(omega*t/4)*omega/8 * cos(omega*t)) *sqrt(0.2))
	end if
	return
end function

! 体系的正则方程
subroutine Canonical(q, t, mode)
	implicit none
	integer mode
	real*8 t
	complex*16 q(:), E

	E = Polarized_E(t, mode)
	! 复位置的导数是复动量
	! 复动量的导数是 Coulumb 力和电场力之和
	q(:) = (/q(2),-q(1)/((abs(q(1))**2+0.04D0)**1.5) - E/)
end subroutine Canonical

! Runge_Kutta 法进行方程的一步演化
subroutine Runge_Kutta(q, t, dt, mode)
	implicit none
	integer mode, n
	complex*16 q(:)
	real*8 t, dt
	complex*16 k1(2), k2(2), k3(2), k4(2)

	k1 = q
	call Canonical(k1, t, mode)
	k2 = q + dt * k1 / 2
	call Canonical(k2, t + dt / 2, mode)
	k3 = q + dt * k2 / 2
	call Canonical(k3, t + dt / 2, mode)
	k4 = q + dt * k3
	call Canonical(k4, t + dt, mode)
	q = q + dt * (k1+2*k2+2*k3+k4)/6
end subroutine Runge_Kutta
end module