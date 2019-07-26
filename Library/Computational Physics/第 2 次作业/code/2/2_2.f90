include 'Functions.f90'

program project2_2
	use Functions
	implicit none
	integer i, j, k
	real*8 Prob, p_z
	real*8 :: p_range(200) = (/(i*1D-2, i=1, 200)/)
	complex*8 :: M, t
	complex*8 :: guess(6) = &
	(/(0,100), (100,100), (200,100), &
	(400,100), (600,100), (700,100)/)
	complex*8 solution(6)
	
	open(10, file = '2_2_output.txt')
	do i = 1, 200
		p_z = p_range(i)
		call Muller(p_z,guess,solution)
		M = 0
		! 进行对鞍点的求和
		do j = 1, 6
			t = solution(j)
			M = M + (2*I_p)**(5/4) / 2**0.5&
			*exp(Im*s(t,p_z)) / dds(t,p_z)
		end do
		! 计算几率
		Prob = abs(M)**2
		write(10, *) p_z**2/2, Prob
	end do
end program