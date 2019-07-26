module mdlib

! fxx/fyy/fzz : forces
! rxx/ryy/rzz : positions
! rxf/ryf/rzf : old positions
! mxx/myy/mzz : positions that are not put back in the box
! vxx/vyy/vzz : velocities
! box : boxlengths
! hbox : half of the box-length
! tstep : timestep
! tstep2 : tstep*tstep
! i2tstep : 1/(2*tstep)
! nstep : number of integration steps
! ninit : number of initialization steps
! npart : number of particles
!
! ukin : kinetic energy
! upot : potential energy
! utot : total energy
! temp : temperature
! press : pressure
!
! rcutsq : cut-off radius
! ecut : cut-off energy

real*8, parameter :: tstep = 5d-4, tstep2 = tstep**2, i2tstep = 0.5d0/tstep, box = 5d0, hbox = box/2
real*8, parameter :: rcutsq = (0.49999d0*box)**2, ecut = 4.0d0*((rcutsq**(-6.0d0))-(rcutsq**(-3.0d0))), temp = 1.5d0
integer, parameter :: nstep = 5000, npart = 100, ninit = 500
real*8 :: fxx(npart), fyy(npart), fzz(npart), rxx(npart), ryy(npart), rzz(npart), rxf(npart), ryf(npart), rzf(npart)
real*8 :: vxx(npart), vyy(npart), vzz(npart), mxx(npart), myy(npart), mzz(npart), ukin, upot, utot, press

contains

subroutine integrate(step, impx, impy, impz)
	implicit none
    ! integrate the equations of motion and calculate the total impulse
	integer i, step
	real*8 xxx(npart), yyy(npart), zzz(npart), scale, impx, impy, impz
    ! set kinetic energy to zero
    ! verlet integrator

    ! xxx/yyy/zzz = new position (t + delta t)
    ! rxx/ryy/rzz = position (t	)
    ! rxf/ryf/rzf = old position (t - delta t)
    ! vxx/vyy/vzz = velocity (t	)
	ukin = 0.0d0
	do i = 1, npart
		xxx(i) = 2.0d0*rxx(i) - rxf(i) + fxx(i)*tstep2
		yyy(i) = 2.0d0*ryy(i) - ryf(i) + fyy(i)*tstep2
		zzz(i) = 2.0d0*rzz(i) - rzf(i) + fzz(i)*tstep2
		vxx(i) = (xxx(i)-rxf(i))*i2tstep
		vyy(i) = (yyy(i)-ryf(i))*i2tstep
		vzz(i) = (zzz(i)-rzf(i))*i2tstep
		ukin = ukin + 0.5d0*(vxx(i)*vxx(i)+vyy(i)*vyy(i)+vzz(i)*vzz(i))
	end do
    ! for nstep < ninit; use the velocity scaling to get the exact temperature
	! otherwise: scale = 1. beware that the positions/velocities have to be recalculated !!!!	
	if (step <= ninit) then
		scale = sqrt(temp * (3*npart-3) / (2d0*ukin))
	else
		scale = 1.0d0
	end if
	ukin = 0.0d0
	impx = 0.0d0
	impy = 0.0d0
	impz = 0.0d0
	! scale velocities and put particles back in the box	
	! beware: the old positions are also put back in the box
	do i = 1, npart
		vxx(i) = scale*vxx(i)
		vyy(i) = scale*vyy(i)
		vzz(i) = scale*vzz(i)
		impx = impx + vxx(i)
		impy = impy + vyy(i)
		impz = impz + vzz(i)
		xxx(i) = rxf(i) + 2d0*vxx(i)*tstep
		! 更改第一个错误：vzz -> vyy
		yyy(i) = ryf(i) + 2d0*vyy(i)*tstep
		zzz(i) = rzf(i) + 2d0*vzz(i)*tstep
		mxx(i) = mxx(i) + xxx(i) - rxx(i)
		myy(i) = myy(i) + yyy(i) - ryy(i)
		mzz(i) = mzz(i) + zzz(i) - rzz(i)
		! 更改第二个错误：0.5*
		ukin = ukin + 0.5d0*(vxx(i)*vxx(i) + vyy(i)*vyy(i) + vzz(i)*vzz(i))
		rxf(i) = rxx(i)
		ryf(i) = ryy(i)
		rzf(i) = rzz(i)
		rxx(i) = xxx(i)
		ryy(i) = yyy(i)
		rzz(i) = zzz(i)
		! put particles back in the box
		! the previous position has the same transformation (why ??)
		if (rxx(i)>box) then
			rxx(i) = rxx(i) - box
			rxf(i) = rxf(i) - box
		else if (rxx(i)<0.0d0) then
			rxx(i) = rxx(i) + box
			rxf(i) = rxf(i) + box
		end if
		if (ryy(i)>box) then
			ryy(i) = ryy(i) - box
			ryf(i) = ryf(i) - box
		else if (ryy(i)<0.0d0) then
			ryy(i) = ryy(i) + box
			ryf(i) = ryf(i) + box
		end if
		if (rzz(i)>box) then
			rzz(i) = rzz(i) - box
			rzf(i) = rzf(i) - box
		else if (rzz(i)<0.0d0) then
			rzz(i) = rzz(i) + box
			rzf(i) = rzf(i) + box
		end if
	end do
	! add the kinetic part of the pressure
	press = press + 2.0d0*ukin*npart/(box**3*(3*npart-3))
	return
