#ifndef INTEGRATE_H
#define INTEGRATE_H

#include "def.h"

// integrator selector
void Integrate();

// integrate the equation using Verlet algorithm
void VIntegrate();

// integrate the equation using velocity Verlet algorithm
void VVIntegrate();

// integrate the equation using Euler algorithm
void EIntegrate();

// integrate the equation using Beeman algorithm
// void BIntegrate();

// integrate the equation under Cayley transform
// void CIntegrate();

// integrate the equation using Leap Frog algorithm
void LFIntegrate();

#endif // INTEGRATE_H