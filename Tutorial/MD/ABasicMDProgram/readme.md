# README

本程序是一个（尚未完工的）实现最简单功能的分子动力学程序。

## Theory

分子动力学程序的主要任务是积分离散化的演化方程，并从中提取需要的信息。系统的演化方程可以写成牛顿方程的形式:

$$
\vec{F} = m\ddot{\vec{x}}
$$

一部分系统的演化也可以以哈密顿正则形式表述：

$$
\left\{
\begin{aligned}
\dot{\vec{x}}&=\frac{\partial H}{\partial\vec{p}} \\
\dot{\vec{p}}&=-\frac{\partial H}{\partial\vec{x}}
\end{aligned}    
\right.
$$

将上述方程离散化，就可以据之实现对运动方程的积分。对积分得到的轨迹进行处理就可以产生我们想要利用分子动力学得到的物理信息。

### 不同的离散化方案举例

#### 1. Euler方法

$$
x(t+dt) = x(t) + v(t)dt + o(dt^2)\\
v(t+dt) = v(t) + \frac{F(t)}{m}dt + o(dt^2)
$$

欧拉方法是最简单的分子动力学方法，要求的信息最少，短时的表现尚可，但是并不保哈密顿，长时间会产生能量漂移。

#### 2. Verlet方法

$$
x(t+dt) = 2x(t) - x(t-dt) + \frac{F(t)}{m}dt^2 + o(dt^4)\\
v(t) = \frac{x(t+dt)-x(t-dt)}{2mdt}+o(dt^2)
$$

Verlet方法是很常用的一种动力学方法，计算流程如下：

- 计算F(t)
- 根据F(t)和x(t)以及x(t-dt)计算x(t+dt)
- 计算v(t)
- 继续下一个循环

Verlet方法的短时表现尚可，长时间能量漂移不明显，有一个能量量纲的守恒量（准哈密顿量）。

#### 3. Velocity-Verlet

$$
x(t+dt) = x(t) + v(t)dt + F(t)dt^2/2m + o(dt^3) \\
v(t+dt) = v(t) + \frac{F(t) + F(t-dt)}{2m}dt + o(dt^2)
$$

Velocity-Verlet和Verlet算法等价。

其他的如Leap-frog方法和高阶方法等省略不提。

## 程序结构

.h为头文件（接口），.c为源文件（具体实现）。程序入口（主函数）为main.c。

```c
#include "def.h"
#include "input.h"
#include "init.h"
#include "tool.h"
#include "measure.h"
#include "energy.h"
#include "integrate.h"

int main(void) {
    readInput();    // 从标准输入中读取参数

    memAlloc();     // 分配内存，以及初始化常量
    RANDINIT;       // 将时间设为随机数种子
    init();         // 初始化坐标和速度向量

    // 平衡部分
    for(int i = 0; i < bstep * cpstep; i++) {
        EIntegrate();   // 用Euler方法积分，Integrator可以换为
                        // VIntegrate或者VVIntegrate，下同
    }
    
    for(int i = 0; i < nstep; i++) {
        for(int j = 0; j < cpstep; j++) {
            EIntegrate();
        }
        sample();       // 采样，这里只输出动能、势能和总能量
    }

    memFree();          // 释放内存
    return 0;
}
```

### def.h和def.c

该文件规定了一些全局变量，需要用到的标准库以及一些自定义宏。def.h如下：

```c
#ifndef DEF_H
#define DEF_H

// include essential libraries
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <memory.h>

// initialize a random generator
#define RANDINIT srand((unsigned)time(NULL))

// generate a random number in [0,1]
#define RANDOM (double)rand()/(double)RAND_MAX

// cutoff distance
#define RCUT 2.5

// dimension of the system 维度！维度！维度！
#define DIM 1

// length of the three-dimensional box
extern double L;

// number of particles
extern int N;

// initial temperature
extern double temp;

// timestep delta t
extern double dt;

// number of balance steps
extern int bstep;

// number of simulation steps
extern int nstep;

// number of simulation cycles per step
extern int cpstep;

// cutoff energy
extern double ecut;

// energy
extern double ener;

// old coordinates
extern double* OCoo;

// new coordinates
extern double* NCoo;

// old velocities
extern double* OVel;

// new velocitirs
extern double* NVel;

// forces
extern double* NForce;

// memory allocation
void memAlloc();

// destruction
void memFree();

#endif // DEF_H
```

### input

定义了读取输入的函数readInput()，示例输入如下（一维零温单谐振子的测试）：

```c
1
1
0
1e-2
0
2000
1
```

对应着

```
模拟三维空间的边长，浮点数
粒子个数，整数
温度，浮点数
时间步长，浮点数
平衡步数，整数
采样步数，整数
每一步对应的循环个数，整数
```

- 实际进行的循环次数为$(平衡步数+采样步数)\times 循环个数$，每一个循环对应着一个时间步长$dt$。

### energy

定义了力的计算和能量，通过选择注释掉某个部分可以切换lj势/谐振子势（见文件）。对于lj势能，实际采取的是截断-平移的势能(tr-sh Leonard-Jones potential)。谐振子势为中心在空间中央的，频率为1的谐振子模型。

### integrate

- VIntegrate对应Verlet
- VVIntegrate对应Velocity-Verlet
- EIntegrate对应Euler

### measure

只是简单的打印输出。输出文件如下所示：

```c
 0.000013	 0.125000	 0.125013
 0.000050	 0.125000	 0.125050
 0.000112	 0.124975	 0.125087
 0.000200	 0.124925	 0.125125
 0.000312	 0.124850	 0.125162
 0.000450	 0.124750	 0.125200
 0.000612	 0.124625	 0.125237
 0.000799	 0.124476	 0.125275
 0.001011	 0.124301	 0.125312
 0.001247	 0.124102	 0.125349
 0.001508	 0.123878	 0.125386
 0.001793	 0.123630	 0.125423
 0.002103	 0.123357	 0.125460
 0.002437	 0.123059	 0.125497
 0.002795	 0.122738	 0.125533
 0.003178	 0.122392	 0.125570
 0.003584	 0.122022	 0.125606
 0.004013	 0.121629	 0.125642
 0.004467	 0.121212	 0.125678
 0.004943	 0.120771	 0.125714
 0.005443	 0.120307	 0.125750
 0.005966	 0.119820	 0.125786
 0.006511	 0.119310	 0.125821
 0.007079	 0.118777	 0.125856
```

分别对应着（平均，下同）动能、势能和总能。

### tool

一些辅助工具。

## run中的其他文件

- compile.bat含有编译的gcc命令，会输出md.exe
- run.bat为运行的批处理文件，运行时需要更改输入、输出文件，格式如下：

```
md.exe < 输入文件名 > 输出文件名
```

- plot.py会输出两个图。第一个图为三种能量随着采样步长的变化，而第二个散点图为动能-势能图，都用于检查能量的漂移程度。
- 对于github上的版本，在根目录下运行$make可以生成可执行文件md。

## 联系方式

uxie@pku.edu.cn