end subroutine integrate

subroutine mdloop
	implicit none
	integer i
	real*8 :: av(6) = 0d0, impx, impy, impz, tempz, uzero, drift = 0d0

    ! ! initialize radial distribution function
	call sample_gyra(1)
    ! ! initialize diffusion coefficient
	call sample_diff(1)
    ! loop over all cycles
	do i = 1, nstep
    ! calculate the force
		call force
        ! integrate the equations of motion
		call integrate(i, impx, impy, impz)
		if (i==1) then
			! write (10, *) 'impulse x-dir.				: ', impx
			! write (10, *) 'impulse y-dir.				: ', impy
			! write (10, *) 'impulse z-dir.				: ', impz
			write (10, *) 'step	utot	ukin	upot	temp	press'
			write (10, *)
		end if
		utot = ukin + upot
		if (i == ninit + 1) uzero = utot
		tempz = 2d0 * ukin / (3*npart-3)
		if (i>ninit .and. mod(i,50)==0) write (10, '(i5,8(1x,f12.5))') i, utot, ukin, upot, tempz, press
		! if (i==nstep) then
		! 	write (10, *)
		! 	write (10, *) 'impulse x-dir.: ', impx
		! 	write (10, *) 'impulse y-dir.: ', impy
		! 	write (10, *) 'impulse z-dir.: ', impz
		! 	write (10, *)
		! end if
        ! calculate averages
		if (i>ninit) then
			av(1) = av(1) + tempz
			av(2) = av(2) + press
			av(3) = av(3) + ukin
			av(4) = av(4) + upot
			av(5) = av(5) + utot
			av(6) = av(6) + 1.0d0
			drift = drift + abs((utot - uzero) / uzero)
            ! sample radial distribution function
			if (mod(i,100)==0) call sample_gyra(2)
			call sample_diff(2)
		end if
	end do
    ! print averages to screen
	do i = 1, 5
		av(i) = av(i)/av(6)
	end do
	write (10, *)
	write (10, *) 'average temperature : ', av(1)
	write (10, *) 'average pressure	: ', av(2)
	write (10, *) 'average ukin	: ', av(3)
	write (10, *) 'average upot	: ', av(4)
	write (10, *) 'average utot	: ', av(5)
	write (10, *) 'average drift : ', drift / av(6)
	call sample_gyra(3)
	call sample_diff(3)
	return
end subroutine mdloop

function rangauss()
	implicit none
    ! generates random numbers from a gaussian distribution
	real*8 rangauss, r1, r2, rsq

    do while (.true.)
        call random_number(r1)
        r1 = 2 * r1 - 1.0d0
        call random_number(r2)
        r2 = 2 * r2 - 1.0d0
	    rsq = r1**2 + r2**2
	    if (rsq < 1d0) exit
    end do
	rangauss = r1 * sqrt(-2d0*log(rsq)/rsq)
	return
end function rangauss

function ran_uniform()
    implicit none
    real*8 ran_uniform

    call random_number(ran_uniform)
end function ran_uniform

