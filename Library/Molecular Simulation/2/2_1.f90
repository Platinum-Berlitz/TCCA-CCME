! gfortran 2_1.f90 -o 2_1 && ./2_1
program boltzmann
    implicit none

    ! calculate the boltzmann distribution
    integer, parameter :: n = 100
    real, parameter :: temp = 10
    integer i
    real*8 :: distri(0:n) = 0, bolt, beta, q = 0

    if (n<2 .or. n>=10000 .or. temp<1.0d-7 .or. temp>1.0d7) stop
    beta = 1.0d0/temp

    ! loop over all levels

    do i = 0, n - 1
        bolt = exp(-beta*real(i, 8))
        q = q + bolt
        distri(i) = bolt
    end do

    ! write results
    distri = distri / q
    open (21, file='2_1.dat')
    do i = 0, (n-1)
        write (21, '(i8,f20.10)') i, distri(i)
    end do
    close (21)
    stop
end program