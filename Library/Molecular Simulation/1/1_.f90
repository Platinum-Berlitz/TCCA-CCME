program distribution
	implicit none

! divide n particles among p compartments

	integer, parameter :: p = 2, n = 2, t = 100, s = 1000
	integer i, j, k
	real*8 :: dist(p,0:n) = 0, nop(p) = 0
	real*8, external :: faculty

! loop over all cycles c

	do i = 1, t
		do j = 1, s

! distribute particles
! 1. loop over all particles
! 2. generate a random compartment (1...p)
! 3. put this particle in the compartment

! nop(j) = number of particles in compartment j

! start modification
! end modification

! make histogram

		do k = 1, p
			dist(k, nop(k)) = dist(k, nop(k)) + 1.0d0
			nop(k) = 0
		end do
		end do
	end do

	! write results
	open (21, file='output.dat')
	do jj = 0, n
		write (21, *) jj, (dist(j,jj), j=1, p)
	end do

	! write analytical dist. for p=2
	if (p == 2) then
		open (21, file='analytical.dat')
		do i = 0, n
			write (21, *) i, p * exp(faculty(n)-faculty(i)-faculty(n-i)-n)
		end do
		close (21)
	end if
	stop
end program

function faculty(n)
	implicit none
	real*8 faculty
	integer n, i

	faculty = 0.0d0
	do i = 2, n
		faculty = faculty + log(real(i, 8))
	end do
	return
end function