#include "def.h"
#include "input.h"
#include "init.h"
#include "tool.h"
#include "measure.h"
#include "energy.h"
#include "integrate.h"

int main(void) {
    readInput();

    memAlloc();    

#ifndef FIXED_SEED
    RANDINIT;
#else
    BEASTSEED_INIT;
#endif

    init();

    for(int i = 0; i < bstep * cpstep; i++) {
        Integrate();
    }
    
    for(int i = 0; i < nstep; i++) {
        for(int j = 0; j < cpstep; j++) {
            Integrate();
        }
#ifdef PRINT_ALL
        printf("sample %d\n", i);
#endif
        sample();        
    }

    memFree();
    return 0;
}