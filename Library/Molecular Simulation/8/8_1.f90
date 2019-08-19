module mc

integer i, q
integer, parameter :: nparts(10) = (/(i*30, i=1, 10)/), equil = 100, ndispl = 50, prod = 5000
real*8, parameter :: box = 2d1, hbox = box / 2, temp = 2d0, beta = 1/temp
real*8, parameter :: rc = min(5d0, hbox), rc2 = rc*rc
real*8 :: dr = 9d-1, rho
integer npart
real*8, allocatable :: x(:), y(:), z(:)

contains

subroutine ener(en, vir, r2)
	implicit none
	real*8 :: r2, r2i, r6i, r12i, en, vir
	
	en = 0d0
	vir = 0d0
	if (r2 < rc2) then
		r2i = 1d0/r2
		r6i = r2i**3
		r12i = r6i*r6i
		en = 4*(r12i-r6i)
        vir = 48*r12i - 24*r6i
	end if
	return
end subroutine ener

subroutine eneri(xi, yi, zi, i, jb, en, vir)
	implicit none
	real*8 :: xi, yi, zi, en, dx, dy, dz, r2, vir, virij, enij
	integer :: i, j, jb
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
	implicit none
	integer :: i, j, k, itel, n
	real*8 :: dx, dy, dz, del
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
	! write (20, *) 'initialization on lattice: ', itel, 'particles placed on a lattice'
	return
end subroutine lattice

subroutine mcmove(en, vir, attempt, nacc, dr)
	implicit none
	real*8 :: enn, eno, en, ran_uniform, xn, yn, zn, viro, virn, vir, dr, r1, r2, r3
	integer :: o, attempt, nacc, jb
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

subroutine sample(i, en, vir, press)
	implicit none
	integer :: i
	real*8 :: en, enp, vir, press, vol
	enp = en / npart
	vol = box ** 3
	rho = npart / vol
	press = rho / beta + vir / (3.0d0*vol)
	! print *, press, rho / beta
	return
end subroutine sample

subroutine toterg(ene, vir)
	implicit none
	real*8 :: xi, yi, zi, ene, eni, viri, vir
	integer :: i, j
	ene = 0d0
	vir = 0d0
	do i = 1, npart - 1
		xi = x(i)
		yi = y(i)
		zi = z(i)
		j = i + 1
		call eneri(xi, yi, zi, i, j, eni, viri)
		ene = ene + eni
		vir = vir + viri
	end do
	return
end subroutine toterg

subroutine adjust(attemp, nacc, dr)
	implicit none
	integer :: attemp, nacc, attempp = 0, naccp = 0
	real*8 dro, frac, dr
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
        ! store nacc and attemp for next use
		naccp = nacc
		attempp = attemp
	end if
	return
end subroutine adjust
end module

program mc_nvt
    ! gfortran 8_1.f90 -o 8_1 && ./8_1
	use mc
	implicit none
	integer ii, icycl, attempt, nacc, ncycl, imove, kkk
	real*8 :: en, ent, vir, virt, av1 = 0, av2 = 0, press, bv1 = 0, bv2 = 0

	open (20, file = '8_1.dat')
	do q = 1, 10
	av1 = 0
	av2 = 0 
	bv1 = 0
	bv2 = 0
	npart = nparts(q)
	allocate(x(npart), y(npart), z(npart))
	! initialize sysem
	call lattice()
	! total energy of the system
	call toterg(en, vir)
	! print *, en, vir / box**3 / 3
	! start mc-cycle
	do ii = 1, 2
		! ii=1 equilibration
		! ii=2 production
		if (ii == 1) then
			ncycl = equil
			! write (20, *) 'start equilibration '
		else
			ncycl = prod
			! write (20, *) 'start production '
		end if
		attempt = 0
		nacc = 0
		! intialize the subroutine that adjust the maximum displacement
		call adjust(attempt, nacc, dr)
		do icycl = 1, ncycl
			do imove = 1, ndispl
				! attempt to displace a particle
				call mcmove(en, vir, attempt, nacc, dr)
			end do
			if (ii==2) then
				! sample averages
				call sample(icycl, en, vir, press)
				av1 = av1 + press
				av2 = av2 + 1.0d0
				! calculate the chemical potential
				do kkk = 1, 10
					bv1 = bv1 + 1.0d0
					bv2 = bv2 + 1.0d0
				end do
			end if
			if (mod(icycl,ncycl/5)==0) then
				call adjust(attempt, nacc, dr)
			end if
		end do
		! write (20, *) 'attempts', attempt, 'accepted', nacc
		! test total energy
		call toterg(ent, virt)
		! write (20, *) 'compare e :', ent, en, ent - en
		! write (20, *) 'compare v :', virt, vir, virt - vir
		! print chemical potential and pressure
		if (ii==2) then
			write (20, *) npart / box**3, av1/av2
			! write (20, *) 'chemical potential : ', -log((bv1/bv2)*(box*box*box/dble(npart)))/beta
		end if
	end do
	deallocate(x, y, z)
	end do
	stop
end program