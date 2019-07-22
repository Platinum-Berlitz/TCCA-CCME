module EigenProblem
contains
subroutine EigenValues(H, EV)
	implicit none
	integer j, k, n
	real*8 :: H(:,:), EV(:)
	real*8, allocatable :: a(:,:)
	real*8, allocatable :: x(:), x2(:,:), r(:,:)
	real*8, allocatable :: I(:,:), z(:,:), g(:,:)
	real*8 :: l = 0, c = 0, s = 0, d = 0

	n = size(H,1)
	allocate(a(n,n),r(n,n),I(n,n),z(n,n),&
		g(n,n),x(n),x2(n,1))
	! 复制一份矩阵，a 用来做运算，H 不变
	a = H

	! 单位矩阵
	I = 0
	forall (j=1:n) I(j,j) = 1
	! Householder 变换
	do j = 1, n-2
		x(:) = a(:,j)
		x(1:j) = 0
		if (x(j+1) > 0) then
			x(j+1) = x(j+1) + sqrt(dot_product(x,x))
		else
			x(j+1) = x(j+1) - sqrt(dot_product(x,x))
		end if
		x2 = spread(x,2,1)
		r = 2 * matmul(x2,transpose(x2)) / dot_product(x,x)
		a = a - matmul(r, a)
		a = a - matmul(a, r)
	end do
	k = n
	! Givens 变换
	do while (k > 1)
		! 判停标准
		if (abs(a(k,k-1)) < 1D-8) k = k - 1
		d = a(k,k)
		forall (j=1:k) a(j,j) = a(j,j) - d
		g = I
		do j = 1, k - 1
			c = a(j,j)/sqrt(a(j,j)**2+a(j+1,j)**2)
			s = a(j+1,j)/sqrt(a(j,j)**2+a(j+1,j)**2)
			z = I
			z(j,j) = c
			z(j+1,j+1) = c
			z(j,j+1) = s
			z(j+1,j) = -s
			a = matmul(z,a)
			g = matmul(z,g)
		end do
		a = matmul(a, transpose(g))
		forall (j=1:k) a(j,j) = a(j,j) + d
	end do
	! 保存到 EV 向量中
	forall (j=1:n) EV(j) = a(j,j)
	return
end subroutine

subroutine EigenVectors(H, v, p)
	implicit none
	integer i, j, k, n
	real*8 :: H(:,:), v(:)
	real*8, allocatable :: a(:,:), u(:)
	real*8 p, lambda

	n = size(H,1)
	allocate(u(n))
	a = H

	! 原点位移
	forall(i=1:n) a(i,i) = a(i,i) - p
	u = 0
	! LDL^T 分解
	call LDL_Decomposition(a)
	do while (dot_product(u-v,u-v) > 1D-8)
		! 解方程
		u = v
		do i = 1, n
			do k = 1, i-1
				v(i) = v(i) - a(i,k) * v(k)
			end do
		end do
		do i = n, 1, -1
			v(i) = v(i) / a(i,i)
			do k = i+1, n
				v(i) = v(i) - a(k,i) * v(k)
			end do
		end do
		! 近似特征值
		lambda = 1 / maxval(abs(v))
		! 规定在0到90度范围函数平均值大于0
		if (sum(v(1:n/4)) < 0) lambda = -lambda
		v = v * lambda
	end do
	p = p + lambda
end subroutine

subroutine LDL_Decomposition(a)
	implicit none
	integer i, j, k, n
	real*8 a(:,:)

	n = size(a,1)
	do i = 2, n
		! 非对角元，覆盖填入
		do j = 1, i-1
			do k = 1, j-1
				a(i,j) = a(i,j) - a(i,k) * a(j,k) * a(k,k)
			end do
			a(i,j) = a(i,j) / a(j,j)
		end do
		! 对角元，覆盖填入
		do k = 1, i-1
			a(i,i) = a(i,i) - a(i,k)**2 * a(k,k)
		end do
	end do
end subroutine

subroutine Hamiltonian(H, q, n)
	implicit none
	real*8 H(:,:)
	real*8, parameter :: pi = 3.14159265358979323846D0
	integer n, i, j
	real*8 q, t, v

	do i = 1, n
		do j = 1, n
			! 对角元
			if (i == j) then
				t = (n - 1) * (n + 1) / 12.0
				v = 2 * q * cos(4 * pi * j / n)
				H(i,j) = t + v
			! 非对角元
			else
				t = (-1)**(i - j) * cos(pi * (i - j) / n)&
				/ (1 - cos(2 * pi * (i - j) / n))
				H(i,j) = t
			end if
		end do
	end do
end subroutine
end module