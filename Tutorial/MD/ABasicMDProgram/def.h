#ifndef DEF_H
#define DEF_H

// options

// fix random seed to 1145141919810 (2680619074 in unsigned int)
#undef FIXED_SEED
// test the integrator selector by printing a sign before an integration
#undef INTSEL_DBG
// print all information in calculation, including NVel, OVel, NCoo, OCoo and NForce
#undef PRINT_ALL

// macro message
#ifdef FIXED_SEED
#pragma message("SEED HAS BEEN FIXED TO 2680619074!")
#endif
#ifdef INTSEL_DBG
#pragma message("INTEGRATOR SELECTOR CHECK HAS BEEN ACTIVATED. NOW AN INTEGRATOR WILL OUTPUT ITS NAME BEFORE WORKING!")
#endif
#ifdef PRINT_ALL
#pragma message("ALL INFORMATION WILL BE PRINTED DURING CALCULATION!")
#endif

// include essential libraries
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <memory.h>

// initialize a random generator
#define RANDINIT \
                mseed = (unsigned)time(NULL); \
                srand(mseed)

// initialize the random generator with a MALODOROUS selected seed
#define BEASTSEED_INIT \
                mseed = 1145141919810; \
                srand(mseed)

// generate a random number in [0,1]
#define RANDOM (double)rand()/(double)RAND_MAX

// cutoff distance
#define RCUT 2.5

// dimension of the system
#define DIM 3

// tail correlation, 1 = true, 0 = false
#define TAILCO 1

// length of the three-dimensional box
extern double L;

// number of particles
extern int N;

// initial temperature
extern double temp;

// timestep delta t
extern double dt;

// number of balance steps
extern int bstep;

// number of simulation steps
extern int nstep;

// number of simulation cycles per step
extern int cpstep;

// index of scheme, 1 for leapfrog, 2 for verlet, 3 for velocity verlet, 4 for euler
extern int scheme;

// random seed
extern unsigned long mseed;

// cutoff energy
extern double ecut;

// energy
extern double ener;

// kinetic energy
extern double enkin;

// Virial
extern double vir;

// old coordinates
extern double* OCoo;

// new coordinates
extern double* NCoo;

// old velocities
extern double* OVel;

// new velocitirs
extern double* NVel;

// forces
extern double* NForce;

// memory allocation
void memAlloc();

// destruction
void memFree();

#endif // DEF_H