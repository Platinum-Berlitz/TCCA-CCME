include 'Functions.f90'

program project2_1
	use Functions
	implicit none
	! 进行初始猜测
	complex*8 :: guess(6) = &
	(/(0,100), (100,100), (200,100), &
	(400,100), (600,100), (700,100)/)
	complex*8 solution(6)

	open(10, file = '2_1_output.txt')
	call Muller(1.0D0, guess, solution)
	write(10, *) solution
end program