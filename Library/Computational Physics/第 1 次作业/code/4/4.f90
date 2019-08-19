program project4
	integer, parameter :: n = 9
	real*8, parameter :: x(0:n) = (/0, 3, 5, 7, 9, &
		                          11, 12, 13, 14, 15/)
	real*8, parameter :: y(0:n) = (/0.0, 1.2, 1.7, 2.0, &
		                          2.1, 2.0, 1.8, 1.2, 1.0, 1.6/)
	real*8 :: x_new(0:nint(x(n)*10)) = (/(i*0.1, i = 0, nint(x(n)*10))/)
	real*8 :: y_new(0:nint(x(n)*10)) = 0.0
	real*8 :: h(0:n-1) = 0.0, d(1:n-1) = 0.0, m(0:n) = 0.0
	real*8 :: lambda(1:n-2) = 0.0, mu(2:n-1) = 0.0, b(1:n-1) = 2
	real*8 :: c1, c2, q, xn

	! 根据定义计算方程系数
	forall (i=0:n-1) h(i) = x(i+1)-x(i)
	forall (i=1:n-1) d(i) = ((y(i+1)-y(i))/h(i)-(y(i)-y(i-1))/h(i-1))* &
	                        6/(h(i-1)+h(i))
	forall (i=2:n-1) mu(i) = h(i-1)/(h(i-1)+h(i))
	forall (i=1:n-2) lambda(i) = h(i)/(h(i-1)+h(i))

	! 追赶法解方程，首先进行分解
	do i=2, n-1
		q = mu(i)/b(i-1)
		b(i) = b(i)-q*lambda(i-1)
		d(i) = d(i)-q*d(i-1)
	end do
	! 回代求解
	m(n-1) = d(n-1)/b(n-1)
	do i=n-2, 1, -1
		m(i) = (d(i)-lambda(i)*m(i+1))/b(i)
	end do

	! 根据三次样条函数方程求 y 的值
	do i=0, n-1
		c1 = (y(i+1)-y(i))/h(i)-h(i)*(m(i+1)-m(i))/6
		c2 = (y(i)*x(i+1)-y(i+1)*x(i))/h(i)- & 
		     h(i)*(x(i+1)*m(i)-x(i)*m(i+1))/6
		do j=0, nint(h(i))*10
			xn = x(i)+j*0.1
			y_new(nint(10*xn)) = (x(i+1)-xn)**3*m(i)/6/h(i)+ &
			                     (xn-x(i))**3*m(i+1)/6/h(i)+ &
			                     c1*xn+c2
		end do
	end do
	open (11, file = '4_output.txt')
	write (11, *) y_new
	write (*, *) '计算结果已经保存到 4_output.txt'
end program