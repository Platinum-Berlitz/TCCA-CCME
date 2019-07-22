program project7_1
	integer, parameter :: n(3) = (/3, 10, 30/)
	integer, parameter :: a(3) = (/2, 20, 40/)
	real*8 :: x(3) = (/0.001, 1.0, 100.0/)
	real*8, external :: L
	integer i, j, k
	real*8 output

	open (11, file = '7_1_output.txt')
	write (11, '(A10,A10,A10,A20)') &
	'n', 'alpha', 'x', 'L'
	do i=1,3
		do j=1,3
			do k=1,3
				! 遍历给定的几组参数，分别输出
				output = L(n(i),a(j),x(k))
				write (*, '(A2,I5,A10,I5,A6,F10.3,A10,E20.10E3)') &
				'n=', n(i), 'alpha=', a(j), 'x=', x(k), '时，L=', output
				write (11, '(I10,I10,F10.3,E20.10E3)') &
				n(i), a(j), x(k), output
			end do
		end do
	end do
	write (*, *) '计算结果已经保存到 7_1_output.txt'
end program

function L(n, a, x)
	integer n, a, i
	real*8 x, f, g, h, L
	! n = 0 和 n = 1 时的初值
	f = 1
	g = 1+a-x
	! 开始递推
	do i = 1, n-1
		h = (-(i+a)*f+(2*i+1+a-x)*g)/(i+1)
		f = g
		g = h
	end do
	L = g
	return
end function