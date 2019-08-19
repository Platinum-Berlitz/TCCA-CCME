! gfortran 3_2.f90 -o 3_2 && ./3_2
program harmonic
	implicit none
    ! input parameter
    integer :: i, j
    integer, parameter :: n = 10, ncycle = 10000000, etot = 100, ninit = ncycle/2
    real*8, parameter :: beta = 0.09531
    ! other variables
    integer :: av1 = 0, av2 = 0
	integer :: e, dist(0:etot)
    real :: r1, r2

	open (21, file = '3_2.dat')
    do i = 1, ncycle
        call random_number(r1)
        call random_number(r2)
        if (e == 0) then
            if (r1 > 5d-1 .and. r2 < exp(-beta)) e = 1
        else
            if (r1 > 5d-1) then
                if (r2 < exp(-beta)) e = e + 1
            else
                e = e - 1
            end if
        end if
        ! sample
        if (i >= ninit) then
            dist(e) = dist(e) + 1
            av1 = av1 + e
            av2 = av2 + 1
        end if
    end do

    ! write results
    write (21, *) 'final energy: ', e
    write (21, *) 'average energy level: ', real(av1, 8) / av2
    write (21, *) 'energy distribution: '
    do i = 0, 20
        write (21, *) i, real(dist(i), 8) / (ncycle - ninit)
    end do
	close (21)
	stop
end program