module barrier_

integer, parameter :: maxhover = 100
integer nstep, ninit, nnoshover, choise
real*8 onepi, tstep, nu, temp, xpos, vpos, cons, wdti2(5), wdti4(5), wdti8(5)
real*8 xlogs(maxhover), vlogs(maxhover), glogs(maxhover), qmass(maxhover), iqmass(maxhover), freqnos, oldf

contains

subroutine readdat()
    implicit none
    ! read in system information
    real*8 u
    integer i

    nstep = 5000
    temp = 5d-2
    tstep = 1d-2
    ninit = 50
    choise = 0
    nu = 1d1
    freqnos = 1.5d0
    nnoshover = 1
    onepi = 4.0d0*atan(1.0d0)
    xpos = 0.0d0
    vpos = ran_vel()
    oldf = 0.0d0
    u = 0.0d0
    call force(xpos, u, oldf)
    wdti2(1) = 1.0d0/(4.0d0-(4.0d0**(1.0d0/3.0d0)))
    wdti2(2) = wdti2(1)
    wdti2(3) = 1.0d0 - 4.0d0*wdti2(1)
    wdti2(4) = wdti2(1)
    wdti2(5) = wdti2(1)
    if (choise==3) vpos = sqrt(temp)
    do i = 1, 5
        wdti2(i) = wdti2(i)*tstep*0.5d0
        wdti4(i) = wdti2(i)*0.5d0
        wdti8(i) = wdti4(i)*0.5d0
    end do
    do i = 1, nnoshover
        qmass(i) = temp/(freqnos*freqnos)
        iqmass(i) = 1.0d0/qmass(i)
        xlogs(i) = 0.0d0
        glogs(i) = 0.0d0
        vlogs(i) = iqmass(i)
    end do
    do i = 2, nnoshover
        glogs(i) = iqmass(i)*(qmass(i-1)*vlogs(i-1)*vlogs(i-1)-temp)
    end do
    return
end subroutine readdat
function ran_vel()
    implicit none
    ! generates a random velocity according to a boltzmann distribution
    real*8 ran_vel

    ran_vel = sqrt(temp)*ran_gauss()
    return
end function ran_vel
function ran_gauss()
    implicit none
    real*8 ran1, ran2, ran_gauss, ransq

    100 ran1 = 2.0d0*ran_uniform() - 1.0d0
    ran2 = 2.0d0*ran_uniform() - 1.0d0
    ransq = ran1*ran1 + ran2*ran2
    if (ransq>=1.0d0 .or. ransq<=0.0d0) goto 100
    ran_gauss = ran1*dsqrt(-2.0d0*dlog(ransq)/ransq)
    return
end function ran_gauss
function ran_uniform()
    implicit none
    real*8 ran_uniform
    call random_number(ran_uniform)
end function ran_uniform
subroutine sample_diff(switch)
    implicit none
!		 tmax	= maximum timesteps for the correlation time
!		 t0max = maximum number of time origins
    integer tmax, t0max
    parameter (tmax=1000)
    parameter (t0max=200)
    integer ttel, tt0(t0max), t0, switch, i, t, tvacf, dt
    real*8 r2t(tmax), rx0(t0max), nvacf(tmax), dtime
    save nvacf, tvacf, r2t, rx0, tt0, t0
    if (switch==1) then
        tvacf = 0
        t0 = 0
        do i = 1, tmax
            r2t(i) = 0.0d0
            nvacf(i) = 0.0d0
        end do
    else if (switch==2) then
        tvacf = tvacf + 1
        if (mod(tvacf,50)==0) then
            t0 = t0 + 1
            ttel = mod(t0-1, t0max) + 1
            tt0(ttel) = tvacf
            rx0(ttel) = xpos
        end if
        do t = 1, min(t0, t0max)
            dt = tvacf - tt0(t) + 1
            if (dt<tmax) then
                nvacf(dt) = nvacf(dt) + 1.0d0
                r2t(dt) = r2t(dt) + (xpos-rx0(t))**2
            end if
        end do
    else
        do i = 1, tmax - 1
            dtime = dble(i-1)*tstep
            if (nvacf(i)>=0.5d0) then
                r2t(i) = r2t(i)/nvacf(i)
            else
                r2t(i) = 0.0d0
            end if
            if (i/=1) then
                write (12, *) dtime, r2t(i), r2t(i)/(2.0d0*dtime)
            else
                write (12, *) dtime, r2t(i), ' 0.0d0'
            end if
        end do
    end if
    return
