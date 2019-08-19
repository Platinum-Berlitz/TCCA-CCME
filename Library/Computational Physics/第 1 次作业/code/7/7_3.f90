program project7_3
	real*8, parameter :: limit = 60.0, step = 0.01
	integer, parameter :: count = nint(limit/step)
	real*8, parameter :: r_sample(0:count+1) = (/(i*step, i=0, count+1)/)
	real*8 :: integral = 0.0
	real*8 R(0:count+1), rR(0:count+1), ddrR(1:count)
	integer i

	open (11, file = '7_3_output.txt')
	! 计算 R
	forall (i=0:(count+1)) R(i) = r_sample(i)*(r_sample(i)-6) * &
	                              exp(-r_sample(i)/3)
	! 计算 rR
	rR = r_sample*R
	! 计算 rR 的二阶导数
	forall (i=1:count) ddrR(i) = (rR(i+1) + rR(i-1) - 2*rR(i))/step**2
	! 计算积分
	do i = 1, count
		integral = integral + R(i) * (r_sample(i)*0.5*ddrR(i) + &
			       (r_sample(i)-1)*R(i)) * step
	end do
	! 乘上角度部分系数
	integral = integral * (-8) / 19683
	write (*, *) 'n = 3, l = 1, m = 1 时，氢原子体系能量为：', integral
	write (11, *) integral
	write (*, *) '计算结果已经保存到 7_3_output.txt'
end program