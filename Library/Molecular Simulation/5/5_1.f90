! gfortran 5_1.f90 -o 5_1 && ./5_1
program random2d
	implicit none

	! random walk 2d
	integer :: i, j, k, l, t
	integer, parameter :: njump = 100000, ninit = njump / 4, M = 32, Ns(10) = (/(10*i, i=1, 10)/), tmax = 100
	integer :: lattice(M,M) = 0
	integer, allocatable :: part(:,:), part_(:,:), trace(:,:,:)
	integer :: N, accepted, dt, r2(tmax, 2), nr2(tmax), r(2), dr(2)
	real :: r1

	open (21, file = '5_1.dat')
	do l = 1, 10
		N = Ns(l)
		accepted = 0
		lattice = 0
		r2 = 0
		nr2 = 0
		allocate(part(N,2), part_(N,2), trace(N,2,njump-ninit))
		part = 0
		part_ = 0
		trace = 0
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
		! print *, 'test sigbus'
		call random_number(r1)
		j = 1 + int(r1 * N)
		if (j > N) print *, 'Warning'
		call random_number(r1)
		if (r1 < 2.5d-1) then
			dr = (/1, 0/)
		else if (r1 < 5d-1) then
			dr = (/0, 1/)
		else if (r1 < 7.5d-1) then
			dr = (/-1, 0/)
		else
			dr = (/0, -1/)
		end if
		! print *, dr
		! new position
		! put particle back on the lattice
		r = part(j,:) + dr
		do k = 1, 2
			if (r(k) < 1) r(k) = r(k) + M
			if (r(k) > M) r(k) = r(k) - M
		end do
		! r = r - M * int(real(r - 1) / M)
		if (lattice(r(1), r(2)) == 0) then
			lattice(r(1), r(2)) = j
			lattice(part(j,1), part(j,2)) = 0
			part(j,:) = r
			part_(j,:) = part_(j,:) + dr
			accepted = accepted + 1
		end if
		! print *, 'samp'
		if (i > ninit) then
			k = i - ninit
			do j = 1, N
				trace(j,:,k) = part_(j,:)
			end do
			! loop over all time origins
			do t = max(1, k - tmax), k - 1
				dt = k - t
				nr2(dt) = nr2(dt) + 1
				do j = 1, N
					! if (dt == 1) print *, r2(1,:)
					r2(dt,:) = r2(dt,:) + (trace(j,:,k)-trace(j,:,t))**2
				end do
			end do
			! print *, r2(1,:), nr2(1)
		end if
	end do
	! print *, 'end loop'
	! write results
	! write everything to disk
	write (21, *) 'accepted jumps : ', real(accepted) / njump
	write (21, *) 'lattice occupation : ', real(N) / M**2
	do i = 1, tmax
		if (nr2(i) /= 0) then
			write (21, *) i, real(r2(i,:), 8) / nr2(i)
		end if
	end do
	deallocate(part, part_, trace)
	end do
	close (21)
	stop
end program random2d