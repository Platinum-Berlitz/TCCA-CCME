include 'EigenProblem.f90'

program project1_3
	use EigenProblem
	implicit none
	integer i, j, k, l, n
	real*8, parameter :: q(0:20) = (/(i, i=0, 20)/)
	integer, parameter :: n_list(2) = (/11, 81/)
	real*8, allocatable :: H(:,:), EV(:), Psi(:)
	real*8 :: top(9) = 0

	open(10, file = '1_3_output.txt')
	call random_seed()
	do l = 1, 2
		! 确定格点数
		n = n_list(l)
		allocate(H(n,n),EV(n),Psi(n))
		do k = 0, 20
			call Hamiltonian(H, q(k), n)
			call EigenValues(H, EV)
			do i = 1, 9
				top(i) = minval(EV)
				EV(minloc(EV)) = maxval(EV)
				do j = 1, n
					call random_number(Psi(j))
				end do
				call EigenVectors(H, Psi, top(i))
			end do
			! 选出 5 个偶宇称解
			write(10, *) 'q=', q(k), top(1:9:2)
			print *, 'q=', q(k), '计算完成'
		end do
		deallocate(H,EV,Psi)
	end do
end program