end subroutine sample_diff
subroutine sample_prof(switch)
    implicit none
    integer maxx, i, switch
    parameter (maxx=500)
    real*8 dtot, dens(maxx), delta, xxx
    save dtot, dens, delta
    if (switch==1) then
        delta = dble(maxx-1)/4.0d0
        dtot = 0.0d0
        do i = 1, maxx
            dens(i) = 0.0d0
        end do
    else if (switch==2) then
        dtot = dtot + 1.0d0
        xxx = xpos + 2.0d0
        if (xxx>0.0d0 .and. xxx<4.0d0) then
            i = 1 + idint(delta*xxx)
            dens(i) = dens(i) + 1.0d0
        end if
    else
        do i = 1, maxx
            write (13, *)((dble(i-1)/delta)-2.0d0), dens(i)/dtot
        end do
    end if
    return
end subroutine sample_prof
subroutine force(x, u, f)
    implicit none
    ! calculate the forces and potential energy
    real*8 x, u, f
    if (x<=0.0d0) then
        u = 2.0d0*onepi*onepi*x*x
        f = -4.0d0*onepi*onepi*x
    else if (x>=1.0d0) then
        u = 2.0d0*onepi*onepi*(x-1.0d0)*(x-1.0d0)
        f = -4.0d0*onepi*onepi*(x-1.0d0)
    else
        u = 1.0d0 - dcos(2.0d0*onepi*x)
        f = -2.0d0*onepi*dsin(2.0d0*onepi*x)
    end if
    return
end subroutine force
! subroutine integrate_nve
!     implicit none
!     ! integrate the equations of motion for an nve system
!     ! use either velocity verlet or leap-frog. you do not have to declare any new variables
!     ! hint: use the following symbols:
!     ! tstep : timestep integration
!     ! xpos	: old position
!     ! oldf	: old force
!     ! cons	: conserved quantity
!     ! to calculate the force and energy for a given position, see force.f
!     real*8 u, f, vnew
!     ! start modification
!     call force(xpos, u, f)
!     xpos = xpos + tstep * vpos + tstep**2 * f / 2
!     vpos = vpos + f * tstep / 2
!     call force(xpos, u, f)
!     vpos = vpos + f * tstep / 2
!     cons = u + vpos * vpos / 2
!     ! end modification
!     return
! end subroutine integrate_nve
subroutine integrate_nve
    implicit none
    ! integrate the equations of motion for an nve system
    ! use either velocity verlet or leap-frog. you do not have to declare any new variables
    ! hint: use the following symbols:
    ! tstep : timestep integration
    ! xpos	: old position
    ! oldf	: old force
    ! cons	: conserved quantity
    ! to calculate the force and energy for a given position, see force.f
    real*8 u, f, vnew
    ! start modification
    xpos = xpos + tstep * vpos / 2
    call force(xpos, u, f)
    vpos = (vpos + f * tstep)
    xpos = xpos + tstep * vpos / 2
    cons = u + vpos * vpos / 2
    ! end modification
    return
end subroutine integrate_nve
subroutine integrate_ber
    implicit none
    real*8 u, f, vnew, lambda
    ! start modification
    lambda = sqrt(1 + tstep * (temp / vpos**2 - 1))
    xpos = xpos + tstep * vpos / 2
    call force(xpos, u, f)
    vpos = (vpos + f * tstep) * lambda
    xpos = xpos + tstep * vpos / 2
    cons = u + vpos * vpos / 2
    ! end modification
    return
end subroutine integrate_ber
subroutine integrate_and
    implicit none
    ! integrate the equations of motion for the andersen thermostat	c
    ! ran_uniform : uniform random number
    ! ran_vel : generate a velocity form the correct distribution
    real*8 u, f
    ! start modification
    call force(xpos, u, f)
    xpos = xpos + vpos * tstep + f * tstep**2 / 2
    vpos = vpos + f * tstep / 2
    call force(xpos, u, f)
    vpos = vpos + f * tstep / 2
    if (ran_uniform() < nu * tstep) vpos = ran_vel()
    cons = u + vpos * vpos / 2
    ! end modification
    return
