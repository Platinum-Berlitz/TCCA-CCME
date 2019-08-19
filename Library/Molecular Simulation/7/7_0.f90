! gfortran 7.f90 -o 7 && ./7
program photon
	implicit none
    integer, parameter :: nstep = 1000, ninit = 100
    real*8, parameter :: beta = 1d0
	integer :: new = 1, old = 1, i, j
	real*8 :: av1 = 0d0, av2 = 0d0, r1
	
    call random_seed()
    open (21, file = '7.dat')
    ! loop over all cycles	
    ! old = old position (integer !!)
    ! new = new position (integer !!)
	do i = 1, nstep
		do j = 1, 1000
            ! start modification
            ! end modification
            ! check for acceptance
            call random_number(r1)
			if (r1 < exp(-beta*(new - old))) old = new
            ! calculate average occupancy result
			if (i > ninit) then
				av1 = av1 + dble(old)
				av2 = av2 + 1.0d0
			end if
		end do
	end do
    ! write the final result	
	write (21, *) 'average value : ', av1/av2
	write (21, *) 'theoretical value : ', 1d0/(exp(beta)-1d0)
	write (21, *) 'ratio : ', abs((exp(beta)-1.0d0)*((av1/av2)-(1.0d0/(exp(beta)-1.0d0))))
	stop
end program photon