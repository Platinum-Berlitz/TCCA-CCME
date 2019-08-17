#include "energy.h"

double dForce(double* f) {
    ener = 0;                       // set ener to zero
    double* pt = NCoo;              // use present coordinates
    double dX[DIM];                 // coordinate difference in different dimensions
    double r2 = 0;                  // square of distance

    // set forces to zero
    for(int i = 0; i < DIM*N; i++)
        f[i] = 0;
    
    // loop over all pairs
    for(int i = 0; i < N; i++) {
        for(int j = i + 1; j < N; j++) {
            
            r2 = 0;                 // set r2 to zero

            // calculate r2 using pbc
            for(int k = 0; k < DIM; k++) {
                dX[k] = pt[DIM*i+k]-pt[DIM*j+k];
                dX[k] -= L * floor(dX[k]/L);
                r2 += dX[k] * dX[k];
            }

            // expection: division by zero
            if(r2 == 0) {
                printf("Division by zero!\n");
                for(int l = 0; l < DIM; l++) {
                    printf("%9.6lf\t%9.6lf\n", pt[DIM*i+l], pt[DIM*j+l]);
                }
                exit(2000);
            }
            
            // start of the potential section

            // leonard-jones
            
            // cutoff
            if(r2 < RCUT*RCUT) {
                double r2i = 1 / r2;
                double r6i = r2i*r2i*r2i;
                double ff = 48*r2i*r6i*(r6i-0.5);       // lj potential force factor

                // update force
                for(int k = 0; k < DIM; k++) {
                    f[DIM*i+k] += ff * dX[k];
                    f[DIM*j+k] -= ff * dX[k];
                }

                // update energy
                ener += 4*r6i*(r6i-1) - ecut;
            }
            

            // end of the potential section
            
        }

        // start of the potential section
        /*
        // harmonic oscillator case
        for(int k = 0; k < DIM; k++) {
            f[DIM*i+k] = L/2-NCoo[DIM*i+k];
            ener += (NCoo[DIM*i+k]-L/2)*(NCoo[DIM*i+k]-L/2)/2;
        }
        */
        // end of the potential section
    }
    return ener;
}