subroutine sample_diff(switch)
	implicit none
	! tmax	= maximum timesteps for the correlation time
	! t0max = maximum number of time origins
	integer tmax, t0max
	parameter (tmax=1000)
	parameter (t0max=200)
	integer ttel, tt0(t0max), t0, switch, i, t, tvacf, dt
	real*8 vxt0(npart, t0max), vyt0(npart, t0max), vzt0(npart, t0max), vacf(tmax), r2t(tmax)
    real*8 rx0(npart, t0max), ry0(npart, t0max), rz0(npart, t0max), nvacf(tmax), intt, dtime
	save vacf, nvacf, vxt0, vyt0, vzt0, tvacf, r2t, rx0, ry0, rz0, tt0, t0
	if (switch==1) then
		! initialize everything
		tvacf = 0
		t0 = 0
		do i = 1, tmax
			r2t(i) = 0.0d0
			nvacf(i) = 0.0d0
			vacf(i) = 0.0d0
		end do
	else if (switch==2) then
		tvacf = tvacf + 1
		if (mod(tvacf,50)==0) then
		! new time origin
		! store the positions/velocities; the current velocities are vxx(i) and the current positions are mxx(i).	
		! question: why do you have to be careful with pbc ?
		! make sure to study algorithm 8 (page 82) of frenkel/smit
		! before you start to make modifications, note that most variable names are different here then in frenkel/smit. in this way, you will have to think more...
		! start modification
			t0 = t0 + 1
			ttel = mod(t0-1, t0max) + 1
			tt0(ttel) = tvacf
			do i = 1, npart
				vxt0(i, ttel) = vxx(i)
				vyt0(i, ttel) = vyy(i)
				vzt0(i, ttel) = vzz(i)
				rx0(i, ttel) = mxx(i)
				ry0(i, ttel) = myy(i)
				rz0(i, ttel) = mzz(i)
			end do
		! end modification
		end if
		! loop over all time origins that have been stored
		! start modification
		do t = 1, min(t0, t0max)
			dt = tvacf - tt0(t) + 1
			if (dt < tmax) then
				nvacf(dt) = nvacf(dt) + 1
				! print *, r2t(dt)
				do i = 1, npart
					vacf(dt) = vacf(dt) + vxx(i) * vxt0(i, t) + vyy(i) * vyt0(i, t) + vzz(i) * vzt0(i, t)
					r2t(dt) = r2t(dt) + (mxx(i) - rx0(i, t))**2 + (myy(i) - ry0(i, t))**2 + (mzz(i) - rz0(i, t))**2
				end do
				! print *, r2t(dt), dt, mxx(39), rx0(39, t)
			end if
		end do
		! end modification
	else
		! write everything to disk
		intt = 0.0d0
		do i = 1, tmax - 1
			dtime = dble(i-1)*tstep
			if (nvacf(i)>=0.5d0) then
				vacf(i) = vacf(i)/(dble(npart)*nvacf(i))
				r2t(i) = r2t(i)/(dble(npart)*nvacf(i))
			else
				vacf(i) = 0.0d0
				r2t(i) = 0.0d0
			end if
			intt = intt + tstep*vacf(i)/3.0d0
			write (12, '(3f15.10)') dtime, vacf(i), intt
			if (i /= 1) then
				write (11, '(3f15.10)') dtime, r2t(i), r2t(i)/(6.0d0*dtime)
			else
				write (11, '(3f15.10)') dtime, r2t(i), 0d0
			end if
		end do
	end if
	return
end subroutine sample_diff

