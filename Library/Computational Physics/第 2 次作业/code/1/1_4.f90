include 'EigenProblem.f90'

program project1_4
	use EigenProblem
	implicit none
	integer i, j, k, l
	real*8, parameter :: q = 10
	integer, parameter :: n = 101
	real*8 :: H(n,n), EV(n), Psi(n), top(11)

	open(10, file = '1_4_output.txt')
	call random_seed()
	call Hamiltonian(H, q, N)
	call EigenValues(H, EV)
	do i = 1, 11
		top(i) = minval(EV)
		EV(minloc(EV)) = maxval(EV)
		do j = 1, n
			call random_number(Psi(j))
		end do
		call EigenVectors(H, Psi, top(i))
		! 输出本征值和本征函数
		if (mod(i,2) == 1) then
			write(10, *) top(i)
			write(10, *) Psi(1:N/4+1)
		end if
	end do
end program