! gfortran 6.f90 -o 6 && ./6
program pi_estimator
	implicit none
	integer :: i, j, precision, s = 0, t = 0
	real*8 :: x, y, pi, pii, l = 1d0

    call random_seed()
	open (21, file='6.dat')
    pi = 4d0 * atan(1d0)
	write (21, *) 'real pi : ', pi
	write (21, *) 'estimation start : '

	do while ( .true. )
		do i = 1, 10000000
			t = t + 1
			call random_number(x)
			call random_number(y)
			x = 2*x*l - l
			y = 2*y*l - l
			if ((x*x + y*y) < 1) s = s + 1
		end do
		pii = 4 * l**2 * s / t
		print *, s, t, pii
		write (21, *) 'estimate of pi : ', pii
		write (21, *) 'relative error : ', abs(pii-pi)/pi
		if (abs(pii-pi) < 1d-4) exit
	end do

	stop
	close (21)
end program