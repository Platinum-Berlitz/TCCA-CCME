#include "integrate.h"
#include "energy.h"

void VIntegrate() {

    // force calculation
    dForce(NForce);

    // loop
    for(int i = 0; i < DIM*N; i++) {
        double nx = 2*NCoo[i]-OCoo[i]+dt*dt*NForce[i];      // new position
        NVel[i] = (nx-OCoo[i])/2/dt;                        // update velocity
        OCoo[i] = NCoo[i];                                  // update position
        NCoo[i] = nx;
        OVel[i] = NVel[i];
    }

    // fix the position to ensure it is in the box
    for(int i = 0; i < DIM*N; i++) {
        double fix = floor(NCoo[i]/L)*L;
        NCoo[i] -= fix;
        OCoo[i] -= fix;
    }

    return;
}


void VVIntegrate() {
    
    // memory allocation and cleanup

    double* NNForce = malloc(DIM*N*sizeof(double));
    if(!NNForce)
        exit(9999);
    free(OCoo);
    free(OVel);

    OCoo = NCoo;
    OVel = NVel;
    NCoo = malloc(DIM*N*sizeof(double));
    NVel = malloc(DIM*N*sizeof(double));
    if(!NCoo || !NVel)
        exit(9999);
    
    // loop over all particles to update coordinates
    for(int i = 0; i < DIM*N; i++) {
        NCoo[i] = OCoo[i] + OVel[i] * dt + NForce[i] * dt * dt /2;
    }

    // new force calculation
    dForce(NNForce);

    // update of velocities
    for(int i = 0; i < DIM*N; i++) {
        NVel[i] = OVel[i] + (NNForce[i] + NForce[i])*dt/2;
    }

    // memory cleanup and update
    free(NForce);
    NForce = NNForce;

    return;
}

void EIntegrate() {
    dForce(NForce);
    for(int i = 0; i < DIM*N; i++) {
        OVel[i] = NVel[i];
        OCoo[i] = NCoo[i];
        
        NCoo[i] += NVel[i] * dt;
        NVel[i] += NForce[i] * dt;
    }
    return;
}