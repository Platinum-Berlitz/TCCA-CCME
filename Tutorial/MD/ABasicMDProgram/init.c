#include "init.h"
#include "measure.h"

void init() {
    latticeInit();
    // iLatticeInit(L/4);
    velocityInit();
    return;
}

// place particles on a lattice
void latticeInit() {

    int b = (int)pow(N, 1.0/(double)DIM) + 1;
    
    for(int i = 0; i < N; i++) {
        int itmp = i;
        for(int j = 0; j < DIM; j++) {
            OCoo[i*DIM+j] = L / b * (itmp%b);
            itmp = (int)(itmp/b);
        }
        /*
        OCoo[i*3] = L * (i % b) / b;
        OCoo[i*3+1] = L * ((int)(i / b) % b) / b;
        OCoo[i*3+2] = L * ((int)(i/b/b) % b) / b;
        */
    }

    for(int i = 0; i < DIM*N; i++) {
        NCoo[i] = OCoo[i];
    }
    return;
}

// place particles on a lattice with self-defined lattice
void iLatticeInit(double il) {
    /*
    int b = (int)pow(N, 1.0/3.0) + 1;
    for(int i = 0; i < N; i++) {
        OCoo[i*3] = il * (i % b) / b;
        OCoo[i*3+1] = il * ((int)(i / b) % b) / b;
        OCoo[i*3+2] = il * ((int)(i/b/b) % b) / b;
    }
    */
    int b = (int)pow(N, 1.0/(double)DIM) + 1;
    
    for(int i = 0; i < N; i++) {
        int itmp = i;
        for(int j = 0; j < DIM; j++) {
            OCoo[i*DIM+j] = il / b * (itmp%b);
            itmp = (int)(itmp/b);
        }
    }

    for(int i = 0; i < DIM*N; i++) {
        NCoo[i] = OCoo[i];
    }
    return;
}

// random velocity generation
void velocityInit() {

    double c, sumv = 0;

    for(int i = 0; i < DIM*N; i++) {
        NVel[i] = RANDOM - 0.5; 
    }

    for(int j = 0; j < DIM; j++) {

        // calculation of correction factor
        c = sqrt(temp*N/dVel2(j));

        // velocity of mass center
        sumv = 0;
        for(int i = 0; i < N; i++)
            sumv += NVel[i*DIM+j];
        sumv /= N;
        
        // correction to velocities
        for(int i = 0; i < N; i++) {
            NVel[i*DIM+j] = (NVel[i*DIM+j]-sumv)*c;
            OVel[i*DIM+j] = NVel[i*DIM+j];
            OCoo[i*DIM+j] -= OVel[i*DIM+j] * dt;
        }
    }
    return;
}