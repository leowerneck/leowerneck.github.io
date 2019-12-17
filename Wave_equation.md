---
layout: notes
title: Wave Equation
mathjax: true
---

<a name='ToC'>
# Table of Contents

* [**The Wave Equation**](#WaveEquation)
  * [*Solving the wave equation in 1 spatial dimension*](#Wave1D)
    * [Finite differences approach](#Wave1DFD)

<a name='WaveEquation'>
# The Wave Equation \[Back to [ToC](#ToC)\]

Here we will explore the [wave equation](https://en.wikipedia.org/wiki/Wave_equation){:target="_blank"} and discuss how to solve it in the computer. For the sake of this discussion, we will be using the [C programming language](https://en.wikipedia.org/wiki/C_(programming_language)){:target="_blank"}.

For a given function $u(t,\vec{x})$, where $\vec{x}=(x,y,z)$, the *wave equation* is given by

$$
\partial_{t}^{2}u(t,\vec{x}) = c^{2}\nabla^{2}u(t,\vec{x})\ ,
$$

where $\nabla^{2}$ is the Laplacian operator, which in Cartesian coordinates reads

$$
\nabla^{2} = \partial_{x}^{2} + \partial_{y}^{2} + \partial_{z}^{2}\ .
$$

Above we have used the fairly standard notation:

$$
\partial_{t} \equiv \frac{\partial}{\partial t}\ ,\quad \partial_{t}^{2} \equiv \frac{\partial}{\partial t^{2}}\ , \quad \text{etc}\ .
$$

<a name='Wave1D'>
## Solving the wave equation in 1 spatial dimension using finite differences \[Back to [ToC](#ToC)\]

We will start studying the wave equation by focusing on the simplest case, the 1D wave equation. Considering that the one spatial dimension is the $x$-direction, we have

$$
\partial_{t}^{2}u(t,x) = \partial_{x}^{2}u(t,x)\ .
$$

A standard technique when dealing with an equation like this is to define a new auxiliary function

$$
v(t,x) \equiv \partial_{t}u(t,x)\ ,
$$

so that we trade one second-order differential equation by a system of coupled, first-order differential equations:

$$
\begin{align}
\partial_{t}u(t,x) &= v(t,x)\ ,\\
\partial_{t}v(t,x) &= \partial_{x}^{2}u(t,x)\ .
\end{align}
$$

One could go further and simplify the Laplacian operator by introducing yet another new auxiliary function $w(t,x)\equiv\partial_{x}u(t,x)$, but we won't do that for now. We will use second-order, centered [finite differences](https://en.wikipedia.org/wiki/Finite_difference) to solve this problem. Finite differences approximations to the derivatives are thus found by considering the [Taylor series](https://en.wikipedia.org/wiki/Taylor_series) of the function $f(t,x)$:

$$
\begin{align}
f(t-\Delta t,x) &= f(t,x) - \Delta t \partial_{t}f(t,x) + \frac{\Delta t^{2}}{2!}\partial_{t}^{2}f(t,x) - \frac{\Delta t^{3}}{3!}\partial_{t}^{3}f(t,x) +  \mathcal{O}\left(\Delta t^{4}\right)\ ,\\
f(t,x)          &= f(t,x)\ ,\\
f(t+\Delta t,x) &= f(t,x) + \Delta t \partial_{t}f(t,x) + \frac{\Delta t^{2}}{2!}\partial_{t}^{2}f(t,x) + \frac{\Delta t^{3}}{3!}\partial_{t}^{3}f(t,x) + \mathcal{O}\left(\Delta t^{4}\right)\ .
\end{align}
$$

For example, subtracting the first expression from the third, we target

$$
\begin{align}
f(t+\Delta t,x) - f(t-\Delta t,x) = 2 \Delta t \partial_{t}f(t,x) &+ \mathcal{O}\left(\Delta t^{3}\right)\\
\implies \partial_{t}f(t,x) = \frac{f(t+\Delta t,x) - f(t-\Delta t,x)}{2 \Delta} &+ \mathcal{O}\left(\Delta t^{2}\right)\ .
\end{align}
$$

On the other hand, subtracing 2 times the second expression from the third and adding the first to it results in

$$
\begin{align}
f(t+\Delta t,x) - 2f(t,x) + f(t-\Delta t,x) = \Delta t^{2}\partial_{t}^{2}f(t,x) &+ \mathcal{O}\left(\Delta t^{4}\right)\\
\implies \partial_{t}^{2}f(t,x) = \frac{f(t+\Delta t,x) - 2f(t,x) + f(t-\Delta t,x)}{\Delta t^{2}} &+ \mathcal{O}\left(\Delta t^{2}\right)\ .
\end{align}
$$

The derivation for the spatial derivatives are completely analogous and can be easily found by simply changing $t\leftrightarrow x$ on the derivations above. Introducing the notation

$$
f\left(n\cdot\Delta t,i\cdot\Delta x\right) \equiv f^{n}_{i}\ ,
$$

we have

$$
\begin{align}
\partial_{t}f^{n}_{i}     &= \frac{f^{n+1}_{i}-f^{n-1}_{i}}{2\Delta t}           \ ,\\
\partial_{x}f^{n}_{i}     &= \frac{f^{n}_{i+1}-f^{n}_{i-1}}{2\Delta t}           \ ,\\
\partial_{x}^{2}f^{n}_{i} &= \frac{f^{n}_{i+1}-2f^{n}_{i}+f^{n}_{i-1}}{\Delta x^{2}}\ ,
\end{align}
$$

which allow us to write down the wave equation as

$$
\begin{align}
\frac{u^{n+1}_{i}-u^{n-1}_{i}}{2\Delta t} &= v^{n}_{i}\ ,\\
\frac{v^{n+1}_{i}-v^{n-1}_{i}}{2\Delta t} &= \frac{u^{n}_{i+1}-2u^{n}_{i}+u^{n}_{i-1}}{\Delta x^{2}}\ ,
\end{align}
$$

leading to the iterative relations

$$
\boxed{
\begin{align}
u^{n+1}_{i} &= u^{n-1}_{i} + 2\Delta t v^{n}_{i}\\
v^{n+1}_{i} &= v^{n-1}_{i} + \frac{2\Delta t}{\Delta x^{2}}\left(u^{n}_{i+1}-2u^{n}_{i}+u^{n}_{i-1}\right)
\end{align}
}\ .
$$

### \[Back to [ToC](#ToC)\]
