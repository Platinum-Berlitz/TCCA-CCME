#ifndef TOOL_H
#define TOOL_H

#include "def.h"

void printCoo(int i) {
    double* pt;
    if(!i)
        pt=OCoo;
    else
        pt=NCoo;
    printf("NOP       \tx              \ty              \tz              \n");
    for(int i = 0; i < N; i++)
        printf("%9d\t%9.6f\t%9.6f\t%9.6f\n", i+1, pt[i*3], pt[i*3+1], pt[i*3+2]);
    return;
}

#endif // TOOL_H