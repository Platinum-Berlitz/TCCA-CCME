module mc
		real*8 x(N), y(N), z(N)
		integer :: npart = 100
		! Common /Conf1/ X(Npmax),Y(Npmax),Z(Npmax),Npart
		real*8 Box,Temp = 2d0,Beta,Hbox
		! Common /Sys1/		Box,Hbox,Temp,Beta
		integer, parameter :: Npmax = 10000
		real*8 Eps4,Sig2,Mass = 1d0,Rc2,Eps48,Rc = 5d0
		! Common /Pot1/		Eps4,Eps48,Sig2,Mass,Rc,Rc2
		! Eps4			: 4 * Epsilon 
		! Eps48		 : 48 * Epsilon
		! (Epsilon) : Energy Parameter Lennard-Jones Potential
		! Sig2			: Sigma*Sigma
		! (Sigma)	 : Size Parameter Lennard-Jones Potenital
		! Mass			: Mass Of The Molecules
		! Rc				: Cut-Off Radius Of The Potenial
		! Rc2			 : Rc * Rc
contains

subroutine ener(en, vir, r2)
    ! calculate energy between a (single) pair of atoms
    ! en : (output) energy
    ! vir: (output) virial
    ! r2 : (input) distance squared between two particles
	implicit none
	real*8 r2, r2i, r6i, en = 0d0, vir = 0d0

	if (r2 < rc2) then
		r2i = sig2/r2
		r6i = r2i*r2i*r2i
		en = eps4*(r6i*r6i-r6i)
        vir = eps4*(12*r6i*r6i-6*r6i)
	end if
	return
end subroutine ener

subroutine eneri(xi, yi, zi, i, jb, en, vir)
    ! calculates the energy of particle i with particles j=jb,npart
    ! xi (input)		x coordinate particle i
    ! yi (input)		y coordinate particle i
    ! zi (input)		z coordinate particle i
    ! i	(input)		particle number (excluded !!!)
    ! en	(output)	energy particle i
    ! vir (output)	virial particle i

	implicit none
	! include 'parameter.inc'
	! include 'conf.inc'
	! include 'system.inc'
	real*8 xi, yi, zi, en, dx, dy, dz, r2, vir, virij, enij
	integer i, j, jb
	en = 0.0d0
	vir = 0.0d0
	do j = jb, npart
    ! excluse particle i
		if (j /= i) then
			dx = xi - x(j)
			dy = yi - y(j)
			dz = zi - z(j)
            ! nearest image convention
			if (dx > hbox) then
				dx = dx - box
			else if (dx < -hbox) then
				dx = dx + box
			end if
			if (dy > hbox) then
				dy = dy - box
			else if (dy < -hbox) then
				dy = dy + box
			end if
			if (dz > hbox) then
				dz = dz - box
			else if (dz < -hbox) then
				dz = dz + box
			end if
			r2 = dx*dx + dy*dy + dz*dz
            ! calculate the energy
			call ener(enij, virij, r2)
			en = en + enij
			vir = vir + virij
		end if
	end do
	return
end subroutine eneri

subroutine lattice
    ! place 'npart' particles on a simple cubic
    ! lattice with density 'rho'
	implicit none
	! include 'parameter.inc'
	! include 'conf.inc'
	! include 'system.inc'
	integer i, j, k, itel, n
	real*8 dx, dy, dz, del
	n = int(npart**(1d0/3)) + 1
	del = box / n
	itel = 0
	dx = -del
	do i = 1, n
		dx = dx + del
		dy = -del
		do j = 1, n
			dy = dy + del
			dz = -del
			do k = 1, n
				dz = dz + del
				if (itel < npart) then
					itel = itel + 1
					x(itel) = dx
					y(itel) = dy
					z(itel) = dz
				end if
			end do
		end do
	end do
	write (*, *) 'initialization on lattice: ', itel, 'particles placed on a lattice'
	return
end subroutine lattice

