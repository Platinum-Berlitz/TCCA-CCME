#include "integrate.h"
#include "energy.h"

void Integrate() {
    switch(scheme) {
        case 1:LFIntegrate();break;
        case 2:VIntegrate();break;
        case 3:VVIntegrate();break;
        case 4:EIntegrate();break;
        default:printf("NO INTEGRATOR SELECTED\n");exit(1000);
    }
    return;
}

void VIntegrate() {

#ifdef INTSEL_DBG
    printf("V\n");
#endif

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

    enkin = 0;
    for(int i = 0; i < N*DIM; i++)
        enkin += NVel[i] * NVel[i];
    enkin /= 2;

    return;
}


void VVIntegrate() {
    
    // memory allocation and cleanup

#ifdef INTSEL_DBG
    printf("VV\n");
#endif

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

    enkin = 0;
    for(int i = 0; i < N*DIM; i++)
        enkin += NVel[i] * NVel[i];
    enkin /= 2;

    return;
}

void EIntegrate() {

#ifdef INTSEL_DBG
    printf("E\n");
#endif

    dForce(NForce);
    for(int i = 0; i < DIM*N; i++) {
        OVel[i] = NVel[i];
        OCoo[i] = NCoo[i];
        
        NCoo[i] += NVel[i] * dt;
        NVel[i] += NForce[i] * dt;
    }
    enkin = 0;
    for(int i = 0; i < N*DIM; i++)
        enkin += NVel[i] * NVel[i];
    enkin /= 2;
    return;
}

void LFIntegrate() {
    
#ifdef INTSEL_DBG
    printf("LF\n");
#endif

    double v2 = 0;
    dForce(NForce);
    for(int i = 0; i < DIM*N; i++) {
        OVel[i] = NVel[i];
        NVel[i] += dt*NForce[i];
        OCoo[i] = NCoo[i];
        NCoo[i] += dt * NVel[i];
        v2 += (NVel[i]+OVel[i])*(NVel[i]+OVel[i])/4;
    }
    enkin = v2 / 2;
    return;
}