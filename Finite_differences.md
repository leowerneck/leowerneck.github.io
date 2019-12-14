---
layout: notes
title: Finite Differences
mathjax: true
---

<a name='ToC'>
# Table of Contents

* [**Finite differences**](#FD)
  * [*Forward, backwards, and centered finite differences*](#FDTypes)
  * [*Determining finite differences expressions*](#FDTaylor)
    * [Second order, forward finite difference](#FFD)
    * [Second order, backward finite difference](#BFD)
    * [Second order, centered finite difference](#CFD)
  * [*Index notation*](#FDIndex)
  * [*A practical way of computing finite difference coefficients*](#FDPractical)

<a name="FD">
# Finite differences

[Finite differences](https://en.wikipedia.org/wiki/Finite_difference){:target="_blank"} are approximations to the derivatives of functions that we can use to solve differential equations. Instead of considering the exact definition

$$
\frac{df}{dx} = \lim_{dx\to0}\frac{f(x+dx) - f(x)}{dx}\ ,
$$

we could, for example, not assume that $dx$ is infinitesimal and instead simply consider the *finite difference approximation*

$$
\frac{df}{dx} \approx \frac{f(x+dx) - f(x)}{dx}\ .
$$

Now while this is quite an intuitive way of thinking about finite differences, there are more systematic ways of obtaining derivatives of functions that are accurate to different orders in $dx$. In the following sections we will discuss them in more detail.

<a name="FDTypes">
## Forward, backwards, and centered finite differences

Remember that there are three, equivalent ways of writing the derivative definition we have shown above. These are

\begin{align}
\frac{df}{dx} &= \lim_{\Delta x\to0}\frac{f(x+\Delta x) - f(x)}{\Delta x}    \ ,\\
\frac{df}{dx} &= \lim_{\Delta x\to0}\frac{f(x)    - f(x-\Delta x)}{\Delta x} \ ,\\
\frac{df}{dx} &= \lim_{\Delta x\to0}\frac{f(x+\Delta x) - f(x-dx)}{2\Delta x}\ .
\end{align}

Each of these expressions yield a different kind of finite difference approximation to the derivative of $f(x)$, that is

\begin{align}
\frac{df}{dx} &\approx \frac{f(x+\Delta x) - f(x)}{\Delta x}    \ ,\\
\frac{df}{dx} &\approx \frac{f(x)    - f(x-\Delta x)}{\Delta x} \ ,\\
\frac{df}{dx} &\approx \frac{f(x+\Delta x) - f(x-\Delta x)}{2\Delta x}\ .
\end{align}

In the first equation above we compute the derivative of $f(x)$ by considering the points $\big(f(x),f(x+\Delta x)\big)$. Because of the nature of the approximation to use points that are further *up* the $x$-direction, this is called a ***forward finite difference approximation***.

Similarly, the second equation above is used to compute the derivative of $f(x)$ by considering the points $\big(f(x-dx),f(x)\big)$. Because of the nature of the approximation to use points that are further *down* the $x$-direction, this is called a ***backwards finite difference approximation***.

Finally, the third equation above computes the derivative of $f(x)$ by considering the points $\big(f(x-dx),f(x+dx)\big)$. Quite appropriately, this is referred to as ***centered finite difference approximation***.

<a name="FDTaylor">
## Determining finite differences expressions

Let us now present a more systematic way of determining the finite difference approximation to the derivative of a function $f(t,x)$. We will choose a function of 2 variables on purpose, because it then becomes trivial to understand the algorithm for functions of even more variables. In the derivations below, the single variable case can be obtained by simplying supressing the variable $x$ altogether.

Consider the [Taylor series](https://en.wikipedia.org/wiki/Taylor_series){:target="_blank"} of the function $f(t,x)$ around different points, strategically chosen:

$$
\begin{align}
f(t-3\Delta t,x) &= f(t,x) - 3\Delta t \partial_{t}f(t,x) + \frac{\left(3\Delta t\right)^{2}}{2!}\partial_{t}^{2}f(t,x) - \frac{\left(3\Delta t\right)^{3}}{3!}\partial_{t}^{3}f(t,x) +  \mathcal{O}\left(\Delta t^{4}\right)\ ,\\
f(t-2\Delta t,x) &= f(t,x) - 2\Delta t \partial_{t}f(t,x) + \frac{\left(2\Delta t\right)^{2}}{2!}\partial_{t}^{2}f(t,x) - \frac{\left(2\Delta t\right)^{3}}{3!}\partial_{t}^{3}f(t,x) +  \mathcal{O}\left(\Delta t^{4}\right)\ ,\\
f(t-\Delta t,x) &= f(t,x) - \Delta t \partial_{t}f(t,x) + \frac{\Delta t^{2}}{2!}\partial_{t}^{2}f(t,x) - \frac{\Delta t^{3}}{3!}\partial_{t}^{3}f(t,x) +  \mathcal{O}\left(\Delta t^{4}\right)\ ,\\
f(t+\Delta t,x) &= f(t,x) + \Delta t \partial_{t}f(t,x) + \frac{\Delta t^{2}}{2!}\partial_{t}^{2}f(t,x) + \frac{\Delta t^{3}}{3!}\partial_{t}^{3}f(t,x) + \mathcal{O}\left(\Delta t^{4}\right)\ ,\\
f(t+2\Delta t,x) &= f(t,x) + 2\Delta t \partial_{t}f(t,x) + \frac{\left(2\Delta t\right)^{2}}{2!}\partial_{t}^{2}f(t,x) + \frac{\left(2\Delta t\right)^{3}}{3!}\partial_{t}^{3}f(t,x) +  \mathcal{O}\left(\Delta t^{4}\right)\ ,\\
f(t+3\Delta t,x) &= f(t,x) + 3\Delta t \partial_{t}f(t,x) + \frac{\left(3\Delta t\right)^{2}}{2!}\partial_{t}^{2}f(t,x) + \frac{\left(3\Delta t\right)^{3}}{3!}\partial_{t}^{3}f(t,x) +  \mathcal{O}\left(\Delta t^{4}\right)\ .
\end{align}
$$

<a name="FFD">
### Second order, forward finite difference

To obtain the expression for a forward finite difference approximation to the derivative $\partial_{t}f(t,x)$ that is accurate to second-order in the step size, $\mathcal{O}\left(\Delta t^{2}\right)$, we compute

$$
f(t+2\Delta t,x) - 4f(t+\Delta t,x) = - 3f(t,x) - 2\Delta t\partial_{t}f(t,x) + \mathcal{O}\left(\Delta t^{3}\right)\ .
$$

Note that we have chosen to multiply $f(t+\Delta t,x)$ by $4$ because then we cancel the term of $\mathcal{O}\Delta t^{2}$ exactly when performing the operation above. We then have, rearranging the terms and dividing through by $\Delta t$,

$$
\boxed{
\partial_{t}f(t,x) = \frac{-f(t+2\Delta t,x)+4f(t+\Delta t,x)-3f(t,x)}{2\Delta t} + \mathcal{O}\left(\Delta t^{2}\right)
}\ .
$$

Similarly, we could seek for an expression that approximates $\partial_{t}^{2}f(t,x)$ also to second-order in the step size. Consider

$$
-f(t+3\Delta t,x) + 4f(t+2\Delta t,x) - 5f(t+\Delta t,x) = -2f(t,x) + \frac{\Delta t^{2}}{2!}\left(-9 + 16 -5\right)\partial_{t}^{2}f(t,x)\ ,
$$

resulting in

$$
\boxed{\partial_{t}^{2}f(t,x) = \frac{-f(t+3\Delta t,x) + 4f(t+2\Delta t,x) - 5f(t+\Delta t,x) + 2f(t,x)}{\Delta t^{2}}}\ .
$$

<a name="BFD">
### Second order, backward finite difference

Backwards finite differences mirror the derivation of forwards finite differences. This means we can compute

$$
f(t-2\Delta t,x) - 4f(t-\Delta t,x) = - 3f(t,x) + 2\Delta t\partial_{t}f(t,x) + \mathcal{O}\left(\Delta t^{3}\right)\ ,
$$

which, upon rearranging the terms yields

$$
\boxed{
\partial_{t}f(t,x) = \frac{f(t-2\Delta t,x)-4f(t-\Delta t,x)+3f(t,x)}{2\Delta t} + \mathcal{O}\left(\Delta t^{2}\right)
}\ .
$$

The result for the second derivative is

$$
\boxed{\partial_{t}^{2}f(t,x) = \frac{-f(t-3\Delta t,x) + 4f(t-2\Delta t,x) - 5f(t-\Delta t,x) + 2f(t,x)}{\Delta t^{2}}}\ .
$$

<a name="CFD">
### Second order, centered finite difference

Now, consider subtracting the third expression from the fourth, so that

$$
f(t+\Delta t,x) - f(t-\Delta t,x) = 2 \Delta t \partial_{t}f(t,x) + \mathcal{O}\left(\Delta t^{3}\right)\ ,
$$

which yields

$$
\boxed{\partial_{t}f(t,x) = \frac{f(t+\Delta t,x) - f(t-\Delta t,x)}{2 \Delta t} + \mathcal{O}\left(\Delta t^{2}\right)}\ .
$$

On the other hand, adding the same two expressions we obtain

$$
f(t+\Delta t,x) + f(t-\Delta t,x) =  2f(t,x) + \Delta t^{2}\partial_{t}^{2}f(t,x) + \mathcal{O}\left(\Delta t^{4}\right)\ .
$$

or

$$
\boxed{\partial_{t}^{2}f(t,x) = \frac{f(t+\Delta t,x) - 2f(t,x) + f(t-\Delta t,x)}{\Delta t^{2}} + \mathcal{O}\left(\Delta t^{2}\right)}\ .
$$

<a name="FDIndex">
## Index notation

When dealing with finite differences, it is common practice to introduce the following notation

$$
f\left(n\cdot\Delta t,i\cdot\Delta x,j\cdot\Delta y,k\cdot\Delta z\right) \equiv f^{n}_{i,j,k}\ .
$$

The indices $\left(i,j,k\right)$ indicate the points in the grid that we are in. This notation greatly simplifies the finite differences expressions. For example, the fourth-order accurate, centered finite difference approximation to the second derivative of $f(t,x,y,z)$ with respect to $y$ reads (since we have not derived these coefficients here, we refer the reader to [this article](https://en.wikipedia.org/wiki/Finite_difference_coefficient){:target="_blank"})

$$
\partial_{y}^{2}f^{n}_{i,j,k} = \frac{-f^{n}_{i,j+2,k}+8f^{n}_{i,j+1,k}-8f^{n}_{i,j-1,k}+f^{n}_{i,j-2,k}}{12\Delta y} + \mathcal{O}\left(\Delta t^{4}\right)\ .
$$

<a name="FDPractical">
## A practical way of computing finite difference coefficients
