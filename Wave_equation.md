---
layout: notes
title: Wave Equation
mathjax: true
---

<a id='ToC'></a>

# Table of Contents

* [**The Wave Equation**](#WaveEquation)
  * [*Solving the wave equation in Cartesian coordinates*](#WaveEq)
      * [The evolution equations](#WaveEq_Evolution_Equations)
      * [The initial data problem](#WaveEq_Initial_Data)
      * [Outer boundary conditions](#WaveEq_Outer_Boundary)

<a name='WaveEquation'></a>
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

<a name='WaveEq'></a>
## Solving the wave equation in 1-dimensional Cartesian coordinates using finite differences \[Back to [ToC](#ToC)\]

We will start studying the wave equation by focusing on the simplest case, the 1D wave equation. Considering that the one spatial dimension is the $x$-direction, we have

$$
\partial_{t}^{2}u(t,x) = c^{2}\partial_{x}^{2}u(t,x)\ .
$$

A standard technique when dealing with an equation like this is to define a new auxiliary function

$$
v(t,x) \equiv \partial_{t}u(t,x)\ ,
$$

so that we trade one second-order differential equation by a system of coupled, first-order differential equations:

$$
\begin{align}
\partial_{t}u(t,x) &= v(t,x)\ ,\\
\partial_{t}v(t,x) &= c^{2}\partial_{x}^{2}u(t,x)\ .
\end{align}
$$

One could go further and simplify the Laplacian operator by introducing yet another new auxiliary function $w_{x}(t,x)\equiv\partial_{x}u(t,x)$, but we won't do that for now.


<a name='WaveEq_Evolution_Equations'></a>
### The evolution equations \[Back to [ToC](#ToC)\]

We will use second-order, centered [finite differences](Finite_differences.md){:target="_blank"} to solve this problem. Introducing the notation

$$
f\left(n\cdot\Delta t,i\cdot\Delta x\right) \equiv f^{n}_{i}\ ,
$$

we have thus the approximations

$$
\begin{align}
\partial_{t}f^{n}_{i}     &= \frac{f^{n+1}_{i}-f^{n-1}_{i}}{2\Delta t}           \ ,\\
\partial_{x}f^{n}_{i}     &= \frac{f^{n}_{i+1}-f^{n}_{i-1}}{2\Delta x}           \ ,\\
\partial_{x}^{2}f^{n}_{i} &= \frac{f^{n}_{i+1}-2f^{n}_{i}+f^{n}_{i-1}}{\Delta x^{2}}\ ,
\end{align}
$$

which allow us to write down the wave equation as

$$
\begin{align}
\frac{u^{n+1}_{i}-u^{n-1}_{i}}{2\Delta t} &= v^{n}_{i}\ ,\\
\frac{v^{n+1}_{i}-v^{n-1}_{i}}{2\Delta t} &= c^{2}\frac{u^{n}_{i+1}-2u^{n}_{i}+u^{n}_{i-1}}{\Delta x^{2}}\ ,
\end{align}
$$

leading to the iterative relations

$$
\boxed{
\begin{align}
u^{n+1}_{i} &= u^{n-1}_{i} + 2\Delta t v^{n}_{i}\\
v^{n+1}_{i} &= v^{n-1}_{i} + \frac{2c^{2}\Delta t}{\Delta x^{2}}\left(u^{n}_{i+1}-2u^{n}_{i}+u^{n}_{i-1}\right)
\end{align}
}\ .
$$

<a name='WaveEq_Initial_Data'></a>
### The initial data problem  \[Back to [ToC](#ToC)\]

As can be seen from the boxed equation above, this is a scheme that involves *three time levels*, since the left-hand sides (LHS) are terms that depend on the time level $n+1$, while the right-hand sides (RHS) contain terms on the time levels $n-1$ and $n$.

The wave equation is a second-order differential equation, so it is indeed expected that we provide *two* initial conditions in order to specify a solution. Say we wish to specify the initial conditions $u(0,x) = C$ and $\partial_{t}u(0,x) = v(0,x) = 0$. These are easily implemented using

$$
\begin{align}
u_{i}^{0} &= C\ ,\\
v_{i}^{0} &= 0\ .
\end{align}
$$

This is all very well, but now how do we evolve the system in time? We currently have access to $\left(u^{0}_{i},v^{0}_{i}\right)$, but if we use our evolution equations with $n=1$, we will need to have access to $\left(u^{1}_{i},v^{1}_{i}\right)$ *before* we can compute $\left(u^{2}_{i},v^{2}_{i}\right)$. Obtaining $\left(u^{1}_{i},v^{1}_{i}\right)$ then becomes a crucial part of the initial data specification known as the *initial data problem*.

To make it clear, when the user specify $\left(u^{0}_{i},v^{0}_{i}\right)$ we are giving the *initial conditions* required by the differential equation. However, due to our choice of numerical scheme, a different, *artificial* initial condition is also required, that is $\left(u^{1}_{i},v^{1}_{i}\right)$. The combination of these two initial conditions is referred to as the *initial data*.

A common trick to obtain this initial data is the following. Consider a *half-step forward* iteration

$$
\begin{align}
\partial_{t}u^{n+\frac{1}{2}}_{i} &= \frac{u^{n+\frac{1}{2}}_{i} - u^{n}_{i}}{\Delta t/2} = v^{n}_{i}\ ,\\
\partial_{t}v^{n+\frac{1}{2}}_{i} &= \frac{v^{n+\frac{1}{2}}_{i} - v^{n}_{i}}{\Delta t/2} = \frac{c^{2}}{\Delta x^{2}}\left(u^{n}_{i+1}-2u^{n}_{i}+u^{n}_{i-1}\right)\ ,
\end{align}
$$

followed by a *half-step* centered iteration

$$
\begin{align}
\partial_{t}u^{n+\frac{1}{2}}_{i} &= \frac{u^{n+1}_{i} - u^{n}_{i}}{\Delta t} = v^{n+\frac{1}{2}}_{i}\ ,\\
\partial_{t}v^{n+\frac{1}{2}}_{i} &= \frac{v^{n+1}_{i} - v^{n}_{i}}{\Delta t} = \frac{c^{2}}{\Delta x^{2}}\left(u^{n+\frac{1}{2}}_{i+1}-2u^{n+\frac{1}{2}}_{i}+u^{n+\frac{1}{2}}_{i-1}\right)\ .
\end{align}
$$

Noticed that these derivatives are centered at the $n+\frac{1}{2}$ point, as opposed to the usual $n$. Thus, to obtain initial data we use the following algorithm (assuming $n=0$ corresponds to the initial data level)

$$
\boxed{
\begin{align}
u^{\frac{1}{2}}_{i} &= u^{0}_{i} + \frac{\Delta t}{2}v^{0}_{i}\\
v^{\frac{1}{2}}_{i} &= v^{0}_{i} + \frac{c^{2}\Delta t}{2\Delta x^{2}}\left(u^{0}_{i+1}-2u^{0}_{i}+u^{0}_{i-1}\right)\\
u^{1}_{i} &= u^{0}_{i} + \Delta t v^{\frac{1}{2}}_{i}\\
v^{1}_{i} &= v^{0}_{i} + \frac{c^{2}\Delta t}{\Delta x^{2}}\left(u^{\frac{1}{2}}_{i+1}-2u^{\frac{1}{2}}_{i}+u^{\frac{1}{2}}_{i-1}\right)
\end{align}
}\ .
$$

<a name='WaveEq_Outer_Boundary'></a>
### Outer boundary conditions  \[Back to [ToC](#ToC)\]


### \[Back to [ToC](#ToC)\]
