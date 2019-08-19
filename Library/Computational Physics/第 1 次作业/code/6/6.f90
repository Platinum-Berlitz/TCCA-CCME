program project6
	integer, parameter :: ns(2) = (/100, 10000/)
	real*8, allocatable :: b(:), r(:), x(:), p(:), Ap(:), Ax(:)
	real*8 :: alpha, beta, r2, rlast2
	integer :: times = 0, i

	open (11, file = '6_output.txt')
	do i = 1, 2
		times = 0
		n = ns(i)
		! 根据参数申请内存，并给初值
	    ! 增加冗余元素，方便计算乘积
		allocate(b(0:n+1), r(0:n+1), x(0:n+1), p(0:n+1))
		allocate(Ax(0:n+1), Ap(0:n+1))
		x = 0
		b(0:n+1) = (/0.0, 2.5, (1.5, I=2, n/2-1), 1.0, &
		           1.0, (1.5, I=n/2+2, n-1), 2.5, 0.0/)
		! 计算初始残差
		Ax(1:n) = 3.0 * x(1:n) - x(2:n+1) - x(0:n-1) + &
			          0.5 * x(n:1:-1)
		Ax(n/2:n/2+1) = Ax(n/2:n/2+1) - 0.5 * x(n/2+1:n/2:-1)
		r = b - Ax
		p = r
		r2 = dot_product(r,r)
		do while (r2 > 1D-12)
			times = times + 1
			! 计算矩阵乘法
			Ap(1:n) = 3.0 * p(1:n) - p(2:n+1) - p(0:n-1) + &
			          0.5 * p(n:1:-1)
			Ap(n/2:n/2+1) = Ap(n/2:n/2+1) - 0.5 * p(n/2+1:n/2:-1)
			! 更新解
			alpha = r2/dot_product(p,Ap)
			x = x + alpha * p
			! 更新残差向量
			r = r - alpha * Ap
			rlast2 = r2
			! 计算新的残差向量模方
			r2 = dot_product(r,r)
			! 更新方向
			beta = r2/rlast2
			p = r + beta * p
		end do
		write(*, *) 'n =', n, '时，迭代次数：', times
		write(11, *) 'n =', n, '时，解为：'
		write(11, *) x(1:n)
		write(*, *) 'n =', n, '时的解已经保存到 6_output.txt'
		deallocate(b, r, x, p, Ax, Ap)
	end do
end program