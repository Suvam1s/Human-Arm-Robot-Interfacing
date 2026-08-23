# 5R Robotic Manipulator — Screw Axis and DOF Analysis

## Overview

This project presents the kinematic representation and degree-of-freedom analysis of a **5R serial robotic manipulator**.

The robot consists of **five revolute joints (5R)** and six links including the base.

This analysis covers:

* Screw-axis representation
* Angular and linear velocity components
* Screw-axis calculation for each joint
* Complete screw-axis matrix
* Grübler–Kutzbach degree-of-freedom verification
## Physical Meaning

When a revolute joint rotates, every point in space experiences a velocity. To represent this motion as a **spatial velocity twist**:

$$
\mathcal{S} =
\begin{bmatrix}
\boldsymbol{\omega} \\
\mathbf{v}
\end{bmatrix}
$$

we need to find the linear velocity at the *origin* of our coordinate system.

Because the origin is at a distance of $-\mathbf{q}$ relative to the axis point $\mathbf{q}$, its linear velocity due to pure rotation is calculated as:

$$\mathbf{v} = \boldsymbol{\omega} \times (-\mathbf{q}) = -\boldsymbol{\omega} \times \mathbf{q} = \mathbf{q} \times \boldsymbol{\omega}$$
---

# 1. Screw Axis Representation

For a revolute joint, the screw axis is represented as:

$$
S =
\begin{bmatrix}
\omega &\
v
\end{bmatrix}
$$

where the angular component is:

$$
\omega =
\begin{bmatrix}
\omega_x & \
\omega_y & \
\omega_z &
\end{bmatrix}
$$

and the linear component is:

$$
v =
\begin{bmatrix}
v_x & \
v_y & \
v_z &
\end{bmatrix}
$$

Therefore, the screw axis is a 6-dimensional vector:

$$
S =
\begin{bmatrix}
\omega_x & \
\omega_y & \
\omega_z & \
v_x & \
v_y & \
v_z &
\end{bmatrix}
$$

For a revolute joint, the linear component is calculated using:

$$
v = -\omega \times q
$$

where:

* $\omega$ is the unit vector along the joint axis
* $q$ is a point lying on the joint axis
* $v$ is the linear component of the screw axis

Thus:

$$
S =
\begin{bmatrix}
\omega \
-\omega \times q
\end{bmatrix}
$$

The ordering used throughout this analysis is:

$$
S =
\begin{bmatrix}
\omega_x & \
\omega_y & \
\omega_z & \
v_x & \
v_y & \
v_z &
\end{bmatrix}
$$

---

# 2. Joint 1 — Base

### Joint Specification

* Type: Revolute
* Axis: $z$
* Position: Base origin

The point on the joint axis is:

$$
q_1 =
\begin{bmatrix}
0 & \
0 & \
0 &
\end{bmatrix}
$$

The angular component is:

$$
\omega_1 =
\begin{bmatrix}
0 & \
0 & \
1 &
\end{bmatrix}
$$

Using:

$$
v_1 = -\omega_1 \times q_1
$$

gives:

$$
v_1 =
\begin{bmatrix}
0 & \
0 & \
0 &
\end{bmatrix}
$$

Therefore, the screw axis is:

$$
S_1 =
\begin{bmatrix}
0 & \
0 & \
1 & \
0 & \
0 & \
0 &
\end{bmatrix}
$$

---

# 3. Joint 2 — Shoulder

### Joint Specification

* Type: Revolute
* Axis: $y$
* Position:

  * $y = 2.5$ cm
  * $z = 5$ cm

Therefore:

$$
q_2 =
\begin{bmatrix}
0 & \
2.5 & \
5 &
\end{bmatrix}
$$

The angular component is:

$$
\omega_2 =
\begin{bmatrix}
0 & \
1 & \
0 &
\end{bmatrix}
$$

Using:

$$
v_2 = -\omega_2 \times q_2
$$

gives:

$$
v_2 =
\begin{bmatrix}
-5 & \
0 & \
0 &
\end{bmatrix}
$$

Therefore, the screw axis is:

