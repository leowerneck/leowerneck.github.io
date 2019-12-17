---
layout: notes
title: Finite Differences
mathjax: true
---

<a name='ToC'>
# Table of Contents

<ul>
  <li>Main</li>
    <ul>
      <li>Sub 1</li>
      <li>Sub 2</li>
        <ul>
          <li>SubSub 2.1</li>
          <li>SubSub 2.2</li>
          <li>SubSub 2.3</li>
        </ul>
      <li>Sub 3</li>
      <li>Sub 4</li>
        <ul>
          <li>SubSub 4.1</li>
          <li>SubSub 4.2</li>
        </ul>
    </ul>
</ul>

* [**Finite differences**](#FD)
  * [*Forward, backwards, and centered finite differences*](#FDTypes)
  * [*Determining finite differences expressions*](#FDTaylor)
     * [Second order, forward finite difference](#FFD)
     * [Second order, backward finite difference](#BFD)
     * [Second order, centered finite difference](#CFD)
  * [*Index notation*](#FDIndex)
  * [*A practical way of computing finite difference coefficients*](#FDPractical)
    * [Center Finite Differences](#FDPracticalCenter)
    * [Forward/backwards Finite Differences](#FDPracticalFwdBwd)

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
## Forward, backwards, and centered finite differences  \[Back to [ToC](#ToC)\]

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
## Determining finite differences expressions \[Back to [ToC](#ToC)\]

Let us now present a more systematic way of determining the finite difference approximation to the derivative of a function $f(t,x)$. We will choose a function of 2 variables on purpose, because it then becomes trivial to understand the algorithm for functions of even more variables. In the derivations below, the single variable case can be obtained by simplying supressing the variable $x$ altogether.

Consider the [Taylor series](https://en.wikipedia.org/wiki/Taylor_series){:target="_blank"} of the function $f(t,x)$ around different points, strategically chosen:

$$
\begin{align}
f(t-3\Delta t,x) &= f(t,x) - 3\Delta t \partial_{t}f(t,x) + \frac{\left(3\Delta t\right)^{2}}{2!}\partial_{t}^{2}f(t,x) - \frac{\left(3\Delta t\right)^{3}}{3!}\partial_{t}^{3}f(t,x) + \frac{\left(3\Delta t\right)^{4}}{4!}\partial_{t}^{4}f(t,x) + \mathcal{O}\left(\Delta t^{5}\right)\ ,\\
f(t-2\Delta t,x) &= f(t,x) - 2\Delta t \partial_{t}f(t,x) + \frac{\left(2\Delta t\right)^{2}}{2!}\partial_{t}^{2}f(t,x) - \frac{\left(2\Delta t\right)^{3}}{3!}\partial_{t}^{3}f(t,x) + \frac{\left(2\Delta t\right)^{4}}{4!}\partial_{t}^{4}f(t,x) + \mathcal{O}\left(\Delta t^{5}\right)\ ,\\
f(t-\Delta t,x) &= f(t,x) - \Delta t \partial_{t}f(t,x) + \frac{\Delta t^{2}}{2!}\partial_{t}^{2}f(t,x) - \frac{\Delta t^{3}}{3!}\partial_{t}^{3}f(t,x) + + \frac{\left(\Delta t\right)^{4}}{4!}\partial_{t}^{4}f(t,x) \mathcal{O}\left(\Delta t^{5}\right)\ ,\\
f(t+\Delta t,x) &= f(t,x) + \Delta t \partial_{t}f(t,x) + \frac{\Delta t^{2}}{2!}\partial_{t}^{2}f(t,x) + \frac{\Delta t^{3}}{3!}\partial_{t}^{3}f(t,x) + + \frac{\left(\Delta t\right)^{4}}{4!}\partial_{t}^{4}f(t,x) \mathcal{O}\left(\Delta t^{5}\right)\ ,\\
f(t+2\Delta t,x) &= f(t,x) + 2\Delta t \partial_{t}f(t,x) + \frac{\left(2\Delta t\right)^{2}}{2!}\partial_{t}^{2}f(t,x) + \frac{\left(2\Delta t\right)^{3}}{3!}\partial_{t}^{3}f(t,x) + \frac{\left(2\Delta t\right)^{4}}{4!}\partial_{t}^{4}f(t,x) +  \mathcal{O}\left(\Delta t^{5}\right)\ ,\\
f(t+3\Delta t,x) &= f(t,x) + 3\Delta t \partial_{t}f(t,x) + \frac{\left(3\Delta t\right)^{2}}{2!}\partial_{t}^{2}f(t,x) + \frac{\left(3\Delta t\right)^{3}}{3!}\partial_{t}^{3}f(t,x) + \frac{\left(3\Delta t\right)^{4}}{4!}\partial_{t}^{4}f(t,x) + \mathcal{O}\left(\Delta t^{5}\right)\ .
\end{align}
$$

<a name="FFD">
### Second order, forward finite difference \[Back to [ToC](#ToC)\]

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
### Second order, backward finite difference \[Back to [ToC](#ToC)\]

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
### Second order, centered finite difference \[Back to [ToC](#ToC)\]

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
## Index notation \[Back to [ToC](#ToC)\]

When dealing with finite differences, it is common practice to introduce the following notation

$$
f\left(n\cdot\Delta t,i\cdot\Delta x,j\cdot\Delta y,k\cdot\Delta z\right) \equiv f^{n}_{i,j,k}\ .
$$

The indices $\left(i,j,k\right)$ indicate the points in the grid that we are in. This notation greatly simplifies the finite differences expressions. For example, the fourth-order accurate, centered finite difference approximation to the second derivative of $f(t,x,y,z)$ with respect to $y$ reads (since we have not derived these coefficients here, we refer the reader to [this article](https://en.wikipedia.org/wiki/Finite_difference_coefficient){:target="_blank"})

$$
\partial_{y}^{2}f^{n}_{i,j,k} = \frac{-f^{n}_{i,j+2,k}+8f^{n}_{i,j+1,k}-8f^{n}_{i,j-1,k}+f^{n}_{i,j-2,k}}{12\Delta y} + \mathcal{O}\left(\Delta t^{4}\right)\ .
$$

<a name="FDPractical">
## A practical way of computing finite difference coefficients \[Back to [ToC](#ToC)\]

<a name="FDPracticalCenter">
### Center Finite Differences

We will now discuss a fairly practical way of computing [finite difference coefficients](https://en.wikipedia.org/wiki/Finite_difference_coefficient){:target="_blank"}), which is the method used by the [NRPy+ infrastructure](https://blackholesathome.net/){:target="_blank"}. Our discussion will follow very closely that of Zach Etienne in the [NRPy+ Tutorial-How_NRPy_Computes_Finite_Difference_Coeffs](https://github.com/zachetienne/nrpytutorial/blob/master/Tutorial-How_NRPy_Computes_Finite_Difference_Coeffs.ipynb){:target="_blank"}.

By construction, a center finite difference approximation to the *first* derivative of a function up to order $\mathcal{O}\left(h^{n}\right)$, where $h$ is the step size, will require a *stencil* of size $2n+1$. In other words, consider the first derivative of a function $f(x)$ accurate to $\mathcal{O}\left(dx^{4}\right)$, and assume:

$$
\partial_{x}f_{i} = a_{-2}f_{i-2} + a_{-1}f_{i-1} + a_{0}f_{i} + a_{1}f_{i+1} + a_{2}f_{i+2}\ .
$$

Then, by considering the set of Taylor series we had [before](#FDTaylor), we can add up all the Taylor series to obtain:

$$
\begin{align}
a_{-2}f_{i-2} + a_{-1}f_{i-1} + a_{0}f_{i} + a_{1}f_{i+1} + a_{2}f_{i+2}
&=
\left(-2^{0}a_{-2} - 1^{0}a_{-1} + 1^{0}a_{0} + 1^{0}a_{1} + 2^{0}a_{2}\right)f_{0}\\
&+
\left(-2^{1}a_{-2} - 1^{1}a_{-1} + 0^{1}a_{0} + 1^{1}a_{1} + 2^{1}a_{2}\right)\Delta x\partial_{x}f\\
&+
\left(-2^{2}a_{-2} - 1^{2}a_{-1} + 0^{2}a_{0} + 1^{2}a_{1} + 2^{2}a_{2}\right)\frac{\Delta x^{2}}{2!}\partial_{x}^{2}f\\
&+
\left(-2^{3}a_{-2} - 1^{3}a_{-1} + 0^{3}a_{0} + 1^{3}a_{1} + 2^{3}a_{2}\right)\frac{\Delta x^{3}}{3!}\partial_{x}^{3}f\\
&+
\left(-2^{4}a_{-2} - 1^{4}a_{-1} + 0^{4}a_{0} + 1^{4}a_{1} + 2^{4}a_{2}\right)\frac{\Delta x^{4}}{4!}\partial_{x}^{4}f
\end{align}
$$

Which leads to the following system of equations (absorbing the powers of $\Delta x$ in the derivatives, for now)

$$
\begin{align}
0\times0! &= -2^{0}a_{-2} - 1^{0}a_{-1} + 1^{0}a_{0} + 1^{0}a_{1} + 2^{0}a_{2}\\
1\times1! &= -2^{1}a_{-2} - 1^{1}a_{-1} + 0^{1}a_{0} + 1^{1}a_{1} + 2^{1}a_{2}\\
0\times2! &= -2^{2}a_{-2} - 1^{2}a_{-1} + 0^{2}a_{0} + 1^{2}a_{1} + 2^{2}a_{2}\\
0\times3! &= -2^{3}a_{-2} - 1^{3}a_{-1} + 0^{3}a_{0} + 1^{3}a_{1} + 2^{3}a_{2}\\
0\times4! &= -2^{4}a_{-2} - 1^{4}a_{-1} + 0^{4}a_{0} + 1^{4}a_{1} + 2^{4}a_{2}
\end{align}
$$

or, in matrix form

$$
\begin{bmatrix}
0\\
1\\
0\\
0\\
0
\end{bmatrix}
=
\begin{bmatrix}
(-2)^{0} & (-1)^{0} & 1^{0} & 1^{0} & 2^{0}\\
(-2)^{1} & (-1)^{1} & 0^{1} & 1^{1} & 2^{1}\\
(-2)^{2} & (-1)^{2} & 0^{2} & 1^{2} & 2^{2}\\
(-2)^{3} & (-1)^{3} & 0^{3} & 1^{3} & 2^{3}\\
(-2)^{4} & (-1)^{4} & 0^{4} & 1^{4} & 2^{4}
\end{bmatrix}
\begin{bmatrix}
a_{-2}\\
a_{-1}\\
a_{0}\\
a_{1}\\
a_{2}
\end{bmatrix}\ .
$$

Solving the problem now amounts to inverting the matrix

$$
M =
\begin{bmatrix}
(-2)^{0} & (-1)^{0} & 1^{0} & 1^{0} & 2^{0}\\
(-2)^{1} & (-1)^{1} & 0^{1} & 1^{1} & 2^{1}\\
(-2)^{2} & (-1)^{2} & 0^{2} & 1^{2} & 2^{2}\\
(-2)^{3} & (-1)^{3} & 0^{3} & 1^{3} & 2^{3}\\
(-2)^{4} & (-1)^{4} & 0^{4} & 1^{4} & 2^{4}
\end{bmatrix}
$$

The following code in Python, which uses the [SymPy](https://www.sympy.org/) module takes care of this:

```python
# Import SymPy Python module
import sympy as sp

# Set stencil size, initialize the matrix to zero
stencil_size = 5
M = sp.zeros(stencil_size,stencil_size)

# Loop over the matrix elements, implementing the pattern above
for i in range(stencil_size):
    for j in range(stencil_size):
        M[(i,j)] = (j - (stencil_size-1)/2)**i

# Invert the matrix
M_inv = M**(-1)
```

The code above produces the following answer

$$
M^{-1} =
\begin{bmatrix}
0 & \frac{1}{12}  & -\frac{1}{24} & -\frac{1}{12} & \frac{1}{24} \\
0 & -\frac{2}{3}  & \frac{2}{3}   & \frac{1}{6}   & -\frac{1}{6} \\
1 & 0             & -\frac{5}{4}  & 0             & \frac{1}{4}  \\
0 & \frac{2}{3}   & \frac{2}{3}   & -\frac{1}{6}  & -\frac{1}{6} \\
0 & -\frac{1}{12} & -\frac{1}{24} & \frac{1}{12}  & \frac{1}{24}
\end{bmatrix}\ .
$$

Now, if we want to obtain, say, the $p$th derivative of the function $f$, we compute the dot product between the $p+1$ column of the matrix $M^{-1}$ with the vector $\left(f_{i-2},f_{i-1},f_{i},f_{i+1},f_{i+2}\right)$. To restore units, we also multiply the entire thing by $\frac{p!}{\Delta x^{p}}$. For example, the zeroth order derivative would correspond to $p=0$, hence

$$
\frac{0!}{\Delta x^{0}}\left(0f_{i-2} + 0f_{i-1} + 1f_{i} + 0f_{i+1} + 0f_{i+2}\right) = f_{i}\ .
$$

The first order derivative, on the other hand, corresponds to

$$
\frac{1!}{\Delta x^{1}}\left(\frac{1}{12}f_{i-2} - \frac{2}{3}f_{i-1} + 0f_{i} + \frac{2}{3}f_{i+1} - \frac{1}{12}0f_{i+2}\right) = \frac{f_{i-2} - 8f_{i-1} + 8f_{i+1} - f_{i+2}}{12\Delta x} = \partial_{x}f_{i} + \mathcal{O}\left(\Delta x^{4}\right)\ .
$$

Finally, since it turns out that for center finite differences the second derivative stencil size is the same as the first derivative, we can also compute the $p=2$ case

$$
\frac{2!}{\Delta x^{2}}\left(-\frac{1}{24}f_{i-2} + \frac{2}{3}f_{i-1} - \frac{5}{4}f_{i} + \frac{2}{3}f_{i+1} - \frac{1}{24}0f_{i+2}\right) = \frac{-f_{i-2} + 16f_{i-1} -30f_{i} + 16f_{i+1} - f_{i+2}}{12\Delta x} = \partial_{x}^{2}f_{i} + \mathcal{O}\left(\Delta x^{4}\right)\ .
$$

Unfortunately, the other two columns give us approximations for $\partial_{x}^{3}f$ and $\partial_{x}^{4}f$ which are accurate only to $\mathcal{O}\left(\Delta x^{2}\right)$. To obtain these derivatives at $\mathcal{O}\left(\Delta x^{4}\right)$, we would need to increase our stencil size by 2.

<a name="FDPracticalFwdBwd">
### Forward/backwards Finite Differences

To compute the forward/backwards approximations, we follow a completely analogous prescription. The forwards/backwards finite differences, the first order derivative accurate to order $\mathcal{O}\left(h^{n}\right)$ requres a stencil size $n+1$. We then wish to compute, say to order $\mathcal{O}\left(\Delta x^{6}\right)$, the forward finite difference approximation first derivative of $f(x)$. This requires a stencil of size 7, which i.e.

$$
a_{0}f_{i} + a_{1}f_{i+1} + a_{1}f_{i+1} + a_{2}f_{i+2} + a_{3}f_{i+3} + a_{4}f_{i+4} + a_{5}f_{i+5} + a_{6}f_{i+6}\ .
$$

By staring at the previous section, it is easy to convince oneself that the matrix we need to invert now is

$$
M =
\begin{bmatrix}
0^{0} & 1^{0} & 2^{0} & 3^{0} & 4^{0} & 5^{0} & 6^{0}\\
0^{1} & 1^{1} & 2^{1} & 3^{1} & 4^{1} & 5^{1} & 6^{1}\\
0^{2} & 1^{2} & 2^{2} & 3^{2} & 4^{2} & 5^{2} & 6^{2}\\
0^{3} & 1^{3} & 2^{3} & 3^{3} & 4^{3} & 5^{3} & 6^{3}\\
0^{4} & 1^{4} & 2^{4} & 3^{4} & 4^{4} & 5^{4} & 6^{4}\\
0^{5} & 1^{5} & 2^{5} & 3^{5} & 4^{5} & 5^{5} & 6^{5}\\
0^{6} & 1^{6} & 2^{6} & 3^{6} & 4^{6} & 5^{6} & 6^{6}
\end{bmatrix}
$$

We can then use the following piece of code to invert this matrix:

```python
# Import SymPy Python module
import sympy as sp

# Set stencil size, initialize the matrix to zero
stencil_size = 7
M = sp.zeros(stencil_size,stencil_size)

# Loop over the matrix elements, implementing the pattern above
for i in range(stencil_size):
    for j in range(stencil_size):
        M[(i,j)] = j**i

# Invert the matrix
M_inv = M**(-1)
```

resulting in

$$
\left[
\begin{matrix}
1 & - \frac{49}{20} & \frac{203}{90} & - \frac{49}{48} & \frac{35}{144} & - \frac{7}{240} & \frac{1}{720}\\0 & 6 & - \frac{87}{10} & \frac{29}{6} & - \frac{31}{24} & \frac{1}{6} & - \frac{1}{120}\\0 & - \frac{15}{2} & \frac{117}{8} & - \frac{461}{48} & \frac{137}{48} & - \frac{19}{48} & \frac{1}{48}\\0 & \frac{20}{3} & - \frac{127}{9} & \frac{31}{3} & - \frac{121}{36} & \frac{1}{2} & - \frac{1}{36}\\0 & - \frac{15}{4} & \frac{33}{4} & - \frac{307}{48} & \frac{107}{48} & - \frac{17}{48} & \frac{1}{48}\\0 & \frac{6}{5} & - \frac{27}{10} & \frac{13}{6} & - \frac{19}{24} & \frac{2}{15} & - \frac{1}{120}\\0 & - \frac{1}{6} & \frac{137}{360} & - \frac{5}{16} & \frac{17}{144} & - \frac{1}{48} & \frac{1}{720}
\end{matrix}
\right]\ .
$$

To obtain the final result, the process is identical to the central finite differences case. Consider the $p$th derivative. Then, multiply the $p+1$ column of the $M^{-1}$ matrix by the vector $\left(f_{i},f_{i+1},f_{i+2},f_{i+3},f_{i+4},f_{i+5},f_{i+6}\right)$. For example, for $p=0$

$$
\frac{0!}{\Delta x^{0}}\left(f_{i} + 0f_{i+1} + 0f_{i+2} + 0f_{i+3} + 0f_{i+4} + 0f_{i+5} + 0f_{i+6}\right) = f_{i}\ .
$$

The first derivative is given by the $p=1$ case,

$$
\frac{1!}{\Delta x^{1}}\left(-\frac{49}{20}f_{i} + 6f_{i+1}  -\frac{15}{2}f_{i+2} + \frac{20}{3}f_{i+3} - \frac{15}{4}f_{i+4} + \frac{6}{5}f_{i+5} - \frac{1}{6}f_{i+6}\right) = \partial_{x}f_{i} + \mathcal{O}\left(\Delta x^{6}\right)\ .
$$

To obtain the second derivative with the same accuracy, we would need a stencil size that is greater than the one we use by 1. The algorithm for backwards finite differences should now be straightforward and will be left as an exercise to the reader.
