! gfortran 1_.f90 -o 1 && ./1
program distribution
	implicit none

! divide n particles among p compartments

	integer, parameter :: p = 10, n = 1000, t = 100, s = 1000
	integer i, j, k
	integer :: c, w(p) = 0
	real*8 :: dist(p,0:n) = 0, a(0:n) = 0, q
	real*8, external :: f

	call random_seed()

! loop over all cycles c

	do i = 1, t
		do j = 1, s
			do k = 1, n
				call random_number(q)
				c = int(p * q) + 1
				w(c) = w(c) + 1
			end do
		do k = 1, p
			dist(k, w(k)) = dist(k, w(k)) + 1d0
			w(k) = 0
		end do
		end do
	end do

	dist = dist / real(s, 8) / real(t, 8)

	! write results
	open (21, file='1.dat')
	write (21, *) 'Numerical:'
	do i = 0, n
		write (21, *) i, (dist(j,i), j = 1, p)
	end do

	! write analytical dist. for p=2
	if (p == 2) then
		write (21, *) 'Analytical:'
		do i = 0, n/2
			a(i) = exp(f(n, i))
		end do
		a(n/2 + 1:n) = a(0:(n - 1)/2)
		do i = 0, n
			write (21, *) i, a(i)
		end do
	end if
	stop
end program

function f(n, i)
	implicit none
	real*8 f
	integer n, i, j, i_

	f = 0d0
	if (i > n/2) i = n - i
	do j = 1, i
		f = f + log(real(n - i + j, 8)) - log(real(j, 8))
	end do
	f = f - n ** log(2d0)
	return
end function