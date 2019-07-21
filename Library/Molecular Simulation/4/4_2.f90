! gfortran 4_2.f90 -o 4_2 && ./4_2
program random1d
	implicit none
    ! random walk 1d
	! input parameters
    integer, parameter :: njump = 100, ncycle = 10000
	real, parameter :: pi = 4d0*atan(1d0)
	! other variables
    integer :: i, j, k
	integer :: x, dist(-njump:njump) = 0
	integer :: t, dt, trace(0:njump) = 0, r2(njump) = 0
    real :: r, p1, p2

    ! loop over cycles
	open (21, file='4_2.dat')
	do i = 1, ncycle
        x = 0
        ! perform the random walk
        ! go up or down with prob.0.5
        do j = 1, njump
            call random_number(r)
            if (r < 0.8d0) then
                x = x + 1
            else
                x = x - 1
            end if
			trace(j) = x
			! loop over all time origins
			do t = 0, j - 1
				dt = j - t
				r2(dt) = r2(dt) + (x - trace(t))**2
			end do
        end do
        dist(x) = dist(x) + 1
	end do

    ! write results
	write (21, *) 'Mean-Squared Displacement: '
	do i = 1, njump
		write (21, *) i, real(r2(i), 8) / (njump + 1 - i) / ncycle
	end do
	write (21, *) 'Distribution: '
	do i = -njump, njump
		p1 = real(dist(i), 8) / ncycle
		p2 = sqrt(2d0/njump/pi) * exp(-i*i/2d0/njump)
		write (21, *) i, p1, p2
	end do
	close (21)
	stop
end program