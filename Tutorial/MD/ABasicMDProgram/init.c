#include "init.h"
#include "measure.h"
#include "energy.h"

void init() {
    
    // initialization part
    latticeInit();
    // iLatticeInit(L/4);
    velocityInit();

    // initial check
    printf("--------MD-NVE--------\n");
    printf("scheme: %d\n", scheme);
    switch(scheme) {
    case 1: printf("Leap Frog algorithm\n");break;
    case 2: printf("Verlet algorithm\n");break;
    case 3: printf("velocity Verlet algorithm\n");break;
    case 4: printf("Euler algorithm\nWARNING: USING EULER ALGO. CAN BE RISKY!\n");break;
    default: break;
    }
    printf("random test:\n");
    printf("random seed: (unsigned long int) %lu\n", mseed);
    for(int i = 0; i < 5; i++)
        printf("%d:%9.6lf\n", i + 1, RANDOM);
    
    printf("\n--------BASIC-PARAMETERS--------\n");
    printf("number of particles: %d\n", N);
    printf("density: %9.6lf\n", N/L/L/L);
    printf("box length: %9.6lf\n", L);
    printf("input temperature: %9.6lf\n", temp);
    printf("time step: %9.6lf\n", dt);
    printf("balance steps: %d\n", cpstep * bstep);
    printf("number of samples: %d\n", nstep);
    printf("number of cycles between two samples: %d\n", cpstep);
    printf("USING TRUNCATED AND SHIFTED POTENTIAL\n");
    printf("\tpotential truncation distance: %9.6lf\n", RCUT);
    printf("\tenergy shift: %9.6lf\n", ecut);
    printf("\n--------ENERGY--------\n");
    printf("initial temperature:%9.6f\n", dTemp());
    printf("initial tot. kinetic energy: %9.6lf\n", dTemp() * DIM / 2 * N);
    printf("initial tot. potential energy: %9.6f\n", dEnergy());
    printf("initial tot. energy: %9.6lf\n", ener + dTemp() * DIM / 2 * N);
    printf("initial tot. virial: %9.6lf\n", vir);
    printf("\n--------VELOCITY--------\n");
    printf("velocity centre of mass\n");
    for(int i = 0; i < DIM; i++) {
        double tmpres = 0;
        for(int j = 0; j < N; j++)
            tmpres += NVel[j * DIM + i];
        printf("\tdim %2d: %9.6lf\n", i+1, tmpres);
    }
    printf("velocity square\n");
    for(int i = 0; i < DIM; i++) {
        double tmpres = 0;
        for(int j = 0; j < N; j++)
            tmpres += NVel[j*DIM+i]*NVel[j*DIM+i];
        printf("\tdim%2d: %9.6lf\n", i+1, tmpres);
    }
    printf("\n--------END-OF-INITIAL-CHECK--------\n\n");

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
    
    /* This is a wrong scheme
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
            OCoo[i*DIM+j] -= OVel[i*DIM+j] * dt;        // position previous time step
        }
    }
    */
    
    for(int i = 0; i < DIM; i++) {
        sumv = 0;
        for(int j = 0; j < N; j++) {
            sumv += NVel[i + j * DIM];
        }
        sumv /= N;
        for(int j = 0; j < N; j++) {
            NVel[i + j * DIM] -= sumv;
        }
        c = sqrt(temp*N/dVel2(i));
        for(int j = 0; j < N; j++) {
            NVel[i + j * DIM] *= c;
            OVel[j*DIM+i] = NVel[j*DIM+i];
            OCoo[j*DIM+i] -= OVel[j*DIM+i] * dt;        // position previous time step
        }
    }
    return;
}