program mcnpt ! npt simulation of hard-spheres
    ! gfortran 11_1.f90 -o 11_1 && ./11_1
	implicit none
	integer, parameter :: nstep = 2e5, ninit = 1e4, npart = 400
    integer :: i, j, k, c, count, ipart
	logical lready
	real*8 :: x(npart), y(npart), z(npart), xold(npart), yold(npart), zold(npart)
	real*8 :: r2, att1, att2, xn, yn, zn, dispmax = 1d0, dvol = 1d-2, avv1, avv2, press = 1d0
    real*8 :: vnew, vold, iboxold, boxold, box = 1d1, ibox = 1d-1, dx, dy, dz, mvo1, mvo2, r1

    call random_seed()
	open (10, file = '11_1.dat')
    ! initialize 
	att1 = 0.0d0
	att2 = 0.0d0
	avv1 = 0.0d0
	avv2 = 0.0d0
	mvo1 = 0.0d0
	mvo2 = 0.0d0
	count = 0
    ! put particles on a lattice, so that number of particles always have to be smaller than 729
	do i = 1, 9
		do j = 1, 9
			do k = 1, 9
				count = count + 1
				if (count <= npart) then
					x(count) = dble(i)*1.1d0
					y(count) = dble(j)*1.1d0
					z(count) = dble(k)*1.1d0
				end if
			end do
		end do
	end do
    ! start of the simulation
	do c = 1, nstep
		! select particle and move at random
		call random_number(r1)
		ipart = 1 + int(r1 * (npart+1))
		if (ipart == npart + 1) then
			! volume change
			! random walk in ln(v)
			avv1 = avv1 + 1.0d0
			vold = box ** 3
			lready = .false.
			call random_number(r1)
			vnew = exp(log(vold)+(r1-0.5d0)*dvol)
			boxold = box
			iboxold = ibox
			box = vnew**(1.0d0/3.0d0)
			ibox = 1.0d0/box
			! transform coordinates	 c
			xold = x
			yold = y
			zold = z
			x = x * box * iboxold
			y = y * box * iboxold
			z = z * box * iboxold
			! check for overlaps
			do i = 1, npart - 1
				do j = i + 1, npart
					dx = x(i) - x(j)
					dy = y(i) - y(j)
					dz = z(i) - z(j)
					! nearest image
					dx = dx - box * (int(dx*ibox+9999.5d0)-9999)
					dy = dy - box * (int(dy*ibox+9999.5d0)-9999)
					dz = dz - box * (int(dz*ibox+9999.5d0)-9999)
					r2 = dx**2 + dy**2 + dz**2
					if (r2 < 1d0) goto 110
				end do
			end do
			! no overlap... use acceptance rule
			call random_number(r1)
			if (r1<exp(-press*(vnew-vold)+log(vnew/vold)*dble(npart+1))) lready = .true.
			110 if (lready) then
				! accepted !!!
				avv2 = avv2 + 1.0d0
			else
				! rejected !!!
				! restore coordinates
				x = xold
				y = yold
				z = zold
				box = boxold
				ibox = iboxold
			end if
		else
			! displacement
			att1 = att1 + 1.0d0
			call random_number(r1)
			xn = x(ipart) + (r1-0.5d0)*dispmax
			call random_number(r1)
			yn = y(ipart) + (r1-0.5d0)*dispmax
			call random_number(r1)
			zn = z(ipart) + (r1-0.5d0)*dispmax
			! put particle back in the box	 c
			xn = xn - box*(dble(int(xn*ibox+9999.0d0)-9999))
			yn = yn - box*(dble(int(yn*ibox+9999.0d0)-9999))
			zn = zn - box*(dble(int(zn*ibox+9999.0d0)-9999))
			! see if there is an overlap with any other particle
			do i = 1, npart
				if (i /= ipart) then
					! nearest image
					dx = xn - x(i)
					dy = yn - y(i)
					dz = zn - z(i)
					dx = dx - box*dble(int(dx*ibox+9999.5d0)-9999)
					dy = dy - box*dble(int(dy*ibox+9999.5d0)-9999)
					dz = dz - box*dble(int(dz*ibox+9999.5d0)-9999)
					r2 = dx**2 + dy**2 + dz**2
					if (r2<1.0d0) goto 111
				end if
			end do
			! no overlaps, so accepted	 c
			att2 = att2 + 1.0d0
			x(ipart) = xn
			y(ipart) = yn
			z(ipart) = zn
		111 end if
        ! make a movie file			 c
        ! print current volume		c
		! if (mod(iii,10)==0) then
		! 	write (10, *) 'volume / box						 : ', box**3, box
		! end if
        ! sample volume		c
		if (c > ninit) then
			mvo1 = mvo1 + 1.0d0
			mvo2 = mvo2 + (box**3)
		end if
	end do
    ! print results	 c
	write (10, *) 'fraction success (displ.) : ', att2/att1
	write (10, *) 'fraction success (volume) : ', avv2/avv1
	write (10, *) 'average volume : ', mvo2/mvo1
	write (10, *) 'average density : ', npart/(mvo2/mvo1)
	close (10)
	stop
end program mcnpt