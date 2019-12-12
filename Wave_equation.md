---
layout: notes
title: Leonardo Werneck
mathjax: true
---

# The Wave Equation

Here we will explore the [wave equation](https://en.wikipedia.org/wiki/Wave_equation) and discuss how to solve it in the computer. For the sake of this discussion, we will be using the [C programming language](https://en.wikipedia.org/wiki/C_(programming_language).

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