subroutine mcmove(en, vir, attempt, nacc, dr)
    ! attempts to displace a randomly selected particle
    ! ener (input/output) : total energy
    ! vir (input/output) : total virial
    ! attemp (input/output) : number of attemps that have been performed to displace a particle
    ! nacc	 (input/output) : number of successful attemps to displace a particle
    ! dr (input) : maximum displacement
	implicit none
	! include 'parameter.inc'
	! include 'conf.inc'
	! include 'system.inc'
	real*8 enn, eno, en, ran_uniform, xn, yn, zn, viro, virn, vir, dr, r1, r2, r3
	integer o, attempt, nacc, jb
	attempt = attempt + 1
	jb = 1
    ! select a particle at random
    call random_number(r1)
	o = int(npart * r1) + 1
    ! calculate energy old configuration
	call eneri(x(o), y(o), z(o), o, jb, eno, viro)
    ! give particle a random displacement
    call random_number(r1)
    call random_number(r2)
    call random_number(r3)
	xn = x(o) + (r1-0.5d0)*dr
	yn = y(o) + (r2-0.5d0)*dr
	zn = z(o) + (r3-0.5d0)*dr
    ! calculate energy new configuration:
	call eneri(xn, yn, zn, o, jb, enn, virn)
    ! acceptance test
    call random_number(r1)
	if (r1 < exp(-beta * (enn-eno))) then
        ! accepted
		nacc = nacc + 1
		en = en + (enn-eno)
		vir = vir + (virn-viro)
        ! put particle in simulation box
		if (xn < 0.0d0) then
			xn = xn + box
		else if (xn > box) then
			xn = xn - box
		end if
		if (yn < 0.0d0) then
			yn = yn + box
		else if (yn>box) then
			yn = yn - box
		end if
		if (zn<0.0d0) then
			zn = zn + box
		else if (zn>box) then
			zn = zn - box
		end if
		x(o) = xn
		y(o) = yn
		z(o) = zn
	end if
	return
end subroutine mcmove

