include 'EigenProblem.f90' 

program project1_2
	use EigenProblem
	implicit none
	integer i, j, k
	real*8, parameter :: q(0:20) = (/(i, i=0, 20)/)
	integer, parameter :: n = 101
	real*8 :: H(n,n), EV(n), top(11), Psi(n)

	open(10, file = '1_2_output.txt')
	call random_seed()
	do k = 0, 20
		! 计算矩阵元
		call Hamiltonian(H, q(k), N)
		! 计算本征值
		call EigenValues(H, EV)
		! 选出最小的本征值
		do i = 1, 11
			top(i) = minval(EV)
			EV(minloc(EV)) = maxval(EV)
			! 随机初始向量
			do j = 1, n
				call random_number(Psi(j))
			end do
			! 利用反幂法优化本征值
			call EigenVectors(H, Psi, top(i))
		end do
		write(10, *) 'q=', q(k), top
		print *, 'q=', q(k), '计算完成'
	end do
end program