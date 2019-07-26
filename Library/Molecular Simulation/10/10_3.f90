program test
    ! gfortran 10_3.f90 -o 10_3 && ./10_3
    implicit none
    integer, parameter :: N = 1e7
    real*8, parameter :: box = 5d20, ibox = 1d0 / box
    integer :: i
    real*8 :: a, b, c, t1, t2

    ! 乘法
    call cpu_time(t1)
    do i = 1, N 
        a = 1d-1 / box
    end do
    call cpu_time(t2)
    print *, '用时', t2 - t1
    ! 除法
    call cpu_time(t1)
    do i = 1, N 
        a = 1d-1 * ibox
    end do
    call cpu_time(t2)
    print *, '用时', t2 - t1

end program test