$$
S_2 =
\begin{bmatrix}
0 & \
1 & \
0 & \
-5 & \
0 & \
0 &
\end{bmatrix}
$$

---

# 4. Joint 3 — Elbow

### Joint Specification

* Type: Revolute
* Axis: $y$

The position along the $z$-axis is:

$$
z = (5 + 16.5)\text{ cm}
$$

Therefore:

$$
z = 21.5\text{ cm}
$$

and:

$$
y = 3.5\text{ cm}
$$

Therefore:

$$
q_3 =
\begin{bmatrix}
0 & \
3.5 & \
21.5 &
\end{bmatrix}
$$

The angular component is:

$$
\omega_3 =
\begin{bmatrix}
0 & \
1 & \
0 &
\end{bmatrix}
$$

Using:

$$
v_3 = -\omega_3 \times q_3
$$

gives:

$$
v_3 =
\begin{bmatrix}
-21.5 & \
0 & \
0 &
\end{bmatrix}
$$

Therefore, the screw axis is:

$$
S_3 =
\begin{bmatrix}
0 & \
1 & \
0 & \
-21.5 & \
0 & \
0 &
\end{bmatrix}
$$

---

# 5. Joint 4 — Lower Wrist

### Joint Specification

* Type: Revolute
* Axis: $-y$

The position along the $z$-axis is:

$$
z = (21.5 + 17.5)\text{ cm}
$$

Therefore:

$$
z = 39\text{ cm}
$$

and:

$$
y = 2.5\text{ cm}
$$

Therefore:

$$
q_4 =
\begin{bmatrix}
0 & \
2.5 & \
39 &
\end{bmatrix}
$$

Since the joint rotates about the negative $y$-axis:

$$
\omega_4 =
\begin{bmatrix}
0 & \
-1 & \
0 &
\end{bmatrix}
$$

Using:

$$
v_4 = -\omega_4 \times q_4
$$

gives:

$$
v_4 =
\begin{bmatrix}
39 & \
0 & \
0 &
\end{bmatrix}
$$

Therefore, the screw axis is:

$$
S_4 =
\begin{bmatrix}
0 & \
-1 & \
0 & \
39 & \
0 & \
0 &
\end{bmatrix}
$$

---

# 6. Joint 5 — Wrist

### Joint Specification

* Type: Revolute
* Axis: $x$

The joint position is:

$$
x = 1.5\text{ cm}
$$

and:

$$
z = 39\text{ cm}
$$

Therefore:

$$
q_5 =
\begin{bmatrix}
1.5 & \
0 & \
39 &
\end{bmatrix}
$$

The angular component is:

$$
\omega_5 =
\begin{bmatrix}
1 & \
0 & \
0 &
\end{bmatrix}
$$

Using:

$$
v_5 = -\omega_5 \times q_5
$$

gives:

$$
v_5 =
\begin{bmatrix}
0 & \
39 & \
0 &
\end{bmatrix}
$$

Therefore, the screw axis is:

$$
S_5 =
\begin{bmatrix}
1 & \
0 & \
0 & \
0 & \
39 & \
0 &
\end{bmatrix}
$$

---

# 7. Complete Screw-Axis Matrix

The five screw axes are:

$$
S_1 =
\begin{bmatrix}
0 & \
0 & \
1 & \
0 & \
0 & \
0 &
\end{bmatrix}
$$

$$
S_2 =
\begin{bmatrix}
0 & \
1 & \
0 & \
-5 & \
0 & \
0 &
\end{bmatrix}
$$

$$
S_3 =
\begin{bmatrix}
0 & \
1 & \
0 & \
-21.5 & \
0 & \
0 &
\end{bmatrix}
$$

$$
S_4 =
\begin{bmatrix}
0 & \
-1 & \
0 & \
39 & \
0 & \
0 &
\end{bmatrix}
$$

$$
S_5 =
\begin{bmatrix}
1 & \
0 & \
0 & \
0 & \
39 & \
0 &
\end{bmatrix}
$$

Combining the five screw axes column-wise:

$$
\mathcal{S}
===========

