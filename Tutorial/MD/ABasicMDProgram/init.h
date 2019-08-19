#ifndef INIT_H
#define INIT_H

#include "def.h"

// initialize coordinates and temperatures
void init();

// place particles on a lattice
void latticeInit();

// place particles on a lattice with self-defined lattice
void iLatticeInit(double il);

// random velocity generation
void velocityInit();

#endif