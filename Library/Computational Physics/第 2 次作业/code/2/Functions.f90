module functions
	! 题中所给常数
	real*8, parameter :: pi = 3.14159265358979323846D0
	real*8, parameter :: I_p = 0.5, &
	I_0 = 5D13, E_0 = sqrt(I_0/3.5094448314D16), &
	w = 4.55633525316D1/3.2D3, &
	A_0 = E_0 / w
	complex*8, parameter :: Im = (0,1)
contains

function A(t) ! 矢势
	complex*8 A, t
	A = A_0*sin(w*t)*sin(w*t/4)**2
	return
end function

function E(t) ! 电场
	complex*8 E, t
	E = -A_0*w*(cos(w*t)*sin(w*t/4)**2 +&
		sin(w*t)*sin(w*t/4)*cos(w*t/4)/2)
	return
end function

function s(t, p_z) ! S 函数
	complex*8 s, t
	real*8 p_z
	s = I_p*t + (90*A_0**2*t*w - 240*A_0**2*sin(w*t/2) +&
	    15*A_0**2*sin(w*t) + 40*A_0**2*sin(3*w*t/2) -&
	    45*A_0**2*sin(2*w*t) + 24*A_0**2*sin(5*w*t/2) -&
	    5*A_0**2*sin(3*w*t) + 480*A_0*p_z*cos(w*t/2) -&
	    480*A_0*p_z*cos(w*t) + 160*A_0*p_z*cos(3*w*t/2) +&
	    480*p_z**2*t*w - 160*A_0*p_z)/960/w
	return
end function

function ds(t, p_z) ! S 函数导数
	complex*8 ds, t
	real*8 p_z
	ds = (p_z+A(t))**2/2+I_p
	return
end function

function dds(t, p_z) ! S 函数二阶导数
	complex*8 dds, t
	real*8 p_z
	dds = -(p_z+A(t))*E(t)
	return
end function

function f(t, p_z) ! 直接积分法中的函数
	complex*8 f, t
	real*8 p_z
	f = 2**3.5*(2*I_p)**1.25*&
	exp(Im*s(t,p_z))*(p_z+A(t))*E(t)/&
	(pi*((p_z+A(t))**2+2*I_p)**3)
	return
end function

! 求根方法

subroutine Muller(p_z, guess, solution)
	implicit none
	integer :: i
	complex*8 x, y, z, sz
	complex*8 h, h0, h1, d, d0, d1
	complex*8 :: Delta, p, b
	! 初始猜测
	complex*8 :: guess(:), solution(:)
	real*8 :: p_z

	do i = 1, 6
		! 在初始猜测附近建立其它初始点
		y = guess(i)
		x = y - 10
		z = y + 10
		! 执行 Müller 法
		do while (.true.)
			h0 = x - z
			h1 = y - z
			sz = ds(z, p_z)
			d0 = (ds(x, p_z) - sz) / h0
			d1 = (ds(y, p_z) - sz) / h1
			d = (d0 - d1)/(h0 - h1)
			b = d0 - h0 * d
			Delta = sqrt(b**2 - 4*sz*d)
			if (abs(b-Delta) < abs(b+Delta)) then
				h = -2*sz/(b+Delta)
			else
				h = -2*sz/(b-Delta)
			end if
			p = z + h
			! 判停标准为解的变动幅度足够小
			! 这样能保证有 6 位有效数字
			if (abs(h) < 1D-4) then
				if (aimag(p) < 0) p = conjg(p)
				solution(i) = p
				exit
			else
				x = y
				y = z
				z = p
			end if
		end do
	end do
end subroutine
end module