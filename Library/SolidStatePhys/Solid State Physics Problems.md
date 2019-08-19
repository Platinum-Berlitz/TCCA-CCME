# 00

鉴于 2017 年的固体物理学期末考试中至少有 60 分作业原题，且平时助教在批改作业和习题课中没有给出足够的反馈，因此整理此份习题答案有助于大家对作业中的重点模型有更丰富的理解。下面给出认领情况表格：

| 序号 | 认领 | 进度 | 位置 |
| ---- | ---- | ---- | ---- |
| 01   |蘑菇|完成|HW01|
| 02   |蘑菇|完成|HW02|
| 03   |蘑菇|完成|HW03|
| 04   |蘑菇|完成|HW04|
| 05   |蘑菇|缺1|HW05|
| 06   |蘑菇|完成|HW06|
| 07   |蘑菇|完成|HW07|
| 08   |蘑菇|完成|HW08|
| 09   |蘑菇|存疑|HW09|
| 10   |蘑菇|存疑|HW10|
| 11   |昌珺涵|完成|本md|
| 12   |昌珺涵|完成|本md|
| 13   |昌珺涵|完成|本md|
| 14   |昌珺涵|完成|本md|
| 15   |昌珺涵|完成|本md|
| 16   |昌珺涵|完成|本md|
| 17   |||
| 18   |||
| 19   |谭淞宸|完成|本md|
| 20   |谭淞宸|完成|本md|
| 21   |谭淞宸|存疑|本md|
| 22   |谭淞宸|完成|本md|
| 23   |谭淞宸|完成|本md|
| 24   |谭淞宸|完成|本md|
| 25   |      |      |      |
| 26   |      |      |      |
| 27   |      |      |      |
| 28   |      |      |      |
| 29   |      |      |      |

# 11

> 1.计算满足色散 $\omega=c q^{2}$ 的声子在三维，二维，一维情形下的模式密度。

模式密度

$$ 
g(\omega)=\frac{V}{(2 \pi)^{d}} \int \frac{\mathrm{d} S}{\left|\nabla_{q} \omega(q)\right|} ,\quad\text{其中} \quad \nabla_{q} \omega(q)=2 c q
$$

$$
g(\omega)=
\left\{
\begin{aligned}
    &\text{3D,}\quad\frac{V}{(2 \pi)^{3}} \frac{1}{2 c q} \int \mathrm{d} S =\frac{V}{(2 \pi)^{3}} \frac{1}{2 c q} 4 \pi q^{2} =\frac{V}{4 \pi^{2} c} \sqrt{\frac{\omega}{c}}=\frac{V}{4 \pi^{2} c^{3 / 2}} \omega^{1 / 2} \\
    &\text{2D,}\quad\frac{S}{(2 \pi)^{2}} \frac{1}{2 c q} \int \mathrm{d} L=\frac{S}{(2 \pi)^{2}} \frac{1}{2 c q} 2 \pi q=\frac{S}{4 \pi c} \\
    &\text{1D,}\quad\frac{L}{2 \pi} \frac{1}{2 c q}\times 2=\frac{L}{2 \pi c} \sqrt{\frac{c}{\omega}}=\frac{L}{2 \pi \sqrt{c}} \omega^{-1 / 2}
\end{aligned}
\right.
$$

> 2.1


> 2.2


> 3.解释黄昆书图3-33，合金的热导率的变化。

晶体内部的杂质可以散射格波，使得声子平均自由程减小，从而起到降低热导的效果。

> 4.为什么晶体的红外吸收峰很尖锐，而非晶很宽。

晶体红外吸收需要同时满足能量守恒和准动量守恒，所以满足要求的点仅在 $q=0$ 附近非常窄的范围内，故晶体的红外吸收峰非常尖锐。由于非晶不具有平移对称性，故其与光子相互作用时，只需满足能量守恒，在很宽的频率范围内均能满足该要求，故其吸收峰很宽。

# 12

## 4

> 证明拉普拉斯算符具有平移不变性。（附加：证明旋转不变性）

$$
\begin{pmatrix}
    y_{1} \\ \vdots \\ y_{n}
\end{pmatrix}
=
\begin{pmatrix}
    R_{11} & \cdots & R_{1 n} \\
    \vdots & \ddots & \vdots \\
    R_{n 1} & \cdots & R_{n n}
\end{pmatrix}
\begin{pmatrix}
    x_{1} \\ \vdots \\ x_{n}
\end{pmatrix}
$$

$$
\frac{\partial}{\partial x_{i}}=\sum_{j} \frac{\partial}{\partial y_{j}} \frac{\partial y_{j}}{\partial x_{i}}=\sum_j R_{j i} \frac{\partial}{\partial y_{j}}
$$

$$
\frac{\partial^2}{\partial x_{i}^2}=\sum_{j,k} \frac{\partial^2}{\partial y_{j}\partial y_{k}} \frac{\partial y_{j}}{\partial x_{i}}\frac{\partial y_{k}}{\partial x_{i}}=\sum_{j,k} R_{j i} R_{k i} \frac{\partial^2}{\partial y_{j} \partial y_{k}}
$$

当 $\mathbf{R}$ 为旋转矩阵时，有 $\mathbf{R^T R=R R^T =I}$，即

$$
\sum_{j,k} R_{j i} (R^T)_{i k} = \sum_{j,k} R_{j i} R_{k i} = R_{j i}^2 \delta_{jk},\quad \frac{\partial^2}{\partial x_{i}^2}=\sum_{j} R_{ji}^2 \frac{\partial^2}{\partial y_{j}^2}
$$

$$ 
\nabla_{x}^2 \boldsymbol{E}=\sum_{i} \frac{\partial^{2}}{\partial x_{i}^{2}} E_{i}=\sum_{i} \sum_{j} R_{j i}^{2} \frac{\partial^{2}}{\partial y_{j}^{2}} E_{i}=\nabla_{y}^2(\mathbf{R} \boldsymbol{E})
 $$

- - -
以下 $V_n$ 表示周期场 $V(x)$ 的第 $n$ 个傅里叶系数：$k_n=2\pi n/a$

$$
\begin{aligned}
V(x)=\bar{V}+\sum_{n \neq 0} V_{n} e^{i \frac{2 \pi}{a} n x}\\ V_{n}=\frac{1}{L} \int_{0}^{L} V(x) e^{-i \frac{2 \pi}{a} n x} \mathrm{d} x
\end{aligned}
$$
- - -

# 13

## 1

> 一维周期场近自由电子近似得到的解的周期部分为 $u_k(x)$。问 $u_k(x)^\star$ 与 $u_{-k}(x)$ 有何关系？

一级近似下，

$$
\begin{aligned}
    \psi_{k}(x)&=\psi_{k}^{(0)}(x)+\psi_{k}^{(1)}(x)\\
    &=\psi_{k}^{(0)}(x)+\sum_{k^{\prime}\neq k} \frac{\langle k\vert \Delta V(x)\vert k^{\prime}\rangle}{E_{k}^{(0)}-E_{k^{\prime}}^{(0)}} \psi_{k^{\prime}}^{(0)}(x)\\
    &=\frac{1}{\sqrt{L}} e^{i k x}+\sum_{n \neq 0} \frac{V_{-n}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k-\frac{2 \pi}{a} n\right)^{2}\right]} \frac{1}{\sqrt{L}} e^{i\left(k-\frac{2 \pi n}{a}\right) x}\\
    &=\frac{1}{\sqrt{L}} e^{i k x}\left[1+\sum_{n \neq 0} \frac{V_{-n} e^{-i \frac{2 \pi}{a} n x}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k-\frac{2 \pi}{a} n\right)^{2}\right]}\right]=\frac{1}{\sqrt{L}} e^{i k x} u(x)\\
    &=\frac{1}{\sqrt{L}} e^{i k x} u(x)
