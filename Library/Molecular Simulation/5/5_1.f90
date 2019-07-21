! gfortran 5_1.f90 -o 5_1 && ./5_1
program random2d
	implicit none

	! random walk 2d
	integer, parameter :: njump = 10000, ninit = njump / 4, M = 32, N = 20
	integer :: i, j, k, t
	integer :: lattice(M,M) = 0, part(N,2) = 0, part_(N,2) = 0
	integer :: accepted, dt, trace(N, 2, njump), r2(njump, 2) = 0, nr2(njump) = 0, r(2), dr(2)
	real :: r1

	open (21, file = '5_1.dat')	
	do j = 1, N
		do while (.true.)
			call random_number(r1)
			r(1) = 1 + int(r1 * M)
			call random_number(r1)
			r(2) = 1 + int(r1 * M)
			if (lattice(r(1), r(2)) == 0) exit
		end do
		lattice(r(1), r(2)) = j
		part(j,:) = r
		part_(j,:) = r
	end do

	do i = 1, njump
		call random_number(r1)
		j = 1 + int(r1 * N)
		call random_number(r1)
		if (r1 < 2.5d-1) then
			dr = (1, 0)
		else if (r1 < 5d-1) then
			dr = (0, 1)
		else if (r1 < 7.5d-1) then
			dr = (-1, 0)
		else
			dr = (0, -1)
		end if
		! new position
		! put particle back on the lattice
		r = part(j,:) + dr
		r = r - M * int((r - 1) / M)
		if (lattice(r(1), r(2)) == 0) then
			lattice(r(1), r(2)) = j
			lattice(part(j,1), part(j,2)) = 0
			part(j,:) = r
			part_(j,:) = part_(j,:) + dr
			accepted = accepted + 1
		end if
		if (i > ninit) then
			k = i - ninit
			do j = 1, N
				trace(j,:,k) = part_(j,:)
			end do
			! loop over all time origins
			do t = 0, k - 1
				dt = k - t
				do j = 1, N
					r2(dt,:) = r2(dt,:) + (part_(j,:)-trace(j,:,t))**2
					nr2(dt) = nr2(dt) + 1
				end do
			end do
		end if
	end do

	! write results
	! write everything to disk
	write (21, *) 'accepted jumps : ', real(accepted) / njump
	write (21, *) 'lattice occupation : ', real(N) / M**2
	do i = 1, njump
		if (nr2(i) /= 0) then
			write (21, *) i, real(r2(i,:), 8) / nr2(i)
		end if
	end do
	close (21)
	stop
end program random2d