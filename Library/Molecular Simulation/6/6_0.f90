! gfortran 6.f90 -o 6 && ./6
program pi
	implicit none

	integer i, j, nstep, sstmm
	double precision ran_uniform, ll, x, y, at1, at2, pii, m1

    call random_seed()
    ! calculates pi using the circle/square problem
    ! after execution: xmgr results.data

	write (*, *) 'number of cycles ? (example: 1000)'
	read (*, *) nstep
	write (*, *) 'ratio l/d	? (always >= 1 !)'
	read (*, *) ll

	ll = ll*2.0d0
	if (ll<1.0d0) then
		write (6, *) 'ratio must be at least 1 !!!'
		stop
	end if

	at1 = 0.0d0
	at2 = 0.0d0

	open (21, file='results.data', form='formatted')
    ! loop over all cycles

	do i = 1, nstep
		do j = 1, 1000
        ! generate a uniform point
        ! check if it is in the circle
        ! at2 = number of points
        ! at1 = number in the circle
        ! start modifications

        ! end modifications
		end do
		if (mod(i,10)==0) write (21, *) i, ll*ll*at1/at2
	end do

	pii = ll*ll*at1/at2
    ! the real value of pi can be calculated using
    ! pi = 4.0 * arctan (1.0)
	write (21, *) 'estimate of pi : ', pii
	write (21, *) 'real pi				: ', 4.0d0*atan(1.0d0)
	write (21, *) 'relative error : ', dabs(pii-4.0d0*atan(1.0d0))/(4.0d0*atan(1.0d0))
	stop
	close (21)
end program pi