\end{aligned}
$$

其中可证明 $H_{k^{\prime}, k}^{\prime}=\langle k^{\prime}\vert V(x)\vert k\rangle$ 的复共轭为其相反数：

$$
\begin{aligned}
    H_{k^{\prime}, k}^{\prime} &=\int_{0}^{L} \psi_{k^{\prime}}^{(0) \star}(x) V(x) \psi_{k}^{(0)}(x) \mathrm{d} x \\
    &=\int_{0}^{L} \frac{1}{L} e^{-i k^{\prime} x}\left(\sum_{n \neq 0} V_{n} e^{i \frac{2 \pi}{a} n x}\right) e^{i k x} \mathrm{d} x \\
    &=\frac{1}{L}\sum_{n \neq 0} \int_{0}^{L} V_{n} e^{-i\left[k^{\prime}-\left(k+\frac{2 \pi}{a}n\right)\right] x} \mathrm{d} x \\
    &=\sum_{n \neq 0} V_{n} \delta_{k^{\prime},\left(k+\frac{2 \pi}{a} n\right)}=V_{-n_0} \\
    H_{k^{\prime}, k}^{\prime}&=
    \int_{0}^{L} \frac{1}{L} e^{-i k^{\prime} x}\left(\sum_{n \neq 0} V_{n}^\star e^{-i \frac{2 \pi}{a} n x}\right) e^{i k x} \mathrm{d} x \\
    &=\frac{1}{L}\sum_{n \neq 0} \int_{0}^{L} V_{n}^{\star} e^{-i\left[k^{\prime}-\left(k-\frac{2 \pi}{a}n\right)\right] x} \mathrm{d} x \\
    &=\sum_{n \neq 0} V_{n}^{\star} \delta_{k^{\prime},\left(k-\frac{2 \pi}{a} n\right)}=V_{n_0}^{\star}\\
    \Longrightarrow &\quad V_{n_0}^{\star}=V_{-n_0},\quad n_0=\frac{a}{2\pi}(k^\prime-k)
\end{aligned}
$$

故 $u(x)$ 同样满足

$$
\begin{aligned}
    u_k(x)&=1+\sum_{n \neq 0} \frac{V_{-n} e^{-i \frac{2 \pi}{a} n x}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k-\frac{2 \pi}{a} n\right)^{2}\right]}\\
    &=1+\sum_{-n \neq 0} \frac{V_{n} e^{i \frac{2 \pi}{a} n x}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k+\frac{2 \pi}{a} n\right)^{2}\right]}\\
    u_{-k}(x)&=1+\sum_{n \neq 0} \frac{V_{n} e^{i \frac{2 \pi}{a} n x}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k-\frac{2 \pi}{a} n\right)^{2}\right]}\\
    &=1+\sum_{n \neq 0} \frac{V_{-n}^{\star} e^{-i \frac{2 \pi}{a} (-n) x}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k+\frac{2 \pi}{a} (-n)\right)^{2}\right]}\\
    &=1+\sum_{-n \neq 0} \frac{V_{n}^{\star} e^{-i \frac{2 \pi}{a} n x}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k+\frac{2 \pi}{a} n\right)^{2}\right]}\\
    &=u_k(x)^{\star}
\end{aligned}
$$

## 2

> 一维周期场近自由电子近似下，简约布里渊右边的一个 $k$（不在边界附近），零级、一级和二级修正下的三个最低能量是多少？

不在布里渊区边界附近，可采用非简并微扰。

$$
\begin{aligned}
    E_k^{(0)}&=\frac{\hbar^2k^2}{2m}+\bar{V} \\
    E_k^{(1)}&=H_{k, k}^{\prime}=\langle k\vert \Delta V(x)\vert k\rangle=0 \\
    E_k^{(2)}&=\sum_{k^{\prime}\neq k} \frac{\langle k^{\prime}\vert \Delta V(x)\vert k\rangle}{E_k^{(0)}-E_{k^{\prime}}^{(0)}}\\
    &=\sum_{n \neq 0} \frac{\left|V_{n}\right|^{2}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k+\frac{2 \pi n}{a}\right)^{2}\right]}\\
    E&=E_k^{(0)}+E_k^{(1)}+E_k^{(2)}\\
    &=\frac{\hbar^2k^2}{2m}+\bar{V}+\sum_{n \neq 0} \frac{\left|V_{n}\right|^{2}}{\frac{\hbar^{2}}{2 m}\left[k^{2}-\left(k+\frac{2 \pi n}{a}\right)^{2}\right]}
\end{aligned}
$$

# 14

## 1

> 一维周期场近自由电子近似下，简约布里渊右边的一个 $k$（不在边界附近），求三条最低能带，在零级和一级修正下的波函数是多少？

