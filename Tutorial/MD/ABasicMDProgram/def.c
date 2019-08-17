#include "def.h"

// length of the three-dimensional box
double L;

// number of particles
int N;

// initial temperature
double temp;

// timestep delta t
double dt;

// balance step
int bstep;

// number of simulation steps
int nstep;

// number of simulation cycles per step
int cpstep;

// cutoff energy
double ecut;

// energy
double ener;

// old coordinates
double* OCoo;

// new coordinates
double* NCoo;

// old velocities
double* OVel;

// new velocitirs
double* NVel;

// forces
double* NForce;

// memory allocation and initialization of global variables
void memAlloc() {

    // memory allocation
    OCoo = malloc(DIM*N*sizeof(double));
    NCoo = malloc(DIM*N*sizeof(double));
    OVel = malloc(DIM*N*sizeof(double));
    NVel = malloc(DIM*N*sizeof(double));
    NForce = malloc(DIM*N*sizeof(double));
    if(!(OCoo&&NCoo&&NVel&&OVel&&NForce)) {
        printf("Memory allocation failed.\n");
        exit(9999);
    }
    
    // initialization of cutoff energy
    double rc2i = 1/RCUT/RCUT;
    double rc6i = rc2i*rc2i*rc2i;
    ecut = 4*(rc6i*rc6i-rc6i);

    // initialization of global energy variable
    ener = 0;

    return;
}

// destruction
void memFree() {
    // memory cleanup
    free(OCoo);
    free(NCoo);
    free(OVel);
    free(NVel);
    free(NForce);
    
    return;
}