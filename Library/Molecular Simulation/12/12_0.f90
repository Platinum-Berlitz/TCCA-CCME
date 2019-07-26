program ising ! 2d ising model
    ! gfortran 12_1.f90 -o 12_1 && ./12_1
	implicit none
    ! no pbc, 4 neighbors
	integer, parameter :: maxlat = 32, nsize = 32, maxmag = 1024, ncycle = 100, ninit = ncycle / 4
    integer :: iup(4), jup(4), magnet, energy, i, j, k, inew, jnew, lnew, lold, diff, ilat, jlat, kkk, mnew, mold
	integer lattice(0:maxlat+1, 0:maxlat+1)
	real*8 :: beta = 1d0, av1 = 0, av2 = 0, dist2, weight, move1 = 0, move2 = 0, dist3
    real*8 :: w(0:maxmag) = 1, dist1(-maxmag:maxmag), tstart, tend, r1, r2

    open (10, file = '12_1.dat')
    ! multicanonical algorithm c
	open (21, file='w1.dat')
	do i = 0, maxmag, 2
		read (21, *) k, av1
		w(k) = av1
	end do
    close (21)
	call cpu_time(tstart)
	dist1 = 0d0
    ! initialize lattice c
    ! random lattice c
    ! add one boundary layer with spin=0 c
    ! this is a way to avoid if-statements in the computation of the energy c
    ! nsize	= size of the lattice c
    ! lattice(i,j) = spin of site (i,j) c
	lattice = 0
	do i = 1, nsize
		do j = 1, nsize
            call random_number(r1)
			if (r1 < 0.5d0) then
				lattice(i, j) = 1
			else
				lattice(i, j) = -1
			end if
		end do
	end do
    ! initialize neighbours c
	iup(1) = 1
	jup(1) = 0
	iup(2) = -1
	jup(2) = 0
	iup(3) = 0
	jup(3) = 1
	iup(4) = 0
	jup(4) = -1
    ! calculate initial energy c
    ! magnet = total magnetisation c
	energy = 0
	magnet = 0
	do i = 1, nsize
		do j = 1, nsize
			magnet = magnet + lattice(i, j)
			do k = 1, 4
				inew = i + iup(k)
				jnew = j + jup(k)
				energy = energy - lattice(i, j)*lattice(inew, jnew)
			end do
		end do
	end do
	energy = energy/2
	write (10, *) 'initial energy: ', energy
	write (10, *) 'initial magnetization: ', magnet
    ! loop over all cycles c
	do i = 1, ncycle
		do j = 1, 100*nsize**2
            ! flip a single spin c
            ! metropolis algorithm c
            call random_number(r1)
            call random_number(r2)
			ilat = 1 + int(r1*dble(nsize))
			jlat = 1 + int(r2*dble(nsize))
			mold = magnet
			lold = lattice(ilat, jlat)
			lnew = -lold
			mnew = mold + lnew - lold
			diff = 0
			move2 = move2 + 1.0d0
            ! calculate the energy difference c
            ! between new and old c
            ! start modification
            ! end modification
            ! acceptance/rejection rule c
            ! use weight function w c
            call random_number(r1)
			if (r1<exp((-beta*dble(diff))+w(abs(mnew))-w(abs(mold)))) then
                ! update the lattice/energy/magnetisation c
				move1 = move1 + 1.0d0
                ! start modification
                ! end modification
			end if
			! if (i>ninit) then
			! 	weight = exp(-w(abs(magnet)))
			! 	av1 = av1 + weight*dble(energy)
			! 	av2 = av2 + weight
			! 	dist1(magnet) = dist1(magnet) + 1.0d0
			! end if
			if (i > ninit) then
				av1 = av1 + energy
				av2 = av2 + 1
				dist1(magnet) = dist1(magnet) + 1d0
			end if
		end do
	end do
	write (10, *)
	write (10, *) 'average energy: ', av1/av2
	write (10, *) 'fraction accepted swaps: ', move1/move2
    call cpu_time(tend)
	write (10, *) 'elapsed time [s] : ', tend - tstart
	write (10, *) 'final energy	(simu) : ', energy
	write (10, *) 'final magnetization (simu) : ', magnet
    ! calculate distributions c
    ! magnetisation c
	dist2 = 0.0d0
	dist3 = 0.0d0
	do i = -maxmag, maxmag, 2
		weight = exp(-w(abs(i)))
		dist2 = dist2 + dist1(i)
		dist3 = dist3 + dist1(i)*weight
	end do
	dist2 = 1.0d0/dist2
	dist3 = 1.0d0/dist3
	open (21, file='magnetic.dat')
	do i = -maxmag, maxmag, 2
		if (dist1(i)>0.5d0) then
			weight = exp(-w(abs(i)))
			write (21, *) i, dist1(i)*dist2, dist1(i)*dist3*weight
		end if
	end do
    close (21)
    ! weight distribution c
	dist2 = 0.0d0
	do i = 0, maxmag, 2
		dist1(i) = max(1.0d0, dist1(i)+dist1(-i))*exp(-w(abs(i)))
		dist1(i) = -log(dist1(i))
		dist2 = min(dist2, dist1(i))
	end do
	do i = 0, maxmag, 2
		dist1(i) = dist1(i) - dist2
		dist1(i) = min(10.0d0, 1.05d0*dist1(i))
	end do
	open (21, file='w.dat')
	do i = 0, maxmag, 2
		write (21, *) i, dist1(i)
	end do
    close (21)
    ! calculate final energy c
    ! used to check the code c
	energy = 0
	magnet = 0
	do i = 1, nsize
		do j = 1, nsize
			magnet = magnet + lattice(i, j)
			do k = 1, 4
				inew = i + iup(k)
				jnew = j + jup(k)
				energy = energy - lattice(i, j)*lattice(inew, jnew)
			end do
		end do
	end do
	energy = energy/2
	write (10, *) 'final energy (calc) : ', energy
	write (10, *) 'final magnetization (calc) : ', magnet
    close (10)
	stop
end program ising