subroutine sample_gyra(ichoise)
	implicit none
	! samples the radial distribution function	 c
	integer i, j, maxx, ichoise, a
	parameter (maxx=500)
	real*8 ggt, gg(maxx), delta, r2, dx, dy, dz, intt, g, rsamp
	save ggt, gg, delta
	if (ichoise==1) then
		do i = 1, maxx
			gg(i) = 0.0d0
		end do
		ggt = 0.0d0
		delta = dble(maxx-1)/hbox
	else if (ichoise==2) then
		ggt = ggt + 1.0d0
		! loop over all pairs
		do i = 1, npart - 1
			do j = i + 1, npart
				dx = rxx(i) - rxx(j)
				dy = ryy(i) - ryy(j)
				dz = rzz(i) - rzz(j)
				if (dx>hbox) then
					dx = dx - box
				else if (dx<-hbox) then
					dx = dx + box
				end if
				if (dy>hbox) then
					dy = dy - box
				else if (dy<-hbox) then
					dy = dy + box
				end if
				if (dz>hbox) then
					dz = dz - box
				else if (dz<-hbox) then
					dz = dz + box
				end if
				r2 = dsqrt(dx*dx+dy*dy+dz*dz)
				! calculate in which bin this interaction is in
				! delta = 1/binsize
				! maxx	= number of bins
				if (r2<hbox) then
					a = idint(r2*delta) + 1
					gg(a) = gg(a) + 2.0d0
				end if
			end do
		end do
	else
		! write results to disk
		ggt = 1.0d0/(ggt*dble(npart))
		delta = 1.0d0/delta
		intt = 0d0
		do i = 1, maxx - 1
			r2 = (16.0d0*datan(1.0d0)/3.0d0)*(dble(npart)/(box**3))*(delta**3)*((dble(i+1))**3-(dble(i)**3))
			rsamp = ((dble(i)-0.5d0)*delta)
			g = gg(i)*ggt/r2
			intt = intt + delta * g * rsamp**2 * 4 * (rsamp **(-12) - rsamp **(-6))
			write (13, '(3f15.10)') rsamp, gg(i)*ggt/r2, intt
		end do
		write (13, *) 'total energy', 8*atan(1d0)*npart**2/box**3*intt
	end if
	return
end subroutine sample_gyra

subroutine force
    implicit none
	! calculate the forces and potential energy
    integer i, j
    real*8 dx, dy, dz, ff, r2i, r6i
	! set forces, potential energy and pressure to zero
    
	fxx = 0d0
	fyy = 0d0
	fzz = 0d0
    upot = 0d0
    press = 0d0
	! loop over all particle pairs
    do i = 1, npart - 1
        do j = i + 1, npart
			! calculate distance and perform periodic
			! boundary conditions
            dx = rxx(i) - rxx(j)
            dy = ryy(i) - ryy(j)
            dz = rzz(i) - rzz(j)
            if (dx>hbox) then
                dx = dx - box
            else if (dx<-hbox) then
                dx = dx + box
            end if
            if (dy>hbox) then
                dy = dy - box
            else if (dy<-hbox) then
                dy = dy + box
            end if
            if (dz>hbox) then
                dz = dz - box
            else if (dz<-hbox) then
                dz = dz + box
            end if
            r2i = (dx*dx + dy*dy + dz*dz)
			! check if the distance is within the cutoff radius
            if (r2i < rcutsq) then
                r2i = 1.0d0/r2i
                r6i = r2i*r2i*r2i
                upot = upot + 4.0d0*r6i*(r6i-1.0d0) - ecut
                ff = 48.0d0*r6i*(r6i-0.5d0)
                press = press + ff
                ff = ff*r2i
				! 更改：不知道这里在干什么，应该是 + 吧
                fxx(i) = fxx(i) + ff*dx
                fyy(i) = fyy(i) + ff*dy
                fzz(i) = fzz(i) + ff*dz
                fxx(j) = fxx(j) - ff*dx
                fyy(j) = fyy(j) - ff*dy
                fzz(j) = fzz(j) - ff*dz
            end if
        end do
    end do
	! scale the pressure
    press = press/(3d0*box**3)
    return
end subroutine force

