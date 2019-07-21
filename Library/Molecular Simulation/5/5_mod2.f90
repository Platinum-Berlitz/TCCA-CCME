! gfortran 5_mod2.f90 -o 5_mod2 && ./5_mod2
! 修改后：x 方向的 D 增加。
module random

integer, parameter :: njump = 100, nlattice = 32, npart = 20, maxlat = 65, maxpart = 2000
integer :: mxx(maxpart) = 0, myy(maxpart) = 0

contains

subroutine sample(switch)
	implicit none

    ! calculates mean square displacement				 
    ! tmax	= maximum timesteps for the correlation time 
    ! t0max = maximum number of time origins
	integer tmax, t0max
	parameter (tmax=5000)
	parameter (t0max=500)
	integer ttel, tt0(t0max), t0, switch, i, t, tvacf, dt, rx0(maxpart, t0max), ry0(maxpart, t0max)
	real*8 r2tx(tmax), r2ty(tmax), nvacf(tmax), dtime
	save nvacf, r2tx, r2ty, rx0, ry0, tt0, t0, tvacf

	if (switch==1) then
        ! initialize everything
		tvacf = 0
		t0 = 0
		do i = 1, tmax
			r2tx(i) = 0.0d0
			r2ty(i) = 0.0d0
			nvacf(i) = 0.0d0
		end do
	else if (switch==2) then
		tvacf = tvacf + 1
		if (mod(tvacf,50)==0) then
            ! new time origin
			t0 = t0 + 1
			ttel = mod(t0-1, t0max) + 1
			tt0(ttel) = tvacf
            ! store particle positions/velocities
			do i = 1, npart
				rx0(i, ttel) = mxx(i)
				ry0(i, ttel) = myy(i)
			end do
		end if
        ! loop over all time origins
		do t = 1, min(t0, t0max)
			dt = tvacf - tt0(t) + 1
			if (dt<tmax) then
				nvacf(dt) = nvacf(dt) + 1.0d0
				do i = 1, npart
					r2tx(dt) = r2tx(dt) + (dble(mxx(i)-rx0(i,t)))**2
					r2ty(dt) = r2ty(dt) + (dble(myy(i)-ry0(i,t)))**2
				end do
			end if
		end do
	else
        ! write everything to disk
		open (25, file='rms.dat')
		do i = 1, tmax - 1
			dtime = dble(i-1)
			if (nvacf(i)>=0.5d0) then
				r2tx(i) = r2tx(i)/nvacf(i)
				r2ty(i) = r2ty(i)/nvacf(i)
			else
				r2tx(i) = 0.0d0
				r2ty(i) = 0.0d0
			end if
			write (25, '(3e20.10)') dtime, r2tx(i), r2ty(i)
		end do
		close (25)
	end if
	return
end subroutine sample
end module

program random2d
    use random
	implicit none

	! random walk 2d
	integer :: lattice(maxlat,maxlat) = 0, xpart(maxpart) = 0, ypart(maxpart) = 0
	integer :: i, j, x, y, xup, yup, xnew, ynew, kkk, ninit = njump/4, kk
	real*8 :: m1, r1, av1 = 0d0, av2 = 0d0, rm

	! initialize rng
	call sample(1)

	! read input from disk
	if (nlattice<10 .or. nlattice>=maxlat .or. npart<1 .or. npart>=2000) stop

		open (21, file = '5.dat')
		! put particles random on the lattice
		! look for an empty lattice site	

	do j = 1, npart
		do while ( .true. )
			call random_number(r1)
			x = 1 + int(r1*dble(nlattice))
			call random_number(r1)
			y = 1 + int(r1*dble(nlattice))
			if (lattice(x, y) == 0) exit
		end do
		lattice(x, y) = j
		xpart(j) = x
		ypart(j) = y
		mxx(j) = x
		myy(j) = y
	end do

	! perform the random walk

	do kkk = 1, njump
		do kk = 1, 1000
			! choose a random site (j)
			! choose a random displacement (rm):
			! - up, down, left, right
			call random_number(r1)
			j = 1 + int(r1*dble(npart))
			call random_number(r1)
			rm = 4.0d0*r1
			if (rm<1.0d0) then
				xup = 1
				yup = 1
			else if (rm<2.0d0) then
				xup = -1
				yup = -1
			else if (rm<3.0d0) then
				xup = -1
				yup = 1
			else
				xup = 1
				yup = -1
			end if
			! new position
			! put particle back on the lattice
			xnew = xpart(j) + xup
			ynew = ypart(j) + yup

			! 将 x 改为反射性边界条件
			if (xnew<1) then
				xnew = 2 - xnew
			else if (xnew>nlattice) then
				xnew = 2 * nlattice - xnew
			end if

			if (ynew<1) then
				ynew = ynew + nlattice
			else if (ynew>nlattice) then
				ynew = ynew - nlattice
			end if
			av2 = av2 + 1.0d0
			! check if new lattice site is accepted
			if (lattice(xnew,ynew)==0) then
				lattice(xpart(j), ypart(j)) = 0
				xpart(j) = xnew
				ypart(j) = ynew
				lattice(xnew, ynew) = j
				mxx(j) = mxx(j) + xup
				myy(j) = myy(j) + yup
				av1 = av1 + 1.0d0
			end if
			if (kkk >= ninit) call sample(2)
		end do
	end do

	! write results
	call sample(3)

	write (21, *) 'fraction accepted jumps : ', av1/av2
	write (21, *) 'lattice occupation : ', dble(npart)/dble(nlattice*nlattice)
	close (21)
	stop
end program random2d