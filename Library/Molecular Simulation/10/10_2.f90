program test
    ! gfortran 10_2.f90 -o 10_2 && ./10_2
    implicit none
    integer, parameter :: N = 1e7
    real*8, parameter :: box = 5d0, hbox = box / 2, ibox = 1d0 / box
    integer :: i
    real*8 :: a, b, c, t1, t2

    call random_seed()
    call cpu_time(t1)
    do i = 1, N
        call random_number(a)
        call random_number(b)
        a = a * box
        b = b * box
        c = a - b
        ! 方法 1：流程控制法
        if (c > hbox) then
            c = c - box
        else if (c < -hbox) then
            c = c + box
        end if
    end do
    call cpu_time(t2)
    print *, '流程控制法用时：', t2 - t1
    call cpu_time(t1)
    do i = 1, N
        call random_number(a)
        call random_number(b)
        a = a * box
        b = b * box
        c = a - b
        ! 方法 2：nint 取整法
        c = c - box * nint(c * ibox)
    end do
    call cpu_time(t2)
    print *, 'nint 取整法用时：', t2 - t1
    call cpu_time(t1)
    do i = 1, N
        call random_number(a)
        call random_number(b)
        a = a * box
        b = b * box
        c = a - b
        ! 方法 3：int 取整法
        c = c - box * (int(c * ibox + 1.5) - 1)
    end do
    call cpu_time(t2)
    print *, 'int 取整法用时：', t2 - t1
    call cpu_time(t1)
    do i = 1, N
        call random_number(a)
        call random_number(b)
        a = a * box
        b = b * box
        c = a - b
        ! 方法 4：floor 取整法
        c = c - box * floor(c * ibox + 0.5)
    end do
    call cpu_time(t2)
    print *, 'floor 取整法用时：', t2 - t1

end program test