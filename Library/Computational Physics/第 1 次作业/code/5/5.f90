program project5
	integer, parameter :: ns(2) = (/100, 10000/)
	real*8, allocatable :: a1(:), a2(:), a3(:), b(:)
	integer i, j

	open (11, file = '5_output.txt')
	do j = 1, 2
		n = ns(j)
		allocate(a1(0:n+2),a2(0:n+2),a3(0:n+2),b(0:n+2))
		! 向量赋初值时，多放几个冗余的元素，便于循环时不用作额外的判断
		a1(0:n+2) = (/1.0, 0.0, 0.0, (1.0, i=3, n), 0.0, 0.0/)
		a2(0:n+2) = (/1.0, 0.0, (4.0, j=2, n), 0.0, 0.0/)
		a3(0:n+2) = (/1.0, 5.0, (6.0, k=2, n-1), 5.0, 0.0, 0.0/)
		b(0:n+2) = (/0.0, 60.0, (120.0, i=2, n-1), 60.0, 0.0, 0.0/)
		! 分解为下三角矩阵 L
		do i = 2, n
			a2(i) = a2(i) - a1(i)*a2(i-1)/a3(i-2)
			a3(i) = a3(i) - a1(i)*a1(i)/a3(i-2) - a2(i)*a2(i)/a3(i-1)
		end do
		! 对右端向量也作分解
		do i = 2, n
			b(i) = b(i) - a1(i)*b(i-2)/a3(i-2) - a2(i)*b(i-1)/a3(i-1)
		end do
		! 回代解方程
		do i = n, 1, -1
			b(i) = (b(i) - a2(i+1)*b(i+1) - a1(i+2)*b(i+2))/a3(i)
		end do
		write (11, *) 'n 取', n, '时的解：'
		write (11, *) b(1:n)
		write (*, *) 'n 取', n, '时的解计算完成，解保存到 5_output.txt'
		deallocate(a1, a2, a3, b)
	end do
end program