subroutine readdat(equil, prod, nsamp, ndispl, dr)
	implicit none
    ! read input data and model parameters
    ! input parameters: file: fort.15
    ! ibeg	= 0 : initialize from a lattice
    !       = 1 : read configuration from disk
    ! equil	: number of monte carlo cycles during equilibration
    ! prod : number of monte carlo cycles during production
    ! nsamp	: number of monte carlo cycles between two sampling periods
    ! dr : maximum displacement
    ! ndispl : number of attemps to displace a particle per mc cycle
    ! npart	: total numbero fo particles
    ! temp : temperature
    ! rho : density
    ! ---input parameters: file: fort.25
    ! eps		= epsilon lennard-jones potential
    ! sig		= sigma lennard-jones potential
    ! mass	 = mass of the particle
    ! rc		 = cut-off radius of the potential
    ! ---input parameters: file: fort.11 (restart file to continue a simulation from disk)
    ! boxf	 = box length old configuration (if this one does not correspond to the requested density, the positions of the particles are rescaled!
    ! npart	= number of particles (over rules fort.15!!)
    ! dr = optimized maximum displacement old configurations
    ! x(1),y(1),z(1)	: position first particle 1
    ! x(npart),y(npart),z(npart): position particle last particle
	! include 'parameter.inc'
	! include 'system.inc'
	! include 'potential.inc'
	! include 'conf.inc'
	integer :: ibeg = 0, equil = 100, prod = 5000, i, ndispl = 50, nsamp = 1
	real*8 eps = 1d0, sig = 1d0, boxf = 5.22757959  2.61378979, rhof, rho = 7d-1, dr = 9d-1, m1

	box = (npart / rho) ** (1d0 / 3)
	hbox = box / 2
    ! read or generate configuration
	if (ibeg == 0) then
        ! generate configuration form lattice
		call lattice
	! else
	! 	write (*, *) 'read conf from disk '
    !     ! 5.22757959  2.61378979
	! 	read (11, *) boxf = 5.22757959
	! 	read (11, *) npart = 100
	! 	read (11, *) dr = 0.297316239
	! 	rhof = dble(npart)/boxf**3
	! 	if (abs(boxf-box)>1d-6) then
	! 		write (6, 99007) rho, rhof
	! 	end if
	! 	do i = 1, npart
	! 		read (11, *) x(i), y(i), z(i)
	! 		x(i) = x(i)*box/boxf
	! 		y(i) = y(i)*box/boxf
	! 		z(i) = z(i)*box/boxf
	! 	end do
	! 	rewind (11)
	end if
    ! write input data
	write (6, 99001) equil, prod, nsamp
	write (6, 99002) ndispl, dr
	write (6, 99003) npart, temp, rho, box
	write (6, 99004) eps, sig, mass
    ! calculate parameters:
	beta = 1 / temp
    ! calculate cut-off radius potential
	rc = min(rc, hbox)
	rc2 = rc*rc
	eps4 = 4d0*eps
	eps48 = 4.8d1*eps
	sig2 = sig*sig
	return
	99001 format ('	number of equilibration cycles :', i10, /, 'number of production cycles :', i10, /, '	sample frequency :', i10, /)
	99002 format ('	number of att. to displ. a part. per cycle :', i10, /, '	maximum displacement :', f10.3, //)
	99003 format ('	number of particles	:', i10, /, '	temperature	:', f10.3, /, '	density	:', f10.3, /, '	box length :', f10.3, /)
	99004 format ('	model parameters: ', /, '		 epsilon: ', f5.3, /, ' sigma: ', f5.3, /, '		 mass	 : ', f5.3)
	99007 format (' requested density: ', f5.2, ' different from density on disk: ', f5.2, /, ' rescaling of coordinates!')
end subroutine readdat

subroutine sample(i, en, vir, press)
	implicit none
    ! write quantities (pressure and energy) to file
    ! ener (input) : total energy
    ! vir	(input) : total virial
	include 'parameter.inc'
	include 'conf.inc'
	include 'system.inc'
	integer i
	real*8 en, enp, vir, press, vol
	if (npart/=0) then
		enp = en/dble(npart)
		vol = box**3
		press = (dble(npart)/vol)/beta + vir/(3.0d0*vol)
	else
		enp = 0.0d0
		press = 0.0d0
	end if
	write (*, *) i, 'enp', enp
	write (*, *) i, 'press', press
	return
end subroutine sample

subroutine store(dr)
    ! writes configuration to disk
    ! iout (input) file number
    ! dr	 (input) maximum displacement
	implicit none
	! include 'parameter.inc'
	! include 'conf.inc'
	! include 'system.inc'
	integer i
	real*8 dr

    open (10, file = 'conf.dat')
	write (10, *) box, hbox
	write (10, *) npart
	write (10, *) dr
	do i = 1, npart
		write (10, *) x(i), y(i), z(i)
	end do
	close (10)
	return
end subroutine store

subroutine toterg(ener, vir)
    ! calculates total energy of the system
    ! only used in the beginning or at the end of the program
    ! ener (output) : total energy
    ! vir (output) : total virial
	implicit none
	! include 'parameter.inc'
	! include 'conf.inc'
	real*8 :: xi, yi, zi, ener = 0, eni, viri, vir = 0
	integer :: i, j
	do i = 1, npart - 1
		xi = x(i)
		yi = y(i)
		zi = z(i)
		j = i + 1
		call eneri(xi, yi, zi, i, j, eni, viri)
		ener = ener + eni
		vir = vir + viri
	end do
	return
end subroutine toterg

subroutine writepdb
	implicit none
	! include 'parameter.inc'
	! include 'conf.inc'
	integer :: i, countmodel = 0, countatom = 0
	save countmodel, countatom
	countmodel = countmodel + 1
	write (22, '(a,i9)') 'model', countmodel
	do i = 1, npart
		countatom = countatom + 1
		write (22, '(a,i7,a,i12,4x,3f8.3)') 'atom', countatom, '	o', countatom, x(i), y(i), z(i)
	end do
	write (22, '(a)') 'endmdl'
	return
end subroutine writepdb

subroutine adjust(attemp, nacc, dr)
	implicit none
    ! adjusts maximum displacement such that 50% of the
    ! movels will be accepted
    ! attemp (input)	number of attemps that have been performed to displace a particle
    ! nacc	 (input)	number of successful attemps to displace a particle
    ! dr		 (output) new maximum displacement
	! include 'system.inc'
	integer attemp, nacc, attempp = 0, naccp = 0
	double precision dro, frac, dr
	save naccp, attempp

	if (attemp==0 .or. attempp>=attemp) then
		naccp = nacc
		attempp = attemp
	else
		frac = dble(nacc-naccp)/dble(attemp-attempp)
		dro = dr
		dr = dr*abs(frac/0.5d0)
        ! limit the change:
		if (dr/dro>1.5d0) dr = dro*1.5d0
		if (dr/dro<0.5d0) dr = dro*0.5d0
		if (dr>hbox/2.d0) dr = hbox/2.d0
		write (6, 99001) dr, dro, frac, attemp - attempp, nacc - naccp
        ! store nacc and attemp for next use
		naccp = nacc
		attempp = attemp
	end if
	return
	99001 format (' max. displ. set to : ', f6.3, ' (old : ', f6.3, ')', /, ' frac. acc.: ', f4.2, ' attempts: ', i7, ' succes: ', i7)
end subroutine adjust
end module

program mc_nvt
    ! gfortran 8.f90 -o 8 && ./8
	implicit none
	! equation of state of the lennard-jones fluid
	! include 'potential.inc'
	! include 'parameter.inc'
	! include 'system.inc'
	! include 'conf.inc'
	integer equil, prod, nsamp, ii, icycl, ndispl, attempt, nacc, ncycl, nmoves, imove, kkk
	real*8 :: en, ent, vir, virt, dr, av1 = 0, av2 = 0, press, bv1 = 0, bv2 = 0

	open (20, file = '8.dat')
	! initialize sysem
	call readdat(equil, prod, nsamp, ndispl, dr)
	nmoves = ndispl
	! total energy of the system
	call toterg(en, vir)
	write (*, 99001) en, vir
	! start mc-cycle
	do ii = 1, 2
		! ii=1 equilibration
		! ii=2 production
		if (ii==1) then
			ncycl = equil
			if (ncycl/=0) write (*, *) ' start equilibration '
		else
			if (ncycl/=0) write (*, *) ' start production '
			ncycl = prod
		end if
		attempt = 0
		nacc = 0
		! intialize the subroutine that adjust the maximum displacement
		call adjust(attempt, nacc, dr)
		do icycl = 1, ncycl
			do imove = 1, nmoves
				! attempt to displace a particle
				call mcmove(en, vir, attempt, nacc, dr)
			end do
			if (ii==2) then
				! sample averages
				if (mod(icycl,nsamp)==0) then
					call sample(icycl, en, vir, press)
					av1 = av1 + press
					av2 = av2 + 1.0d0
					! calculate the chemical potential	c
					! do 10 trial chains	
					! calculate the average of [exp(-beta*energy)]
					! you can use the subroutine eneri for this. good luck !
					do kkk = 1, 10
						! start modification
						bv2 = bv2 + 1.0d0
						! end modification
					end do
				end if
			end if
			if (mod(icycl,20)==0) call writepdb
			if (mod(icycl,ncycl/5)==0) then
				write (6, *) '======>> done ', icycl, ' out of ', ncycl
				! write intermediate configuration to file
				call store(8, dr)
				! adjust maximum displacements
				call adjust(attempt, nacc, dr)
			end if
		end do
		if (ncycl/=0) then
			if (attempt/=0) write (6, 99003) attempt, nacc, 100.0d0*dble(nacc)/dble(attempt)
						! test total energy
			call toterg(ent, virt)
			if (abs(ent-en)>1.d-6) then
				write (6, *) ' ######### problems energy ################ '
			end if
			if (abs(virt-vir)>1.d-6) then
				write (6, *) ' ######### problems virial ################ '
			end if
			write (6, 99002) ent, en, ent - en, virt, vir, virt - vir
			write (6, *)
			! print chemical potential and pressure
			if (ii==2) then
				write (6, *) 'average pressure : ', av1/av2
				write (6, *) 'chemical potential : ', -log((bv1/bv2)*(box*box*box/dble(npart)))/beta
			end if
		end if
	end do
	call store(21, dr)
	stop
	99001 format (' total energy initial configuration: ', f12.5, /, ' total virial initial configuration: ', f12.5)
	99002 format (' total energy end of simulation		: ', f12.5, /, '			 running energy							: ', f12.5, /, '			 difference									:	', e12.5, /, ' total virial end of simulation		: ', f12.5, /, '			 running virial							: ', f12.5, /, '			 difference									:	', e12.5)
	99003 format (' number of att. to displ. a part.	: ', i10, /, ' success: ', i10, '(= ', f5.2, '%)')
end program