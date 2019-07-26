! gfortran 9.f90 -o 9 && ./9

program scaling
	implicit none
	real*8 :: c, xold, xnew, delta = 7d-1, r1
	logical :: scale = .false.
	integer :: i, j, k, accepted = 0, ncycle = 1e7, dist(100) = 0

    call random_seed() 
    call random_number(xold)
    ! start the simulation
	do i = 1, ncycle
		if (scale) then
			! scale the position by a factor
			call random_number(r1)
			c = 1.0d0 + r1 * delta
			call random_number(r1)
			if (r1 < 0.5d0) c = 1d0/c
			xnew = c * xold
			call random_number(r1)
			if (xnew < 1 .and. r1 < min(1d0, xnew / xold)) then
				xold = xnew
				accepted = accepted + 1d0
			end if
		else
			! random displacement
			call random_number(r1)
			xnew = xold + 2d0 * (r1-5d-1) * delta
			if (xnew < 1 .and. xnew > 0) then
				xold = xnew
				accepted = accepted + 1d0
			end if
		end if
		! sample distribution
		k = 1 + int(xold * 100)
		dist(k) = dist(k) + 1
	end do
    ! write results to disk
	open (21, file = '9.dat')
	write (21, *) 'fraction accepted trialmoves : ', real(accepted) / ncycle
	do i = 1, 100
		write (21, '(f4.2,a1,f4.2,a2,f10.5)') 1e-2*(i-1), '~', 1e-2*i, ': ', real(dist(i)) / ncycle
	end do
	close (21)
	stop
end program