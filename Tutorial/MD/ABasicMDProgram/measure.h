#ifndef MEASURE_H
#define MEASURE_H

#include "def.h"

// temperature of the new velocity
double dTemp();

// sum of velocitie square in a particular dimension
double dVel2(int i);

// sample
void sample();

#endif // MEASURE_H