program project3
	real*8, parameter :: ta = 1, tb = 10, dt(3) = (/0.05, 0.1, 0.2/)
	real*8, allocatable :: na(:), nb(:), na_(:), nb_(:)
	integer i, j, N

	open (11, file = '3_output.txt')
	do j=1, 3
		t = dt(j)
		N = nint(4*tb/t)
		allocate(na(N), nb(N), na_(N), nb_(N))
		na(0)=1
		nb(0)=1
		forall (i=0:N) na_(i) = exp(-i*t/ta)
		do i=0, N-1
			na(i+1) = na(i)*(2*ta-t)/(2*ta+t)
		end do
		if (ta == tb) then
			forall (i=0:N) nb_(i) = exp(-i*t/ta)*(1+i*t/ta)
		else
			forall (i=0:N) nb_(i) = (exp(-i*t/ta)*tb+exp(-i*t/tb)*(ta-2*tb))/(ta-tb)
		end if
		do i=0, N-1
			nb(i+1) = nb(i)*(2*tb-t)/(2*tb+t)+tb/ta*t/(2*tb+t)*(na(i+1)+na(i))
		end do
		write (*, *) '取时间步长为', t, ' s 时：'
		write (*, *) 'A 的最大绝对误差为：', maxval(abs(na-na_))
		write (*, *) 'B 的最大绝对误差为：', maxval(abs(nb-nb_))
		write (11, *) '时间步长为', t, '时，A 的数值解：'
		write (11, *) na
		write (11, *) '时间步长为', t, '时，A 的解析解：'
		write (11, *) na_
		write (11, *) '时间步长为', t, '时，B 的数值解：'
		write (11, *) nb
		write (11, *) '时间步长为', t, '时，B 的解析解：'
		write (11, *) nb_
		deallocate(na, nb, na_, nb_)
	end do
	write (*, *) '计算结果已经保存到 3_output.txt'
end program