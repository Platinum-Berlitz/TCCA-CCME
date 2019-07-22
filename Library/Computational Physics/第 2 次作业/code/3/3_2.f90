program project3_2
	real*8 step(50), r ! 利用数组存储随机数
	integer :: x = 0, y = 0

	open(10, file = '3_2_output.txt')
	call random_seed()
	do i = 1, size(step)
		call random_number(step(i))
		! 判断随机数落入的子区间
		if (step(i) > 0.75) then
			x = x + 1
		else if (step(i) > 0.50) then
			x = x - 1
		else if (step(i) > 0.25) then
			y = y + 1
		else
			y = y - 1
		end if
		write(10, *) '第', i, '步游走后坐标 x = ', x, 'y = '&
		, y, '位移 r = ', sqrt(real(x)**2+real(y)**2)
	end do
end program