end subroutine integrate_and
subroutine integrate_res
    implicit none
    ! integrate the equations of motion using an explicit nose-hoover chain
    ! see the work of martyna/tuckerman et al.
    integer i, j
    real*8 u, f, scale, ukin, aaa
    ! update thermostat	 c
    scale = 1.0d0
    ukin = vpos**2
    glogs(1) = (ukin-temp)*iqmass(1)
    do j = 1, 5
        vlogs(nnoshover) = vlogs(nnoshover) + glogs(nnoshover)*wdti4(j)
        do i = 1, nnoshover - 1
            aaa = dexp(-wdti8(j)*vlogs(nnoshover-i+1))
            vlogs(nnoshover-i) = vlogs(nnoshover-i)*aaa*aaa + wdti4(j)*glogs(nnoshover-i)*aaa
        end do
        scale = scale*dexp(-wdti2(j)*vlogs(1))
        glogs(1) = (scale*scale*ukin-temp)*iqmass(1)
        do i = 1, nnoshover
            xlogs(i) = xlogs(i) + vlogs(i)*wdti2(j)
        end do
        do i = 1, nnoshover - 1
            aaa = dexp(-wdti8(j)*vlogs(i+1))
            vlogs(i) = vlogs(i)*aaa*aaa + wdti4(j)*glogs(i)*aaa
            glogs(i+1) = (qmass(i)*vlogs(i)*vlogs(i)-temp)*iqmass(i+1)
        end do
        vlogs(nnoshover) = vlogs(nnoshover) + glogs(nnoshover)*wdti4(j)
    end do
    vpos = vpos*scale
    ! normal integration	c
    vpos = vpos + 0.5d0*tstep*oldf
    xpos = xpos + tstep*vpos
    call force(xpos, u, f)
    oldf = f
    vpos = vpos + 0.5d0*tstep*oldf
    ! update thermostat	 c
    scale = 1.0d0
    ukin = vpos**2
    glogs(1) = (ukin-temp)*iqmass(1)
    do j = 1, 5
        vlogs(nnoshover) = vlogs(nnoshover) + glogs(nnoshover)*wdti4(j)
        do i = 1, nnoshover - 1
            aaa = dexp(-wdti8(j)*vlogs(nnoshover-i+1))
            vlogs(nnoshover-i) = vlogs(nnoshover-i)*aaa*aaa + wdti4(j)*glogs(nnoshover-i)*aaa
        end do
        scale = scale*dexp(-wdti2(j)*vlogs(1))
        glogs(1) = (scale*scale*ukin-temp)*iqmass(1)
        do i = 1, nnoshover
            xlogs(i) = xlogs(i) + vlogs(i)*wdti2(j)
        end do
        do i = 1, nnoshover - 1
            aaa = dexp(-wdti8(j)*vlogs(i+1))
            vlogs(i) = vlogs(i)*aaa*aaa + wdti4(j)*glogs(i)*aaa
            glogs(i+1) = (qmass(i)*vlogs(i)*vlogs(i)-temp)*iqmass(i+1)
        end do
        vlogs(nnoshover) = vlogs(nnoshover) + glogs(nnoshover)*wdti4(j)
    end do
    vpos = vpos*scale
    cons = u + 0.5d0*vpos*vpos
    ! calculate conservative quantity	c
    do j = 1, nnoshover
        cons = cons + 0.5d0*qmass(j)*vlogs(j)*vlogs(j) + temp*xlogs(j)
    end do
    return
end subroutine integrate_res
subroutine integrate_mc
    implicit none
    ! mc simulation
    real*8 uold, unew, f, xnew
    call force(xpos, uold, f)
    xnew = xpos + 2.5d0*(ran_uniform()-0.5d0)
    call force(xnew, unew, f)
    if (ran_uniform()<dexp(-(unew-uold)/temp)) xpos = xnew
    oldf = 0.0d0
    vpos = 0.0d0
    cons = 0.0d0
    return
end subroutine integrate_mc
end module

program barrier1
    ! gfortran 13_2.f90 -o 13_2 && ./13_2
    use barrier_
    implicit none
    integer i, j
    real*8 cstart, cc1, cc2, tt1, tt2

    open (10, file = '13_2.dat')
    open (11, file = '13_2_trace.dat')
    open (12, file = '13_2_diff.dat')
    open (13, file = '13_2_dist.dat')
    call readdat()
    cc1 = 0.0d0
    cc2 = 0.0d0
    cstart = 0.0d0
    tt1 = 0.0d0
    tt2 = 0.0d0
    call sample_diff(1)
    call sample_prof(1)
    write (10, *) 'conserved    temp'
    do i = 1, nstep
        do j = 1, 1000
            if (choise==1) then
                call integrate_nve
            else if (choise==2) then
                call integrate_and
            else if (choise==3) then
                call integrate_res
            else if (choise==0) then
                call integrate_ber
            else
                call integrate_mc
            end if
            if (i>ninit) then
                call sample_diff(2)
                call sample_prof(2)
                tt1 = tt1 + vpos*vpos
                tt2 = tt2 + 1.0d0
                if (mod(j,200)==0) write (11, *) xpos, vpos
                if (mod(i,10)==0 .and. j==1) write (10, '(2e20.10)') cons, vpos*vpos
            end if
            if (i==ninit) then
                cstart = cons
            else if (i>ninit) then
                if (choise/=2 .and. choise/=4) cc1 = cc1 + abs((cons-cstart)/cstart)
                cc2 = cc2 + 1.0d0
            end if
        end do
    end do
    call sample_diff(3)
    call sample_prof(3)
    write (10, *) 'energy drift: ', cc1/cc2
    write (10, *) 'average temp.: ', tt1/tt2
    close (10)
    close (11)
    close (12)
    close (13)
    stop
end program barrier1