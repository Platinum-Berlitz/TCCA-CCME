! gfortran 9.f90 -o 9 && ./9
program scaling
	implicit none
	real*8 dist(100), dis, c, xold, xnew, av1, av2, maxdpl, r1
	logical lscale
	integer i, j, kk, ncycle

    call random_seed()
    ! initialize rng
    ! initialize everything
    ! xold = old position
    ! xnew = new position
    ! lscale = do we use scaling ? (.true. or .false.)
    call random_number(r1)
	do i = 1, 100
		dist(i) = 0.0d0
	end do
	xold = 0.1d0 + 0.7d0*r1
	dis = 0.0d0
	av1 = 0.0d0
	av2 = 0.0d0
    ! maxdpl = maximum displacement
    ! ncycle = number of cycles
    ! change the input parameters here !!!!!
	lscale = .true.
	maxdpl = 0.7d0
	ncycle = 10000
    ! start the simulation
	do i = 1, ncycle
		do j = 1, 10000
			av2 = av2 + 1.0d0
			if (lscale) then
                ! scale the position by a factor
                ! select at random to divide or multiply by
                call random_number(r1)
				c = 1.0d0 + r1
                call random_number(r1)
				if (r1 < 0.5d0) c = 1.0d0/c
				xnew = c*xold
                ! start modification
                ! end modification
			else
                ! random displacement
                call random_number(r1)
				xnew = xold + 2.0d0*(r1-0.5d0)*maxdpl
                ! start modification
                ! end modification
			end if
            ! sample distribution
			kk = 1 + idint(xold*100.d0)
			if (kk>=1 .and. kk<=100) dist(kk) = dist(kk) + 1.0d0
			dis = dis + 1.0d0
		end do
	end do
    ! write results to disk
	open (21, file='9.dat')
	write (21, *) 'fraction accepted trialmoves : ', av1/av2
	dis = 1.0d0/dis
	do i = 1, 100
		write (21, *) 0.01d0*dble(i), dist(i)*dis
	end do
	close (21)
	stop
end program scaling