\begin{bmatrix}
S_1 & S_2 & S_3 & S_4 & S_5
\end{bmatrix}
$$

gives the complete $6 \times 5$ screw-axis matrix:

$$
S=
\begin{bmatrix}
S_1 &\ S_2 &\ S_3 &\ S_4 &\ S_5
\end{bmatrix}
$$

gives the complete `6 × 5` screw-axis matrix:

$$
\mathcal{S} =
\begin{bmatrix}
0 & 0 & 0 & 0 & 1 \\
0 & 1 & 1 & -1 & 0 \\
1 & 0 & 0 & 0 & 0 \\
0 & -5 & -21.5 & 39 & 0 \\
0 & 0 & 0 & 0 & 39 \\
0 & 0 & 0 & 0 & 0
\end{bmatrix}
$$

The rows correspond to:

$$
[\omega_x,\omega_y,\omega_z,v_x,v_y,v_z]
$$

and the columns correspond to:

$$
S=[S_1,S_2,S_3,S_4,S_5]
$$
---

# 8. Grübler–Kutzbach Degree of Freedom Analysis

The degree of freedom is independently verified using the **Grübler–Kutzbach criterion**:

$$
DOF = m(N - 1 - J) + \sum_{i=1}^{J} f_i
$$

where:

* $m$ = degrees of freedom of a free rigid body
* $N$ = total number of links
* $J$ = total number of joints
* $f_i$ = degrees of freedom contributed by joint $i$

For a rigid body moving freely in 3D space:

$$
m = 6
$$

---

## 8.1 Number of Links

The manipulator consists of:

* 1 base
* 5 moving links

Therefore:

$$
N = 1 + 5 = 6
$$

---

## 8.2 Number of Joints

The manipulator contains five revolute joints:

$$
J = 5
$$

---

## 8.3 Degrees of Freedom of Individual Joints

Each revolute joint contributes one degree of freedom:

$$
f_i = 1
$$

Therefore:

$$
\sum_{i=1}^{J} f_i
==================

# 1 + 1 + 1 + 1 + 1

5
$$

---

## 8.4 Substitution

Substituting:

$$
m = 6,\qquad N = 6,\qquad J = 5
$$

and:

$$
\sum f_i = 5
$$

into the Grübler–Kutzbach equation:

$$
DOF
===

6(6 - 1 - 5) + 5
$$

$$
DOF
===

6(0) + 5
$$

Therefore:

$$
DOF = 5
$$

---

# 9. Final Result

The manipulator is a **5R serial robotic arm** consisting of five revolute joints.

| Parameter         |        Value |
| ----------------- | -----------: |
| Configuration     |           5R |
| Number of links   |            6 |
| Number of joints  |            5 |
| Joint type        |     Revolute |
| DOF per joint     |            1 |
| Total DOF         |        **5** |
| Screw-axis matrix | $6 \times 5$ |

The final screw-axis matrix is:

$$
\mathcal{S} =
\begin{bmatrix}
0 & 0 & 0 & 0 & 1 \\
0 & 1 & 1 & -1 & 0 \\
1 & 0 & 0 & 0 & 0 \\
0 & -5 & -21.5 & 39 & 0 \\
0 & 0 & 0 & 0 & 39 \\
0 & 0 & 0 & 0 & 0
\end{bmatrix}
$$

The independent Grübler–Kutzbach analysis confirms:

$$
DOF = 5
$$

---

# 10. Kinematic Foundation

The screw-axis representation obtained from this analysis provides the foundation for further robotic analysis, including:

* Forward kinematics
* Product of Exponentials (PoE)
* Jacobian derivation
* End-effector velocity analysis
* Singularity analysis
* Inverse kinematics
* Trajectory generation
* Robot control

---

## Summary

This analysis establishes the mathematical foundation of the **5R robotic manipulator**.

The five revolute joints are represented using screw theory, producing a complete $6 \times 5$ screw-axis matrix.

The degree of freedom is independently verified using the Grübler–Kutzbach criterion:

$$
DOF = 5
$$

Thus, the manipulator has **five independent joint variables and five degrees of freedom**.
