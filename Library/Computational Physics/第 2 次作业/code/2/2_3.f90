include 'Functions.f90'

program project2_3
	use Functions
	implicit none
	integer :: i, j, step
	real*8 Prob, p_z
	real*8 :: p_range(200) = (/(i*1D-2, i=1, 200)/)
	complex*8 :: tf = 4*pi/w, M, M_last
	complex*8, allocatable :: t(:)

	open(10, file = '2_3_output.txt')
	do i = 1, 200
		p_z = p_range(i)
		M = 1
		M_last = 0
		step = 1024
		! 变步长积分，每次增加一倍格点
		do while(abs(M_last-M)>1D-6)
			M_last = M
			step = step*2
			allocate(t(0:step))
			! 计算格点处函数值
			do j = 0, step
				t(j)=f(tf*j/step,p_z)
			end do
			! 梯形公式求积
			M = sum(t) / (step + 1) * tf
			deallocate(t)
		end do
		Prob = abs(M)**2
		write(10, *) p_z**2/2, Prob
	end do
end program