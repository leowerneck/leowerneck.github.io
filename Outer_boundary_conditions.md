---
layout: notes
title: Outer boundary conditions
mathjax: true
pdfpath: '/assets/Notes/Outer_boundary_conditions.pdf'
---

<a id='ToC'></a>
# Table of Contents

* [**Outer boundary conditions**](#BdryCond)
  * [*Inner vs outer boundary conditions*](#BdryCond_Inner_vs_Outer)
  * [*Common outer boundary conditions*](#BdryCond_Common)
    * [Dirichlet boundary conditions](#BdryCond_Dirichlet)
    * [Neumann boundary conditions](#BdryCond_Neumann)
    * [Robin boundary conditions](#BdryCond_Robin)
  * [*Implementation*](#BdryCond_Implementation)
    * [The general case](#BdryCond_General_Algorithm)
    * [Special case: Dirichlet](#BdryCond_Dirichlet_Algorithm)

<a name='BdryCond'></a>
# Outer boundary conditions \[Back to [ToC](#ToC)\]

Applying outer boundary conditions is a necessary task when solving [partial differential equations](https://en.wikipedia.org/wiki/Partial_differential_equation) (PDEs). In scenarios of physical interest, we generally consider PDEs that evolve a certain quantity in time and space. When solving PDEs on the computer, we must inevitably focus our attention to a finite region of space, which we denote *the computational domain*.

Outer boundary conditions reflect the fact that we must restrict our attention to a finite region, thus introducing *artificial boundaries* into the problem. A wave propagating along the $x$-direction will do so forever, but if one studies this wave in a finite region of space, say $x\in[0,L]$, then the wave will interact with the boundaries at $x=0$ and $x=L$, causing, for example, undesirable reflections.

The reason why we refer to these boundary conditions as *outer* is the following: we generally consider a numerical grid with $N+1$ discretization points. This grid, which is where we are interested in obtaining the solution, is refered to as the ***interior grid***. However, say we are solving the problem:

$$
\partial_{t}f(t,x) = \partial_{x}f(t,x)\ .
$$

If we approximate the spatial derivatives using, say, second-order centered [finite differences](Finite_differences.md), then we would have

$$
\partial_{t}f^{n}_{i} = \frac{f^{n}_{i+1} - f^{n}_{i-1}}{2\Delta x}\ ,
$$

where the notation $f^{n}\_{i} \equiv f\left(t\_{0} + n\cdot\Delta t,x\_{0}+i\cdot\Delta x\right)$ and $\Delta t$ and $\Delta x$ are the step sizes in the $t$ and $x$-directions respectively. Now, assuming that the computational grid contains $N_{x}+1$ spatial discretization points, i.e. $i=0,\ldots,N_{x}$, then we run into problems when evaluating

$$
\begin{align}
\partial_{t}f^{n}_{0} &= \frac{f^{n}_{1} - f^{n}_{-1}}{2\Delta x}\ ,\\
\partial_{t}f^{n}_{N_{x}} &= \frac{f^{n}_{N_{x}+1} - f^{n}_{N_{x}-1}}{2\Delta x}\ .
\end{align}
$$

Notice that the values of $f$ at the points $f^{n}\_{0}$ and $f^{n}\_{N\_{x}}$ are legitimate, in the sense that they are part of the *interior* grid. However, evaluation of the right-hand side of the evolution equation of $f$ at those points requires that we have information of the function $f$ at the points $f^{n}\_{-1}$ and $f^{n}\_{N\_{x}+1}$, which are ***not*** part of the interior grid.

The points $i=-1$ and $i=N_{x}+1$ can then be introduced artificially into the problem, so that we are able to use our numerical scheme to evaluate all interior grid points. Since these points do not belong to the interior grid they are refered to as ***exterior (outer) grid points*** or ***ghostzones***. Outer boundary conditions are thus responsible for specifying the behaviour of the function at the ghostzones. The combination of interior and exterior grids form the computational domain.

As a final comment, we note that the number of ghostzones is scheme dependent. For example, a fourth-order centered [finite differences](Finite_differences.md) would lead to the equation

$$
\partial_{t}f^{n}_{i} = \frac{-f^{n}_{i+2} + 8f^{n}_{i+1} - 8f^{n}_{i-1} + f^{n}_{i-2}}{12\Delta x}\ ,
$$

which would then require knowledge of the points $i=\left\\{-2,-1,N_{x}+1,N_{x}+2\right\\}$, in contrast with the second-order scheme that only requires the points $i=\left\\{-1,N_{x}+1\right\\}$. When we have more than one ghostzone at each outer boundary, it is sometimes not clear how to handle the boundary conditions, but we will get to that later.

<a name='BdryCond_Inner_vs_Outer'></a>
## Inner vs outer boundary conditions \[Back to [ToC](#ToC)\]

When applying boundary conditions, we must distinguish between *inner* boundary conditions vs *outer* boundary conditions. In short, inner boundary conditions are applied to points that belong to the *interior grid*, while outer boundary conditions are applied to points that belong to the *exterior grid*.

The simplest example of this is found in [polar coordinates](https://en.wikipedia.org/wiki/Polar_coordinate_system). Let a function $f$ depend on time and the two polar variables $\left(\rho,\theta\right)$, related to the Cartesian variables $(x,y)$ via the standard relations

$$
\begin{align}
x &= \rho\cos\theta\ ,\\
y &= \rho\sin\theta\ .
\end{align}
$$

Let us introduce the notation

$$
f\left(t_{0}+n\cdot\Delta t,\rho_{0}+i\cdot\Delta\rho,\theta_{0}+j\cdot\Delta\theta\right) \equiv f^{n}_{i,j}\ .
$$

Then, returning to our previous example of central finite differences, we run intro trouble when evaluating

$$
\begin{align}
\partial_{t}f^{n}_{0,j} &= \frac{f^{n}_{1,j} - f^{n}_{-1,j}}{2\Delta x}\ ,\\
\partial_{t}f^{n}_{N_{\rho},j} &= \frac{f^{n}_{N_{\rho}+1,j} - f^{n}_{N_{\rho}-1,j}}{2\Delta x}\ .
\end{align}
$$

However, in this coordinate system the points $i=-1$ *do not belong to the exterior grid*. This is a direct consequence of the fact that, in polar coordinates,

$$
f\left(-\rho,\theta\right) = f\left(\rho,\theta+\frac{\pi}{2}\right)\ .
$$

Thus, the way to handle the points with $i=-1$ is actually to impose *inner boundary conditions*, as described by the last equation. The points with $i=N_{\rho}+1$, however, *do belong to the exterior grid*, and therefore must be handled by imposing outer boundary conditions.

<a name='BdryCond_Common'></a>
## Common outer boundary conditions \[Back to [ToC](#ToC)\]

We will now discuss the three common boundary conditions: [Dirichlet](https://en.wikipedia.org/wiki/Dirichlet_boundary_condition), [Neumann](https://en.wikipedia.org/wiki/Neumann_boundary_condition), and [Robin](https://en.wikipedia.org/wiki/Robin_boundary_condition).

<a name='BdryCond_Dirichlet'></a>
### Dirichlet boundary conditions \[Back to [ToC](#ToC)\]

[Dirichlet boundary conditions](https://en.wikipedia.org/wiki/Dirichlet_boundary_condition) specify *the function itself* at the ghostzones. For example, in 1 spatial dimension, using a *Cartesian grid* (i.e. a numerical grid that assumes Cartesian coordinates), with 1 ghostzone in each outer boundary, we would have

$$
f^{n}_{-1} = \alpha\ ,\ f^{n}_{N_{x}+1} = \beta\ ,
$$

where $\alpha$ and $\beta$ are constants. If we allow for ghostzones in the other spatial directions as well, e.g. $j=\left\\{-1,N_{y}+1\right\\}$ along the $y$-direction and $k=\left\\{-1,N_{z}+1\right\\}$ along the $z$-direction, and assuming a single condition $\left(f^{n}\_{i,j,k}\right)\_{\rm ghostzone} = \alpha$, we would need to impose the following conditions:

|    $i$    |    $j$    |    $k$    | $f^{n}_{i,j,k}$ |
|:---------:|:---------:|:---------:|:---------------:|
|    $-1$   |    All    |    All    |    $\alpha$     |
| $N_{x}+1$ |    All    |    All    |    $\alpha$     |
|    All    |    $-1$   |    All    |    $\alpha$     |
|    All    | $N_{y}+1$ |    All    |    $\alpha$     |
|    All    |    All    |    $-1$   |    $\alpha$     |
|    All    |    All    | $N_{z}+1$ |    $\alpha$     |

Dirichlet boundary conditions do not completely populate the ghostzones when the number of ghostzones in each outer boundary is greater than one. The reason for this is that we usually wish to impose Dirichlet boundary conditions at the outermost point of the computational grid, not at every ghostzone point. Returning to one spatial dimension example, if we have $3$ ghostzones in each boundary, we would have the following:


|    $i$    | $f^{n}_{i}$ |
|:---------:|:-----------:|
|   $-3$    |  $\alpha$   |
|   $-2$    |  $  ??  $   |
|   $-1$    |  $  ??  $   |
| $N_{x}+1$ |  $  ??  $   |
| $N_{x}+2$ |  $  ??  $   |
| $N_{x}+3$ |  $\alpha$   |

Handling the other ghostzones would require additional work, either by resorting to [interpolating](https://en.wikipedia.org/wiki/Interpolation) or [extrapolating](https://en.wikipedia.org/wiki/Extrapolation) the function at those points or by adjusting the integration scheme to use, for example, [backwards or forwards finite differences](Finite_differences.md).

<a name='BdryCond_Neumann'></a>
### Neumann boundary conditions \[Back to [ToC](#ToC)\]

[Neumann boundary conditions](https://en.wikipedia.org/wiki/Neumann_boundary_condition) specify the *derivative* of the function at the ghostzones, e.g.

$$
\partial_{n}f = \alpha\ ,
$$

with $\alpha$ a constant and $\partial_{n}$ indicate the derivative along the direction which is normal to the boundary. Imposing this condition when more ghostzones are present is relatively straightforward as well, though one must sometimes switch to using [centered/backwards/forwards finite differences](Finite_differences.md). For example, consider the differential equation

$$
\partial_{t}f = -v\partial_{x}f\ ,
$$

where $v$ is a positive constant.

<a name='BdryCond_Robin'></a>
### Robin boundary conditions \[Back to [ToC](#ToC)\]

[Robin boundary conditions](https://en.wikipedia.org/wiki/Robin_boundary_condition) specify a comobination of the *function* and its *derivative*, at the ghostzones, e.g.

$$
\alpha f + \beta \partial_{n}f = \gamma\ ,
$$

with $\alpha$, $\beta$, and $\gamma$ constants and $\partial_{n}$ indicate the derivative along the direction which is normal to the boundary. Imposing this condition when more ghostzones are present is relatively straightforward as well, though one must sometimes switch to using [centered/backwards/forwards finite differences](Finite_differences.md).

A common use of Robin boundary conditions is when we know the asymptotic behaviour of the function at the outer boundary. For example, assume that we know that $f(r)\sim\frac{1}{r}$ at the outer boundary $r=R_{\rm outer}$. Then, it must be true that

$$
\left.\partial_{r}\left[rf(r)\right]\right|_{r=R_{\rm outer}} = 0\ .
$$

This is the Robin boundary condition

$$
f\left(R_{\rm outer}\right) + R_{\rm outer}\left.\partial_{r}f\right|_{R_{\rm outer}} = 0\ ,
$$

with $\alpha=1$, $\beta = R_{\rm outer}$, and $\gamma=0$. Here, the direction normal to the outer boundary is the $r$-direction.
