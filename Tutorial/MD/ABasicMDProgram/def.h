#ifndef DEF_H
#define DEF_H

// include essential libraries
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <memory.h>

// initialize a random generator
#define RANDINIT srand((unsigned)time(NULL))

// initialize the random generator with a selected seed
#define BEASTSEED_INIT srand(1145141919810)

// generate a random number in [0,1]
#define RANDOM (double)rand()/(double)RAND_MAX

// cutoff distance
#define RCUT 2.5

// dimension of the system
#define DIM 3

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

// cutoff energy
extern double ecut;

// energy
extern double ener;

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