$$
\psi_{k}^{(0)}(x)=\frac{1}{\sqrt{L}} e^{i k x}
$$

$$ 
\psi_{k}^{(0)}(x)+\psi_{k}^{(1)}(x)=\frac{1}{\sqrt{L}} e^{i k x}\left\{1+\sum_{n \neq 0}\frac{V_n}{\frac{h^{2}}{2 m}\left[k^{2}-\left(k+\frac{2 \pi}{a} n\right)^{2}\right]} e^{-i \frac{2 \pi n}{a} x}\right\}
$$

代入 $k=k,k\pm 2\pi/a$ 得三个能带波函数。

## 2

> Be 具有 hcp 结构。按照近自由电子近似，它的4个电子会占据几个布里渊区？会全部占满么？为什么？

$N$ 个 Be 原胞有 $4N$ 个价电子，一个布里渊区可以容纳 $2N$ 个电子，因此可以占据 2 个布里渊区，但由于 Be 的碱土金属特性，其能带会发生交叠，故不会占满整个布里渊区。

## 3

> 一维单原子链的晶格常数是 $a$, 周期势场为 $V(x)=2V_1 \cos(2πx/a)$。现用平面波展开求其电子波函数 $\psi_k(x)$, 写出试探波函数的前 5 项($G=0, 2π/a, -2π/a, 4π/a, -4π/a$)和求其本征方程的久期行列式的前 5×5 项。如果试探波函数只取两项，即 $\psi_{k}(x)=a e^{i k x}+b e^{i(k+2 \pi / a) x}$，求此时能量的本征值。在第一布里渊区画出该一维晶体的能带。

平面波展开的波函数为

