program project_2
	real*8, parameter :: a = 1, b = 1, c = 1, d = 1
	real*8, parameter :: x1 = sqrt(0.4), x2 = -sqrt(0.4)
	real*8, parameter :: C1 = 4.0/3.0, C2 = 4.0/3.0
	real*8 numerical_1, analytical_1, numerical_2, analytical_2

	open (unit = 11, file = '2_output.txt', status = 'replace')
	! 例 1: f = ax^3+bx^2+cx+d，应该得到精确解
	numerical_1 = C1*(a*x1**3+b*x1**2+c*x1+d) + &
	              C2*(a*x2**3+b*x2**2+c*x2+d)
	analytical_1 = 16*b/15+8*d/3
	write (*, '(A15,F6.3,A3,SPF6.3,A3,SPF6.3,A3,SPF6.3)') &
	'三次函数：', a, 'x^3', b, 'x^2', c, 'x', d
	write (*, *) &
	'数值积分为：', numerical_1, '解析积分为：', analytical_1
	! 例 2: f = e^x = 1+x+x^2/2+x^3/6...，前四项拟合精度尚可
	numerical_2 = C1*exp(x1) + C2*exp(x2)
	analytical_2 = 2*exp(1.0) - 6*exp(-1.0)
	write (*, '(A15,A3)') &
	'指数函数：', 'e^x'
	write (*, *) &
	'数值积分为：', numerical_2, '解析积分为：', analytical_2
	write (11, *) 'cubic_num', numerical_1, 'cubic_anal', analytical_1
	write (11, *) 'exp_num', numerical_2, 'exp_anal', analytical_2
	write (*, *) '计算结果已经保存到 2_output.txt'
end program