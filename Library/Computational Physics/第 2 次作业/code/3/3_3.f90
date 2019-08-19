program project3_3
	real*8, parameter :: pi = 3.14159265358979323846D0
	integer, parameter :: steps = 100, tries = 10000
	real*8 :: step(steps), average(steps) = 0
	real*8 :: x = 0, y = 0, theta, r
	real*8 :: numbers(100) = (/(real(i), i = 1, 100)/)

	open(10, file = '3_3_output.txt')
	do j = 1, tries
		x = 0
		y = 0
		call random_seed()
		do i = 1, size(step)
			call random_number(step(i))
			! 将 [0,1] 之间的随机数转化为方位角
			theta = 2 * pi * step(i)
			x = x + cos(theta)
			y = y + sin(theta)
			r = sqrt(x**2+y**2)
			! 将距离录入平均值
			average(i) = average(i) + r
		end do
	end do
	! 计算平均值
	average = average / tries
	do i = 1, size(step)
		write(10, *) i, average(i)
	end do
	! 最小二乘法的公式实现
	write(10, *) '拟合参数为：', &
	sum(sqrt(numbers)*average)/sum(numbers)
end program