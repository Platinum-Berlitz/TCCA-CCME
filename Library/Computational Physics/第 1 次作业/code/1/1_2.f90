program project1_2
	real*8, parameter :: binary = 2.0
	real*8 factor
	integer :: code(64) = 0
	real*8 a
	integer i
	integer :: sign = 1, exponent = -1023
	real*8 :: decimal = 1.0, unit = 1.0

	open (10, file = '1_2_input.txt')
	open (11, file = '1_2_output.txt')
	do while (.true.)
		code = 0
		sign = 1
		exponent = -1023
		decimal = 1.0
		unit = 1.0
		! a_original 用来保存原始的数
		read (10, '(64I1)', iostat = i) code
		if (i < 0) exit
		write (*, '(64I1)') code
		if (i > 0) then
			write (*, *) '不是有效的二进制编码'
			cycle
		end if
		! 非规约数，高位全为 1
		if (all(code(2:12) == 1)) then
			! 低位有 1，则不是数
			if (any(code(13:64) == 1)) then
				write(*, *) '对应的十进制数为：NaN'
			! 低位无 1，则为无穷大
			else
				if (code(1) == 0) then 
					write(*, *) '对应的十进制数为：+Infinity'
				else
					write(*, *) '对应的十进制数为：-Infinity'
				end if
			end if
			cycle
		end if
		! 处理符号
		if (code(1) == 1) sign = -1
		! 非规约数，高位全为 0
		if (all(code(2:12) == 0)) then
			decimal = 0.0
			exponent = -1022
		! 规约数
		else
			! 指数部分
			do i = 2, 12
				exponent = exponent + 2**(12 - i) * code(i)
			end do
		end if
		! 小数部分，每一步加上该位上的一个单位或不加
		do i = 13, 64
			unit = unit / 2.0
			decimal = decimal + unit * code(i)
		end do
		! 相乘
		factor = binary ** exponent
		a = sign * factor * decimal
		write (*, '(A30, E30.17E3)') '对应的十进制数为：', a
		write (11, *) a
	end do
	write (*, *) '计算结果已经保存到 1_2_output.txt'
end program