$$
\left\{
\begin{aligned}
    3D,& \quad\psi_{\boldsymbol{k}}(\boldsymbol{r})=\frac{1}{\sqrt{V}} \sum_{\boldsymbol{G_{n}}} a_{\boldsymbol{k}}(\boldsymbol{G}_{n}) e^{i(\boldsymbol{k+G_n}) \boldsymbol{r}}\\
    1D,& \quad\psi_{k}(x)=\frac{1}{\sqrt{L}} \sum_{G_{n}} a_{k}(G_{n}) e^{i(k+G_n) x}
\end{aligned}
\right.
$$

$$
\psi_{k}(x)=\frac{1}{\sqrt{L}} e^{i k x}\left[a_{k}(0)+a_{k}\left(\frac{2 \pi}{a}\right) e^{i \frac{2 \pi}{a} x}+a_{k}\left(-\frac{2 \pi}{a}\right) e^{-i \frac{2 \pi}{a} x}+a_{k}\left(\frac{4 \pi}{a}\right) e^{i \frac{4 \pi}{a} x}+a_{k}\left(-\frac{4 \pi}{a}\right) e^{-i \frac{4 \pi}{a} x}\right]
$$

代入薛定谔方程

$$
\left[-\frac{\hbar^{2}}{2 m} \nabla^{2}+V(x)\right] \psi_k(x)=E \psi_k(x)
$$

$$
\frac{1}{\sqrt{L}} \sum_{m}\left[\frac{\hbar^{2}}{2 m} (k+G_{m})^{2}-E+V(x)\right] a(G_{m}) e^{i(k+G_{m}) x}=0
$$

两侧同乘以 $L^{-1/2} \exp[-i(k+G_{n})x]$ 得

$$
\frac{1}{L} \sum_{m}\left[\frac{\hbar^{2}}{2 m} (k+G_{m})^{2}-E+V(x)\right] a(G_{m}) e^{i(G_{m}-G_n) x}=0
$$

对整个晶体积分，

$$
\begin{aligned}
    &\sum_m \left\{\int_L \frac{1}{L} \left[\frac{\hbar^{2}}{2 m} (k+G_{m})^{2}-E \right] a(G_{m}) e^{i(G_{m}-G_n) x} \mathrm{d}x+ a(G_{m}) \int_L \frac{1}{L} V(x) e^{i (G_{m}-G_n) x}\mathrm{d}x\right\} \\
    =&\sum_m \left[\frac{\hbar^{2}}{2 m} (k+G_{m})^{2}-E \right] a(G_{m}) \delta_{mn} +\sum_m a(G_{m}) \tilde{V}(G_{n}-G_{m})=0
\end{aligned}

$$

久期行列式为

$$
\det\left|\frac{\hbar^{2}}{2 m}(k+G_{m})^{2} \delta_{m n}+\tilde{V}(G_{m}-G_{n})-E_k \delta_{m n}\right|=0
$$

其中

$$
\tilde{V}(G_{m}-G_{n})=V_{m-n}= \int e^{-i\left(G_{m}-G_{n}\right) x} V(x) \mathrm{d} x=\frac{2 V_{1}}{a} \int e^{-i\left(G_{m}-G_{n}\right) x} \cos \frac{2 \pi x}{a} \mathrm{d} x
$$

前5项（9项）中，

$$
\begin{aligned}
V(0)&=\frac{2 V_{1}}{a} \int_{0}^{a} \cos \frac{2 \pi x}{a} d x=0 \\
V\left(\frac{2 \pi}{a}\right)&=\frac{2 V_{1}}{a} \int_{0}^{a} e^{-i \frac{2 \pi}{a} x} \cos \frac{2 \pi x}{a} d x=V\left(-\frac{2 \pi}{a}\right)=V_{1} \\
V\left(\frac{4 \pi}{a}\right)&=\frac{2 V_{1}}{a} \int_{0}^{a} e^{-i \frac{2 \pi}{a} x} \cos \frac{4 \pi x}{a} d x=V\left(-\frac{4 \pi}{a}\right)=0 \\
V\left(\frac{6 \pi}{a}\right)&=V\left(-\frac{6 \pi}{a}\right)=V\left(\frac{8 \pi}{a}\right)=V\left(-\frac{8 \pi}{a}\right)=0
\end{aligned}
$$

若试探波函数只取前 2 项，久期行列式为

$$
\begin{vmatrix}\dfrac{\hbar^{2}}{2 m} k^{2}-E_{k} & {V_{1}} \\ {V_{1}} & {\dfrac{\hbar^{2}}{2 m}(k+\dfrac{2\pi}{a})^{2}-E_{k}}
\end{vmatrix}=0
$$

解得

$$ 
E_{ \pm}=\frac{h^{2}}{4 m}\left[k^{2}+\left(k+\frac{2 \pi}{a}\right)^{2}\right] \pm \sqrt{\frac{\pi^{2} h^{4}}{a^{2} m^{2}}\left(k+\frac{\pi}{a}\right)^{2}+V_{1}^{2}}
$$

## 4

> 用平面波展开求解三维晶体能带，跃迁矩阵元为 $H_{mn}$，进一步化简 $V_{\boldsymbol{G_m-G_n}}$.

解法与上题一维情形相同。

$$
\begin{aligned}
    V_{\boldsymbol{G_m-G_n}} &= \int e^{-i(\boldsymbol{G_m-G_n}) \boldsymbol{r}} V(\boldsymbol{r}) \mathrm{d} \boldsymbol{r} \\
    &=\frac{1}{N V_{0}} \sum_{m=0}^{N-1} \int e^{-i(\boldsymbol{G_m-G_n}) \boldsymbol{r}} V(\boldsymbol{r}) V(\boldsymbol{r}) \mathrm{d} \boldsymbol{r} \\
    & =\frac{1}{V} \sum_{p_{1}=0}^{N_{1}-1} \sum_{p_{2}=0}^{-1} \sum_{p_{3}=0}^{-1} \int e^{-i(\boldsymbol{G_m-G_n}) (\boldsymbol{r+R_p})} V(\boldsymbol{r}) \mathrm{d} \boldsymbol{r}
\end{aligned}

$$

# 15

## 1

> 原子轨道线性组合（布洛赫和的线性组合）求晶体的波函数，在只考虑一个布洛赫和的情况下，证明从久期行列式 $\det|H_{mn} – ES_{mn}|=0$ 导出的能带色散与书上用简并微扰导出的能带色散是完全一致的。

简并微扰是将哈密顿矩阵对角化，求解 $\det|H_{mn} – E\delta_{mn}|=0$，这在紧束缚近似 $S_{mn}=\delta_{mn}$ 时与久期行列式 $\det|H_{mn} – ES_{mn}|=0$ 等价。

试探波函数 $\psi(\boldsymbol{r})=\sum_m a_m \varphi_i(\boldsymbol{r-R_m})$.

$$
E=\frac{\langle\psi(\boldsymbol{r}) \vert \hat{H} \vert \psi(\boldsymbol{r}) \rangle}{\langle\psi(\boldsymbol{r}) \vert \psi(\boldsymbol{r}) \rangle}=\frac{\sum_m \sum_n a_m a_n H_{mn}}{\sum_m \sum_n a_m a_n S_{mn}}=\frac{Y}{Z}
$$

$$
\begin{aligned}
    \frac{\partial E}{\partial a_n}&=\frac{1}{Z}\left( \frac{\partial Y}{\partial a_n} - E\frac{\partial Z}{\partial a_n} \right) \\
    &=\frac{1}{Z}\left( 2\sum_m a_m H_{mn} - 2E\sum_m a_m S_{mn} \right) \\
    &=0 \\
    \Longrightarrow & \det|H_{mn} – ES_{mn}|=0
\end{aligned}
$$

孤立原子的薛定谔方程为

$$
\left[ -\frac{\hbar^2}{2m}\nabla^2 + V(\boldsymbol{r-R_m}) \right] \varphi_i(\boldsymbol{r-R_m})= \varepsilon_i \varphi_i(\boldsymbol{r-R_m})
$$

晶体的薛定谔方程为

$$
\left[ -\frac{\hbar^2}{2m}\nabla^2 + U(\boldsymbol{r}) \right] \psi(\boldsymbol{r})= E \psi(\boldsymbol{r})
$$

记 $\boldsymbol{\xi=r-R_m}$，晶体与孤立原子的矩阵元之差

$$
-J(\boldsymbol{R_n-R_m})=\int \mathrm{d} \boldsymbol{\xi} \varphi_i^{\star}(\boldsymbol{\xi}-(\boldsymbol{R_n-R_m}))[U(\boldsymbol{\xi})-V(\boldsymbol{\xi})]\varphi_i(\boldsymbol{\xi})
$$

哈密顿量的矩阵元

$$
\begin{aligned}
    H_{mn}&=\int \mathrm{d} \boldsymbol{\xi} \varphi_i^{\star}(\boldsymbol{\xi}-(\boldsymbol{R_n-R_m}))\left[-\frac{\hbar^2}{2m}\nabla^2 + U(\boldsymbol{\xi})\right]\varphi_i(\boldsymbol{\xi}) \\
    &=\int \mathrm{d} \boldsymbol{\xi} \varphi_i^{\star}(\boldsymbol{\xi}-(\boldsymbol{R_n-R_m}))[U(\boldsymbol{\xi})-V(\boldsymbol{\xi})+\varepsilon_i]\varphi_i(\boldsymbol{\xi}) \\
    &=\varepsilon_i\cdot S_{mn} - J(\boldsymbol{R_n-R_m})
\end{aligned}
$$

重叠矩阵元

$$
S_{mn}=\int \mathrm{d} \boldsymbol{\xi} \varphi_i^{\star}(\boldsymbol{\xi}-(\boldsymbol{R_n-R_m})) \varphi_i(\boldsymbol{\xi}) \approx 0
$$

久期行列式 $\det|H_{mn} – ES_{mn}|=0$ 的解同样为

$$
E(\boldsymbol{k})=\varepsilon_i - \sum_{\boldsymbol{R_n}}J(\boldsymbol{R_n-R_m})e^{-i\boldsymbol{k}\cdot(\boldsymbol{R_n-R_m})}
$$

各系数同样为

$$
a_m=\frac{1}{\sqrt{N}} e^{i\boldsymbol{k}\cdot\boldsymbol{R_m}}
$$

## 2

> 问 $A \frac{1}{\sqrt{N}} \sum_{m} e^{i \boldsymbol{k} \cdot \boldsymbol{R_{m}}} \varphi_{i}\left(\boldsymbol{r}-\boldsymbol{R}_{m}\right)+B e^{i \boldsymbol{k} \cdot \boldsymbol{r}}$ 是否满足布洛赫定理。$A,B$ 为常数。即布洛赫和与平面波的组合是否满足布洛赫定理？

$$
\begin{aligned}
    \psi(\boldsymbol{r})&=A \frac{1}{\sqrt{N}} \sum_{m} e^{i \boldsymbol{k} \cdot \boldsymbol{R_{m}}} \varphi_{i}\left(\boldsymbol{r}-\boldsymbol{R}_{m}\right)+B e^{i \boldsymbol{k} \cdot \boldsymbol{r}}\\
    &=e^{i\boldsymbol{k\cdot r}}\left[ A \frac{1}{\sqrt{N}} \sum_{m} e^{-i \boldsymbol{k} \cdot (\boldsymbol{r-R_{m}})} \varphi_{i}\left(\boldsymbol{r}-\boldsymbol{R}_{m}\right)+B \right]
\end{aligned}
$$

记 $\boldsymbol{R_s=R_m-R_n}$，由于求和遍及所有原子，求和所得相等：

$$
\begin{aligned}
    \psi(\boldsymbol{r+R_n})&=A \frac{1}{\sqrt{N}} \sum_{m} e^{i \boldsymbol{k} \cdot \boldsymbol{R_{m}}} \varphi_{i}\left(\boldsymbol{r}-\boldsymbol{R}_{s}\right)+B e^{i \boldsymbol{k} \cdot \boldsymbol{r}}\\
    &=e^{i\boldsymbol{k\cdot R_n}} e^{i\boldsymbol{k\cdot r}} \left[ A \frac{1}{\sqrt{N}} \sum_{m} e^{-i \boldsymbol{k} \cdot (\boldsymbol{r-R_{s}})} \varphi_{i}\left(\boldsymbol{r}-\boldsymbol{R}_{s}\right)+B \right]\\
    &=e^{i\boldsymbol{k\cdot R_n}}\psi(\boldsymbol{r})
\end{aligned}
$$

可见将波矢选取为 $\boldsymbol{k^{\prime}=k}$，即有 $\psi(\boldsymbol{r+R_n})=e^{i\boldsymbol{k^{\prime}\cdot R_n}}\psi(\boldsymbol{r})$，满足布洛赫定理。

# 16

## 1

> 用紧束缚近似求出面心立方晶格和体心立方晶格 s 态原子能级相对应的能带函数。

## 2

> 黄书4.7(1), 4.12

## 3

> 紧束缚近似下，晶格常数为 $a$ 的简单立方晶格 s 轨道形成能带，写出在 $\boldsymbol{k}=(0,\pi/a,\pi/a)$ 和 $\boldsymbol{k}=(\pi/a,\pi/a,\pi/a)$ 点的波函数。

$$
\psi_{\boldsymbol{k},\mathrm{s}}(\boldsymbol{r})=\frac{1}{\sqrt{N}}\sum_m e^{i\boldsymbol{k}\cdot\boldsymbol{R_m}} \varphi_\mathrm{s}(\boldsymbol{r-R_m})
$$

$\boldsymbol{k}=(0,\pi/a,\pi/a)$ 时，$e^{ik_x R_{m,x}}=1,\quad e^{ik_y R_{m,y}}=(-1)^{R_{m,y}/a},\quad e^{ik_z R_{m,z}}=(-1)^{R_{m,z}/a}$.

$$
\psi_{\boldsymbol{k},\mathrm{s}}(\boldsymbol{r})=\frac{1}{\sqrt{N}}\sum_m (-1)^{(R_{m,y}+R_{m,z})/a} \varphi_\mathrm{s}(\boldsymbol{r-R_m})
$$

$\boldsymbol{k}=(\pi/a,\pi/a,\pi/a)$ 时，

$$
\psi_{\boldsymbol{k},\mathrm{s}}(\boldsymbol{r})=\frac{1}{\sqrt{N}}\sum_m (-1)^{(R_{m,x}+R_{m,y}+R_{m,z})/a} \varphi_\mathrm{s}(\boldsymbol{r-R_m})
$$

## 4（此题存疑，以下答案被批错说写反了）

> 紧束缚近似下，晶格常数为 $a$ 的简单立方晶格，p 轨道形成能带。对 p<sub>z</sub> 轨道形成的能带，沿着 $(0,0,k_z)$ 方向的色散，写出 $k_z=0,\pi/a$ 时候的波函数。从波函数角度（看波函数的重叠情况）分析 $k_z=0$ 和 $\pi/a$ 哪个态对应成键态，哪个态对应反键态？

$$
\psi_{\boldsymbol{k},\mathrm{p_z}}(\boldsymbol{r})=\frac{1}{\sqrt{N}}\sum_m e^{i\boldsymbol{k}\cdot\boldsymbol{R_m}} \varphi_\mathrm{p_z}(\boldsymbol{r-R_m})
$$

$k_z=0$ 时，z 方向相邻原子 p 轨道符号相同，重叠积分为负，对应反键态。

$$
\psi_{\boldsymbol{k},\mathrm{p_z}}(\boldsymbol{r})=\frac{1}{\sqrt{N}}\sum_m e^{i(k_x R_{m,x}+k_y R_{m,y})} \varphi_\mathrm{p_z}(\boldsymbol{r-R_m})
$$

$k_z=\pi/a$ 时，z 方向相邻原子 p 轨道符号相反，重叠积分为正，对应成键态。

$$
\psi_{\boldsymbol{k},\mathrm{p_z}}(\boldsymbol{r})=\frac{1}{\sqrt{N}}\sum_m e^{i(k_x R_{m,x}+k_y R_{m,y})} \cdot (-1)^{R_{m,z}/a}\varphi_\mathrm{p_z}(\boldsymbol{r-R_m})
$$

## 5

> 写出求碳金刚石结构的 2s,2p 价电子形成的能带的试探波函数，赝的薛定谔方程，以及久期行列式。

# 19

## 1

> MoS<sub>2</sub> 不存在空间反演对称，且存在强烈的自旋轨道耦合。K 点自旋简并解除 （红色蓝色代表不同自旋）。但布里渊区中 M 点的自旋是简并的。对此现象加以理论证明。

![晶胞示意图](http://ww2.sinaimg.cn/large/006tNc79gy1g3co5m64rdj304n028q2q.jpg)

![Brillouin 区示意图](http://ww4.sinaimg.cn/large/006tNc79gy1g3co6tj5z2j303q030we9.jpg)

![对应于不同自旋的电子能级示意图](http://ww3.sinaimg.cn/large/006tNc79gy1g3co75u2lhj303102oq2q.jpg)

倒空间 ΓM 轴对应于实空间六边形对角线，沿该轴晶体存在 C<sub>2</sub> 对称性。对称操作后，角动量 $\vec l\to-\vec l$ ，但 Hamiltonian 中的自旋-轨道耦合项应该不变（对称操作不改变能量）：

$$
H_\mathrm{coupling}=\xi(r)\vec s\cdot \vec l
$$

因此必定有 $\vec s\to -\vec s$。因此

$$
E_{M,\alpha}=E_{M,\beta}
$$

反之，沿 ΓK 轴无 C<sub>2</sub> 对称性，故自旋不简并。

## 2

> 设有一维晶体的电子能带可以写成
> 
> $$
> E(k)=\frac{\hbar^2}{ma^2}\left( \frac{7}{8}-\cos ka+\frac{1}{8}\cos 2ka \right) 
> $$
> 
> 其中 $a$ 是晶格常数，试求电子在波矢 $k$ 状态的速度。

$$
v=\frac{1}{\hbar}\frac{\mathrm d E}{\mathrm d k}=\frac{\hbar^2}{ma} \left(\sin ka-\frac{1}{4}\sin 2ka \right) 
$$

## 3

> 一维近自由电子近似下，在布里渊边界的态，电子的速度是多少？为什么？

此题我认为助教给出的答案有问题。由书上 4-38 公式：

$$
E_-=\bar V+T_1-|V_1|-\Delta^2T_1 \left( \frac{2T_1}{|V_1|}-1 \right) 
$$

下分两种情况讨论：

在右边界 $k=\pi/a\times(1-\Delta)$，则

$$
\frac{\mathrm d E_-}{\mathrm d k}=-\frac{a}{\pi}\frac{\mathrm d E_-}{\mathrm d \Delta}=\frac{a }{\pi}\times 2\Delta  T_1 \left( \frac{2T_1}{|V_1|}-1 \right) 
$$

在左边界 $k=-\pi/a\times (1-\Delta)$，则

$$
\frac{\mathrm d E_-}{\mathrm d k}=\frac{a}{\pi}\frac{\mathrm d E_-}{\mathrm d \Delta}=-\frac{a }{\pi}\times 2\Delta  T_1 \left( \frac{2T_1}{|V_1|}-1 \right) 
$$

然后代入

$$
v=\frac{1}{\hbar}\frac{\mathrm d E_-}{\mathrm d k}
$$

即得。

# 20

## 1

> 倒空间和实空间的能带有何异同？

同：都是能量的分布情况，都会形成分裂的能级。

异：倒空间 $E-k$ 是周期函数，满足布洛赫定理；实空间 $E-x$ 是一条条分立的水平线（无外场的情况下）

## 2

> 在均匀电场下，电子的 $k$ 空间和实空间运动有何区别？

均匀电场下，电子在 $k$ 空间作匀速直线运动（或看作在 Brillouin 区循环），而在实空间作振荡运动。

## 3

> 晶格常数为 $2.5\times 10^{-10}\text{ m}$ 的一维晶格，当外加 $10^2\text{ V/m}$ 和 $10^7\text{ V/m}$ 时
，试估算电子自带底运动到带顶所需要的时间。


$$
t=\frac{\pi/a}{\frac{\mathrm d k}{\mathrm d t}}=\frac{\pi/a}{eE/\hbar}
$$

## 4

> 一维晶体，电子色散满足 $E(k) = \varepsilon_0-2J_1\cos ka$, $a$ 为晶格常数。在电场 $E_0$ 作用下，电子将振荡。设 $t=0, k=0$，且电子坐标 $z=0$，求任意时刻电子的坐标 $z(t)$。求出实空间的运动范围。

先求 $k$ 随时间的变化：

$$
\frac{\mathrm d k}{\mathrm d t}=\frac{eE_0}{\hbar},k=\frac{eE_0t}{\hbar}
$$

速度

$$
v(t)=\frac{1}{\hbar}\frac{\mathrm d E}{\mathrm d k}(t)=\frac{2aJ_1}{\hbar}\sin \frac{eE_0at}{\hbar}
$$

然后求坐标

$$
z(t)=\int_{0}^{t} v(\tau) \mathrm d \tau =\frac{2J_1}{eE_0}\left[ 1-\cos \frac{eE_0at}{\hbar} \right] 
$$

上述函数的极值

$$
z(0)=0,z \left( \frac{\pi\hbar}{eE_0a} \right)=\frac{4J_1}{eE_0} 
$$

# 21

## 1

> 能带中的电子，在电场 $E_0$ 作用下，遂穿到另外一个能带。 写出电子在禁带中所满足的薛定谔方程。


$$
\left[ -\frac{\hbar^2}{2m}\nabla^2+V(\vec r)-eE_0x \right] \psi(\vec r)=E\psi(\vec r)
$$

## 2

> 一维晶体，周期 $a$，s 轨道的能带，在布里渊区边界，是否是动量的本征态? 动量的平均值是多少？准动量是多少？


$$
E=E_0-J_0-2J_1\cos ka
$$

动量与 Hamiltonian 不对易，因此不是动量本征态。经典动量（这里有点问题，经典动量是否为动量平均值？）是

$$
p=mv=m\times \frac{1}{\hbar}2aJ_1\sin ka\to 0
$$

准动量是

$$
\hbar k=\frac{\hbar\pi}{a}
$$

## 3

> 能带中的电子在电场和磁场下都在做周期运动，这种说法正确么？

分情况讨论：

- 均匀电场下
  - $k$ 空间匀速运动（也可以认为是循环运动）
  - 实空间振荡
- 均匀磁场下
  - $k$ 空间匀速圆周运动
  - 实空间螺旋运动

## 4

> 对「电子在导带右边」「电子在价带右边」「空穴在价带右边」，分别指出每一种情况下的：
> 1. 实空间运动方向
> 2. $k$ 空间运动方向
> 3. 产生的电流方向
> 4. 在电场 $E$ 作用下，电流变化的方向。

### 实空间

$$
v=\frac{1}{\hbar}\frac{\mathrm d E}{\mathrm d k}
$$

- 电子在导带右边：向右
- 电子在价带右边：向左

### $k$ 空间

$$
\frac{\mathrm d k}{\mathrm d t}=\frac{1}{\hbar}\left( -eE \right) 
$$

- 电子在导带右边：向左
- 电子在价带右边：向左
- 空穴在价带右边：向左（因为电子向左）

### 电流

$$
I=-qv，空穴为 +qv
$$

- 电子在价带右边：向左
- 电子在导带右边：向右
- 空穴在价带右边：向左

### 电流变化

$$
\frac{\mathrm d I}{\mathrm d t}=\frac{q^2E}{m^*}，空穴为 -\frac{q^2E}{m^*}
$$

- 电子在价带右边：向右
- 电子在导带右边：向左
- 空穴在导带右边：向右

## 5

> 自由电子在磁场作用下，在实空间做螺旋运动。其回旋运动产生的轨道磁矩，与磁场方向一致否？是顺磁的还是抗磁的？

$$
\vec F=-q \vec v \times \vec B
$$

由上式计算，或由 Lenz 定律可直接判断出

也可用准经典运动的关系式求解，结果与上式一样。

# 22

## 1

> 假设镜面与 $z$ 轴垂直，角动量算符三个分量 $l_x, l_y, l_z$ 在此镜面下，怎么变？
> 
$$
\begin{array}{ccc}{x \rightarrow x,} & {y \rightarrow y,} & {z \rightarrow-z} \\ {p_{x} \rightarrow p_{x},} & {p_{y} \rightarrow p_{y},} & {p_{z} \rightarrow-p_{z}}\end{array}
$$

$$
\begin{array}{c}{L_{x}=y p_{z}-z p_{y} \rightarrow-L_{x}} \\ {L_{y}=z p_{x}-x p_{z} \rightarrow-L_{y}} \\ {L_{z}=x p_{y}-y p_{x} \rightarrow L_{z}}\end{array}
$$

## 2

> MoS<sub>2</sub> 的布里渊区，以 ΓM 为轴的 C<sub>2</sub> 转动，是否是对称操作？C<sub>2</sub> 作用于 K 点的波函数后，能量如何变？波函数如何变？自旋如何变？（考虑自旋轨道耦合）。提示角动量是个矢量。

由作业 19 类似题目中的分析，能量不变，自旋变号，而波函数的改变可以写作

$$
\psi_{\mathrm{k}}=e^{i \boldsymbol{k} \cdot \boldsymbol{r}} \left( \begin{array}{c}{u_{1 k}(\boldsymbol{r})} \\ {u_{2 k}(\boldsymbol{r})}\end{array}\right)
$$

$$
T(\alpha) \psi_{\mathrm{k}}=e^{i \boldsymbol{k} \cdot \alpha^{-1} \boldsymbol{r}} \left( \begin{array}{c}{u_{1 k}\left(\alpha^{-1} \boldsymbol{r}\right)} \\ {u_{2 k}\left(\alpha^{-1} \boldsymbol{r}\right)}\end{array}\right)
$$

## 3

> 在磁场存在的情况下，以黄昆书的第一种规范为例，证明 Hamiltonian 不存在时间反演不变性。

$$
H=\frac{1}{2 m}(\boldsymbol{p}+\boldsymbol{A} e)^{2}+V(\boldsymbol{r})
$$

时间反演

$$
\boldsymbol{p} \rightarrow-\boldsymbol{p} \quad \boldsymbol{r} \rightarrow \boldsymbol{r}
$$

故有变化。

当然，也可以证明 Hamiltonian 不实。

## 4

> 求解自由电子在均匀磁场中的运动，如采用第二种规范，问 $P_z$ 与 $L_z$ 是否与 Hamiltonian 对易？证明你的看法。

$$
\begin{aligned} \boldsymbol{H} &=\frac{1}{2 m}(\boldsymbol{p}+\boldsymbol{A} e)^{2} \\ &=\frac{1}{2 m}\left(p^{2}+2 e B L_{z}+\frac{e^{2} B^{2}}{4}\left(x^{2}+y^{2}\right)\right) \end{aligned}
$$

容易计算是对易的。

## 5

> 设电子等能面为椭球，外磁场 $\vec B$ 相对主轴的方向余弦为 $\alpha,\beta,\gamma$。 
> $$
> E(\vec k)=\frac{\hbar^2}{2}\left( \frac{k_1^2}{m_1}+\frac{k_2^2}{m_2}+\frac{k_3^2}{m_3} \right) 
> $$
> 试求：
> 
> 1. 电子准经典运动方程。
> 2. 证明电子绕磁场回转频率为 $\omega=eB/m^*$，其中
> $$
> m^*=\left( \frac{m_1\alpha^2+m_2\beta^2+m_3\gamma^2}{m_1m_2m_3} \right) ^{-1/2}
> $$
> 3. 求沿着三个主轴的有效质量。若等能面为旋转椭球（$m_1=m_2$），证明此时回旋共振有效质量回到书 5.5 节公式，其中 $\cos\theta=\gamma$。
> $$
> \frac{1}{m_{c}^{* 2}}=\frac{\cos ^{2} \theta}{m_{t}^{2}}+\frac{\sin ^{2} \theta}{m_{l}^{2}}
> $$

电子速度

$$
\vec v=\hbar \left( \frac{k_1}{m_1},\frac{k_2}{m_2},\frac{k_3}{m_3} \right) 
$$


$$
\frac{\mathrm d}{\mathrm d t}
\left(\begin{array}{c}
k_x\\k_y\\k_z
\end{array}\right)
=-e \vec v\times \vec B=eB
\left(\begin{array}{ccc}
0&-\gamma/m_2&\beta/m_3\\
\gamma/m_1&0&-\alpha/m_3\\
-\beta/m_1&\alpha/m_2&0
\end{array}\right)
$$

根据线性微分方程组的一般理论，求上述矩阵的一个特征值 $\lambda$ 和相应的特征向量 $\vec\xi$，则解可表为 $e^{\lambda t}\vec\xi$ 的形式。特征多项式

$$
\lambda \left( \lambda^2+\frac{m_1\alpha^2+m_2\beta^2+m_3\gamma^2}{m_1m_2m_3} \right) =0
$$

显然 $\lambda=0$ 是平凡解，故特征值为

$$
\lambda=i\omega=\pm i\left( \frac{m_1\alpha^2+m_2\beta^2+m_3\gamma^2}{m_1m_2m_3} \right) ^{1/2}
$$

因此

$$
m^*=\left( \frac{m_1\alpha^2+m_2\beta^2+m_3\gamma^2}{m_1m_2m_3} \right) ^{-1/2}
$$

沿三个主轴的有效质量，即在上式中分别取 $\alpha,\beta,\gamma=1$：

- 沿 1 轴：$m_1^*=\sqrt{m_2m_3}$
- 沿 2 轴：$m_2^*=\sqrt{m_1m_3}$
- 沿 3 轴：$m_3^*=\sqrt{m_1m_2}$

若为旋转椭球，在上式中取 $m_1=m_2$，$\alpha^2+\beta^2=\cos^2\theta$ ，即得

$$
m^*=\left( \frac{m_1\cos^2\theta+m_3\sin^2\theta}{m_1^2m_3} \right) ^{-1/2}
$$

即

$$
\frac{1}{m_c^{*2}} =\frac{\cos^2\theta}{m_1m_3}+\frac{\sin^2\theta}{m_1^2}
$$

此时沿 $t$ 轴（即 1 轴或 2 轴）有效质量为 $\sqrt{m_1m_3}$，沿 $l$ 轴（即 3 轴）有效质量为 $\sqrt{m_1m_1}=m_1$，化简上式为

$$
\frac{1}{m_{c}^{* 2}}=\frac{\cos ^{2} \theta}{m_{t}^{2}}+\frac{\sin ^{2} \theta}{m_{l}^{2}}
$$

## 6

> 上述公式与基泰尔书 143 页公式（34）不同，原因何在？

基泰尔书上定义沿 $t$ 轴有效质量为 $m_1$，沿 $l$ 轴有效质量为 $m_3$，所以当然有

$$
\frac{1}{m_c^{*2}} =\frac{\cos^2\theta}{m_1m_3}+\frac{\sin^2\theta}{m_1^2}
$$

# 23

## 1

> MoS<sub>2</sub> 的能带，说明为什么在 ΓM 上的点自旋总是简并的。设自旋垂直于 MoS<sub>2</sub> 平面。

在 19.1 中已有。

## 2

> 试证在磁场中运动的 Bloch 电子，在 $k$ 空间中轨迹面积 $S_n$ 和在实空间的轨迹面积 $A_n$ 之间的关系为：
> $$
> A_n=\left( \frac{\hbar}{qB} \right) ^2S_n
> $$

准经典运动方程

$$
\hbar \frac{\mathrm d \vec k}{\mathrm d t}=-q \frac{\mathrm d \vec r }{\mathrm d t}\times \vec B
$$

不失一般性，假定 $\vec k(0)=\vec r(0)=0$ ，则

$$
h\vec k=-q\vec r\times \vec B
$$

即

$$
\begin{aligned}
&-\frac{\hbar}{qB} k_x=y\\
&+\frac{\hbar}{qB} k_y=x
\end{aligned}
$$

雅可比行列式

$$
A_n= \iint_D \mathrm d x \mathrm d y=\iint_D \left|\frac{D(x,y)}{D(k_x,k_y)}\right|\mathrm d k_x \mathrm d k_y=\left( \frac{\hbar}{qB} \right) ^2S_n
$$

## 3

> 1. 根据自由电子模型计算钾的德·哈斯-范·阿尔芬效应的周期 $\Delta B^{-1}$。
> 2. 对于 $B=1T$，在实空间中电子运动轨迹的面积有多大？

$$
\Delta \left( \frac{1}{B} \right) =\frac{2\pi q}{\hbar S_F}=\frac{2q}{\hbar k_F^2}
$$

Fermi 球体积乘以倒空间态密度是电子数：

$$
N=2\times \frac{V }{(2\pi)^3}\times \frac{4}{3}k_F^3
$$

因此 $k_F=(3\pi^2n)^{1/3}$，代入即得。

第二问可用前一题的公式。

## 4

> 有一二维金属，有效质量 $m^*=2m_0$ ，考虑电子自旋造成的 Zeeman 效应后，Landau 能级的简并情况如何？画出前 3 个 Landau 能级的分裂情况。


$$
E_n=\left( n+\frac{1}{2} \right) \hbar \omega_0
$$

自旋 Zeeman 效应造成的能级裂分

$$
E_\pm=\pm \frac{eB\hbar}{2m_0}=\pm\hbar\omega_0
$$

因此除前两能级简并度折半外，其余能级简并度不变。

![](http://ww4.sinaimg.cn/large/006tNc79gy1g3csxa3qvkj30hv0gpq3h.jpg)

能隙为 $\hbar\omega_0$ 。

# 24

## 1

> 二维拓扑绝缘体的表面，若有一个向右的动量为 $k$ 自旋朝上的边缘态，为什么一定会有一个向左的动量为 $-k$ 的自旋朝下的边缘态？而在加磁场的二维电子气中，若有一个向右的动量为 $k$ 自旋朝上的边缘态，为何不存在一个向左的动量为 $-k$ 自旋朝下的边缘态？

前者有时间反演对称性，后者无。

## 2

> 在第六章说明热电子发射用的势阱模型中，总能量越高，电子的动能越高还是越低？
> 
> 而在普通中心库伦势下（如 H 原子），总能量越高，电子的动能越高还是越低?（提示用维利定理）。黄昆书4-4节（187页），说越是外层的电子波函数的波长越短，动能越大，是否正确？

势阱模型下，电子在势阱中势能是不变的，所以总能越高，动能越高。

中心库仑势下，由位力定理：

$$
E=T+V=-T
$$

总能量越高，动能越低。故外层电子总能大，动能小，不正确。

## 3

> 证明在恒定电场 $E$ 磁场 $B$ 下，晶体场中电子它的准动量 $k$，满足
> $$
> \nabla_k\cdot \frac{\mathrm d \vec k}{\mathrm d t}=0
> $$


$$
\nabla_k\cdot \frac{\mathrm d \vec k}{\mathrm d t}=\nabla_k\cdot \left[ \frac{1}{\hbar}\left( -e \vec E-e \vec v\times \vec B \right)  \right] =\nabla_k\cdot \vec v\times \vec B=-\frac{q}{\hbar}\vec B\cdot \nabla_k\times \nabla_kE(\vec k)=0
$$

