program project7_2
	integer, parameter :: l(3) = (/100, 500, 1000/)
	integer :: i, j, k, m(4) = 0
	real*8, parameter :: pi = 3.14159265358979323846
	real*8, parameter :: theta(3) = (/0.001*pi, 0.3*pi, 0.501*pi/)
	real*8, parameter :: phi = pi*0.2
	! 先定义约化连带 Legendre 函数
	interface
		function P(l, m, x)
		integer l, m
		real*8 x, P(2)
		end function
	end interface
	complex*8 :: Y, z
	! 定义由指数和小数组成的数组，接收 P 函数的结果
	real*8 x, frac_exp(2), frac, exp

	open (11, file = '7_2_output.txt')
	write (11, '(A10,A10,A10,A10,A50)') &
	'l', 'm', 'theta', 'phi', 'Y'
	do i=1,3
		m = (/1, l(i)/100, l(i)/10, l(i)-1/)
		do j=1,4
			z = complex(cos(m(j) * phi), sin(m(j) * phi))
			! 修正由三角函数精确度不够造成的问题
			if (mod(m(j), 5) == 0) z = complex(cos(m(j) * phi), 0)
			do k=1,3
				x = cos(theta(k))
				frac_exp = P(l(i),m(j),x)
				! 分别取出小数和指数部分
				frac = frac_exp(1)
				exp = frac_exp(2)
				Y = frac * z
				! 规范化科学计数法表示
				if (abs(real(Y)) < 1) then
					Y = Y * 10
					exp = exp - 1
				end if
				write (*, '(A2,I5,A5,I5,A9,F6.3,A7,F6.3,$)') &
				'l=', l(i), 'm=', m(j), 'theta=', theta(k), 'phi=', phi
				write (*, '(A15,F12.9,SPF12.9,A4,I5)') &
				'Y= (', real(Y), aimag(Y), 'i) E', floor(exp)
				write (11, '(I10,I10,F10.6,F10.6,$)') &
				l(i), m(j), theta(k), phi
				write (11, '(A5,F20.15,F20.15,A4,I5)') &
				'(', real(Y), aimag(Y), 'i) E', floor(exp)
			end do
		end do
	end do
	write (*, *) '计算结果已经保存到 7_2_output.txt'
end program

function P(l, m, x)
	integer l, m, i
	real*8, parameter :: pi = 3.14159265358979323846
	real*8 x, f, g, h, part_e, part_f, P(2), exp, exp_int
	part_e = exponent(1-x**2)
	part_f = fraction(1-x**2)
	! 先算 P_mm
	g = 1.0/4.0/pi
	do i = 1, m
		g = g*(2*i+1.0)/(2.0*i)
	end do
	g = sqrt(g) * (-1)**m * part_f**(m/2.0)
	! 开始递推
	f = 0
	h = 0
	do i = m+1, l
		h = x * sqrt((4 * i**2 - 1.0)/(i**2 - m**2)) * g - sqrt(((i - 1)**2 - m**2)*(2 * i + 1.0)/(i**2 - m**2)/(2 * i - 3)) * f
		f = g
		g = h
	end do
	! 通过对数将以 2 为底的指数变成以 10 为底
	part_e = part_e * m / 2.0 + exponent(g)
	exp = part_e * log10(2.0)
	! 多余的部分乘到小数上，此时小数在 0.5 到 10 之间
	g = fraction(g) * 10 ** (exp - floor(exp))
	P = (/g, exp/)
	return
end function