subroutine init
    implicit none
    ! generates initial positions/velocities
    ! this is not to easy; do not look for errors here !!!!
    integer i, j, k, number, nplace
    real*8 fxo(npart), fyo(npart), fzo(npart), uold, testje, place, size, impx, impy, impz
    ! generate velocities from a gaussian; set impulse to zero
    impx = 0.0d0
    impy = 0.0d0
    impz = 0.0d0
    ukin = 0.0d0
    do i = 1, npart
        vxx(i) = rangauss()
        vyy(i) = rangauss()
        vzz(i) = rangauss()
        impx = impx + vxx(i)
        impy = impy + vyy(i)
        impz = impz + vzz(i)
    end do
    impx = impx / dble(npart)
    impy = impy / dble(npart)
    impz = impz / dble(npart)
    ! calculate the kinetic energy ukin
    do i = 1, npart
        vxx(i) = vxx(i) - impx
        vyy(i) = vyy(i) - impy
        vzz(i) = vzz(i) - impz
        ukin = ukin + 5d-1*(vxx(i)*vxx(i) + vyy(i)*vyy(i) + vzz(i)*vzz(i))
    end do
    ! scale all velocities to the correct temperature
    testje = sqrt(temp*dble(3*npart-3)/(2d0*ukin))
    do i = 1, npart
        vxx(i) = testje*vxx(i)
        vyy(i) = testje*vyy(i)
        vzz(i) = testje*vzz(i)
    end do
    ! calculate initial positions on a lattice
    number = int((dble(npart)**(1.0d0/3.0d0))+1.5d0)
    nplace = 0
    size = box/dble(number+2)
    place = 0.2d0*size
    do i = 1, number
        do j = 1, number
            do k = 1, number
                nplace = nplace + 1
                if (nplace<=npart) then
                    rxx(nplace) = (dble(i)+0.01d0*(ran_uniform()-0.5d0))*size
                    ryy(nplace) = (dble(j)+0.01d0*(ran_uniform()-0.5d0))*size
                    rzz(nplace) = (dble(k)+0.01d0*(ran_uniform()-0.5d0))*size
                end if
            end do
        end do
    end do
    ! calculate better positions using a steepest decent algorithm
    do j = 1, 50
        if (j==1) then
            call force
            uold = upot
            write (10, *) 'initial potential energy	: ', uold
        end if
        testje = 0.0d0
        ! calculate maximum downhill gradient
        do i = 1, npart
            rxf(i) = rxx(i)
            ryf(i) = ryy(i)
            rzf(i) = rzz(i)
            fxo(i) = fxx(i)
            fyo(i) = fyy(i)
            fzo(i) = fzz(i)
            impx = abs(fxx(i))
            impy = abs(fyy(i))
            impz = abs(fzz(i))
            if (impx>testje) testje = impx
            if (impy>testje) testje = impy
            if (impz>testje) testje = impz
        end do
        testje = place/testje
        ! calculate improved positions
        do i = 1, npart
            rxx(i) = rxx(i) + testje*fxx(i)
            ryy(i) = ryy(i) + testje*fyy(i)
            rzz(i) = rzz(i) + testje*fzz(i)
            ! place particles back in the box
            if (rxx(i)>box) then
                rxx(i) = rxx(i) - box
            else if (rxx(i)<0.0d0) then
                rxx(i) = rxx(i) + box
            end if
            if (ryy(i)>box) then
                ryy(i) = ryy(i) - box
            else if (ryy(i)<0.0d0) then
                ryy(i) = ryy(i) + box
            end if
            if (rzz(i)>box) then
                rzz(i) = rzz(i) - box
            else if (rzz(i)<0.0d0) then
                rzz(i) = rzz(i) + box
            end if
        end do
        ! calculate new potential energy
        call force
        ! check if the new positions are acceptable
        if (upot<uold) then
            uold = upot
            place = place*1.2d0
            if (place>hbox) place = hbox
        else
            do i = 1, npart
                fxx(i) = fxo(i)
                fyy(i) = fyo(i)
                fzz(i) = fzo(i)
                rxx(i) = rxf(i)
                ryy(i) = ryf(i)
                rzz(i) = rzf(i)
            end do
            place = place*0.1d0
        end if
    end do
    ! calculate previous position using the generated velocity
    do i = 1, npart
        rxf(i) = rxx(i) - tstep*vxx(i)
        ryf(i) = ryy(i) - tstep*vyy(i)
        rzf(i) = rzz(i) - tstep*vzz(i)
        mxx(i) = rxx(i)
        myy(i) = ryy(i)
        mzz(i) = rzz(i)
    end do
    write (10, *) 'final potential energy : ', uold
    return
end subroutine init
end module

program md
    use mdlib
    ! gfortran 10_4.f90 -o 10_4 && ./10_4
	implicit none
    ! molecular dynamics program of argon

    call random_seed()
    open (10, file = '10_4.dat')
	open (11, file = '10_4_r2t.dat')
	open (12, file = '10_4_vacf.dat')
	open (13, file = '10_4_gyra.dat')
	call init()
	call mdloop()
    close (10)
    close (11)
    close (12)
    close (13)
	stop
end program md