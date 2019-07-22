module Module_3

real*8, parameter :: pi = 3.1415926535897932384D0

contains

! 将坐标转换为声子模式，q → Q
subroutine Phonons(q)
	implicit none
	integer n, i, j
	real*8 q(:)
	! A 是 Fourier 矩阵
	real*8, allocatable :: A(:,:), q2(:,:)

	n = size(q)/2
	allocate(A(n,n),q2(2*n,1))

	! 构建 Fourier 矩阵
	forall(i=1:n,j=1:n)
		A(i,j) = sqrt(2.0/real(n))*sin(pi*i*j/(n+1))
	end forall

	! 进行变换
	q2 = spread(q,2,1)
	q2(1:n,1) = matmul(A,q2(1:n,1))
	q2(n+1:2*n,1) = matmul(A,q2(n+1:2*n,1))
	q = q2(:,1)
end subroutine Phonons

! 将声子模式转换为坐标，Q → q
subroutine Phonons_Reverse(x)
	implicit none
	integer n, i, j, k
	real*8 x(:)
	real*8, allocatable :: A(:,:), x2(:,:)

	n = size(x)/2
	allocate(A(n,n),x2(n,1))

	! 构建 Fourier 矩阵
	forall(i=1:n,j=1:n)
		A(i,j) = sqrt(2*real(n))/(n+1)*sin(pi*i*j/(n+1))
	end forall

	! 进行变换
	x2 = spread(x(1:n),2,1)
	x2 = matmul(A,x2)
	x(1:n) = x2(:,1)
end subroutine Phonons_Reverse

! 体系的正则方程
subroutine Canonical(q, mode, para)
	implicit none
	integer mode, n, i, j
	real*8 q(:), para
	real*8, allocatable :: r(:)

	n = size(q)/2
	allocate(r(n))
	r = q(n+1:2*n)

	! 这是谐振子部分的受力
	q(n+1) = -2*q(1) + q(2)
	do i = 2, n-1
		q(n+i) = q(i-1) - 2*q(i) + q(i+1)
	end do
	q(2*n) = q(n-1) - 2*q(n)

	! 非谐部分的受力，分两种模式，α 和 β
	if (mode == 1) then
		q(n+1) = q(n+1) + para * ((-q(1))**2-(q(1)-q(2))**2)
		do i = 2, n-1
			q(n+i) = q(n+i) + para * ((q(i-1)-q(i))**2-(q(i)-q(i+1))**2)
		end do
		q(2*n) = q(2*n) + para * ((q(n-1)-q(n))**2-(q(n))**2)
	else if (mode == 2) then
		q(n+1) = q(n+1) + para * ((-q(1))**3-(q(1)-q(2))**3)
		do i = 2, n-1
			q(n+i) = q(n+i) + para * ((q(i-1)-q(i))**3-(q(i)-q(i+1))**3)
		end do
		q(2*n) = q(2*n) + para * ((q(n-1)-q(n))**3-(q(n))**3)
	end if
	q(1:n) = r
end subroutine Canonical

! Runge Kutta 演化
subroutine Runge_Kutta(q, dt, mode, para)
	implicit none
	integer mode, n
	real*8 q(:), dt, para
	real*8, allocatable :: k1(:), k2(:), k3(:), k4(:)

	n = size(q)
	allocate(k1(n),k2(n),k3(n),k4(n))
	k1 = q
	call Canonical(k1, mode, para)
	k2 = q + dt * k1 / 2
	call Canonical(k2, mode, para)
	k3 = q + dt * k2 / 2
	call Canonical(k3, mode, para)
	k4 = q + dt * k3
	call Canonical(k4, mode, para)
	q = q + dt * (k1+2*k2+2*k3+k4)/6
end subroutine Runge_Kutta

end module