program project1_1
	real*8, parameter :: binary = 2.0 ! 定义进制
	real*8, parameter :: max = binary ** 1024 ! 规格数上限
	real*8, parameter :: min = binary ** (-1022) ! 规格数下限
	integer :: code(64) = 0 ! 用数组存编码
	real*8 a, a_original ! 待转换的数
	integer i
	integer :: exponent = 1023 ! 指数偏移值

	open (10, file = '1_1_input.txt')
	open (11, file = '1_1_output.txt')
	do while (.true.)
		code = 0
		exponent = 1023
		! a_original 用来保存原始的数
		read (10, *, iostat = i) a_original
		if (i < 0) exit
		if (i > 0) then
			code = 1
			write (*, *) '非数字对应的二进制编码为：'
			write (*, '(64I1)') code
			write (11, '(64I1)') code
			cycle
		end if
		! 处理符号
		if (a_original < 0) code(1) = 1
		! 从这里开始，a 用来进行各种操作
		a = abs(a_original)
		! 处理非规约数
		! 第一种情况：如果绝对值上溢，则设为无穷大
		if (a == max) then
			code(2:12) = 1
			write (*, *) a_original, '对应的二进制编码为：'
			write (*, '(64I1)') code
			write (11, '(64I1)') code
			cycle
		end if
		! 第二种情况：如果低于最小规约数，乘以一个因子后作规约数处理
		if (a < min) then
			a = a * 2**1022
		! 处理规约数
		else
			! 正常数的指数部分，大数除 2，小数乘 2
			do while (a >= 2)
				a = a / 2.0
				exponent = exponent + 1
			end do
			do while (a < 1)
				a = a * 2.0
				exponent = exponent - 1
			end do
			! 得到指数，将十进制转化为二进制
			do i = 12, 2, -1
				code(i) = mod(exponent, 2)
				exponent = exponent / 2
			end do
			! 小数部分需要减去 1
			a = a - 1
		end if
		! 处理小数，每一步乘 2，如果大于 1 则二进制位为 1，否则为 0
		do i = 13, 64
			a = a * 2
			code(i) = int(a)
			if (a >= 1) a = a - 1
		end do
		write (*, *) a_original, '对应的二进制编码为：'
		write (*, '(64I1)') code
		write (11, '(64I1)') code
	end do
	write (*, *) '编码结果已经保存到 1_1_output.txt'
end program