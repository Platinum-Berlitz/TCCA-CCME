! gfortran 3_1.f90 -o 3_1 && ./3_1
program harmonic_nve
	implicit none
    ! input parameter
    integer :: i, j
    integer, parameter :: n_(10) = (/(i*3, i = 1, 10)/), ncycle = 100000000, etot_per = 10, ninit = ncycle/2
    ! other variables
    integer :: particle = 0, first_pos, second_pos, total, first_redist, av1 = 0, av2 = 0, etot, n
	integer, allocatable :: e(:), dist(:)
    real :: first, second, redist

	open (21, file = '3_1.dat')

    do j = 1, 10
        n = n_(j)
        etot = etot_per*n
        allocate(e(n), dist(0:etot))
        dist = 0
        e = 0
	    write (21, *) 'initial energy : ', etot
        ! 将初始能量平均分布
        do i = 1, etot
            particle = mod(i, n) + 1
            e(particle) = e(particle) + 1
        end do
        do i = 1, ncycle
            call random_number(first)
            call random_number(second)
            call random_number(redist)
            first_pos = 1 + int(n * first)
            second_pos = 1 + int(n * second)
            if (first_pos /= second_pos) then
                total = e(first_pos) + e(second_pos)
                first_redist = int(redist * (total + 1))
                e(first_pos) = first_redist
                e(second_pos) = total - first_redist
            end if
            ! sample
            if (i >= ninit) then
                dist(e(1)) = dist(e(1)) + 1
                av1 = av1 + e(1)
                av2 = av2 + 1
            end if
        end do

        ! write results
        write (21, *) 'final energy: ', sum(e)
        write (21, *) 'average energy level: ', real(av1, 8) / av2
        write (21, *) 'energy distribution: '
        do i = 0, 20
            write (21, *) i, real(dist(i), 8) / (ncycle - ninit)
        end do
        deallocate(e, dist)
    end do
	close (21)
	stop
end program