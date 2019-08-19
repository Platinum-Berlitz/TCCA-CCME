#include "measure.h"

double dTemp() {
    double res = 0;
    for(int i = 0; i < DIM*N; i++)
        res += NVel[i]*NVel[i];
    return res/DIM/N;
}

double dVel2(int i) {
    double res = 0;
    for(int j = 0; j < N; j++)
        res += NVel[i+j*DIM]*NVel[i+j*DIM];
    return res;
}

void sample() {
    //double T = dTemp();
    //printf("%9.6f\t%9.6f\t%9.6f\n", T*DIM/2, ener/N, ener/N + T*DIM/2);
    printf("%9.6f\t%9.6f\t%9.6f\n", enkin/N, ener/N, ener/N + enkin/N);
#ifdef PRINT_ALL
    printf("OCoo\n");
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < DIM; j++)
            printf("%9.6lf\t", OCoo[i*DIM + j]);
        printf("\n");
    }

    printf("NCoo\n");
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < DIM; j++)
            printf("%9.6lf\t", NCoo[i*DIM + j]);
        printf("\n");
    }
    
    printf("OVel\n");
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < DIM; j++)
            printf("%9.6lf\t", OVel[i*DIM + j]);
        printf("\n");
    }

    printf("NVel\n");
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < DIM; j++)
            printf("%9.6lf\t", NVel[i*DIM + j]);
        printf("\n");
    }

    printf("NForce\n");
    for(int i = 0; i < N; i++) {
        for(int j = 0; j < DIM; j++)
            printf("%9.6lf\t", NForce[i*DIM + j]);
        printf("\n");
    }
#endif
    return;
}