## 1. Capacitor Current

$$
i_C = C\frac{d(V_{in}-V_o)}{dt}
$$

Capacitor current.

## 2. Resistor Current

$$
i_R = \frac{V}{R}
$$

Resistor current.

## 3. Applying KCL

According to KCL, net current at $V_x$ must be zero, as a node in a circuit does not store current.

$$
i_{C2}=C_2\frac{d(V_x-V_o)}{dt}
$$

Since $V_x=0$:

$$
i_{C2}=C_2\frac{d(0-V_o)}{dt}
$$

$$
\therefore i_{C2}=-C_2\frac{dV_o}{dt}
$$

## 4. Laplace Domain

Taking the equation into the Laplace domain:

$$
i_{C2}=-C_2V_os
$$

## 5. Current Through $R_2$

$$
i_{R2}=\frac{(V_x-0)}{R_2}
$$

Here $V_x=0$, as the input is zero because of virtual ground.

$$
i_{R2}=\frac{V_x}{R_2}
$$

Since

$$
i_{C2}+i_{R2}=0
$$

we get

$$
V_x=R_2C_2V_os
$$

## 6. Applying KCL at $V_x$

Now applying KCL at $V_x$:

$$
i_{R1}=i_{C1}+i_{R3}+i_{R2}
$$

Therefore,

$$
\frac{V_{in}-V_x}{R_1}=C_1sV_x+\frac{V_x-V_o}{R_3}+\frac{V_x}{R_2}
$$

Substituting

$$
V_x=R_2C_2V_os
$$

gives

$$
\frac{V_{in}-R_2C_2V_os}{R_1}=C_1(sV_osC_2R_2)+\frac{sV_oC_2R_2-V_o}{R_3}+C_2V_os
$$

Therefore,

$$
V_{in}-R_2C_2V_os=V_o\left(s^2C_1C_2R_2R_1+\frac{sC_2R_2R_1-R_1}{R_3}+C_2R_1s\right)
$$

Multiplying numerator and denominator by $R_3$:

$$
\frac{V_{in}}{V_o}=\frac{1}{R_3}\left(s^2C_1C_2R_2R_1R_3+sC_2R_2R_1+sC_2R_1R_3+sC_2R_2R_3-R_1\right)
$$

Dividing numerator and denominator by

$$
C_1C_2R_2R_1R_3
$$

gives

$$
\frac{V_o}{V_{in}}=\frac{\frac{1}{C_1C_2R_2R_1}}{s^2+s\frac{1}{C_1}\left(\frac{1}{R_1}+\frac{1}{R_2}+\frac{1}{R_3}\right)+\frac{1}{C_1C_2R_2R_3}}
$$

Therefore,

$$
\boxed{H(s)=\frac{\frac{1}{C_1C_2R_2R_1}}{s^2+s\frac{1}{C_1}\left(\frac{1}{R_1}+\frac{1}{R_2}+\frac{1}{R_3}\right)+\frac{1}{C_1C_2R_2R_3}}}\tag{1}
$$

## 7. Butterworth Comparison

As we are trying to get a Butterworth-type cutoff.

Second-order Butterworth filter (low-pass) system gain:

**(2)**

$$
H(s)=\frac{Y(s)}{X(s)}=\frac{H\omega^2}{s^2+\sqrt{2}\omega s+\omega^2}
$$

Here $H$ is the overall gain.

Comparing Equation (1) and Equation (2):

$$
\omega^2=\frac{1}{C_1C_2R_2R_3}
$$

$$
\omega=\frac{1}{\sqrt{2}}\frac{1}{C_1}\left(\frac{1}{R_1}+\frac{1}{R_2}+\frac{1}{R_3}\right)
$$

$$
R_1H=R_3
$$

## 8. Taking Component Values

Taking arbitrary values for:

$$
C_1=100\mu F=100\times10^{-6}F
$$

$$
C_2=10\mu F=10\times10^{-6}F
$$

$$
R_3=1000\Omega=1k\Omega
$$

## 9. Op-Amp Gain

Gain of op-amp:

$$
H=25
$$

We know:

$$
R_1H=R_3
$$

Therefore,

$$
R_1=\frac{R_3}{H}
$$

$$
R_1=\frac{1000}{25}
$$

$$
\boxed{R_1=40\Omega}
$$

## 10. Cutoff Frequency

The human arm, specifically at the elbow joint (a hinge-type joint), is capable of repetitive motion at an average maximum frequency of approximately $3Hz$ in typical individuals.

Cutoff frequency:

$$
f=3Hz
$$

Angular frequency:

$$
\omega=2\pi f
$$

For

$$
f=3Hz
$$

$$
\omega=2\pi(3)
$$

$$
\boxed{\omega=18.84}
$$

## 11. Finding $R_2$

Now substituting the values of $\omega$, $R_3$, $C_1$, and $C_2$ in the equation:

$$
\omega^2=\frac{1}{C_1C_2R_2R_3}
$$

Therefore,

$$
(18.84)^2=\frac{1}{100\times10^{-6}\times10\times10^{-6}\times{R_2}\times1000}
$$

$$
R_2=\frac{1}{100\times10^{-6}\times10\times10^{-6}\times1000\times354.94}
$$

$$
\boxed{R_2=2817\Omega}
$$

Nearest value of $R_2$ for an equivalent component available in market:

$$
\boxed{R_2\approx2.8k\Omega}
$$

## 12. Final Values

$$
\boxed{R_1=40\Omega}
$$

$$
\boxed{R_2=2.8k\Omega}
$$

$$
\boxed{R_3=1k\Omega}
$$

$$
\boxed{C_1=100\mu F}
$$

$$
\boxed{C_2=10\mu F}
$$

## 13. Butterworth Condition Verification and Gain Adjustment

Using the selected values:

$$
C_1=100\mu F
$$

$$
C_2=10\mu F
$$

$$
R_1=40\Omega
$$

$$
R_2=2.8k\Omega
$$

$$
R_3=1k\Omega
$$

The transfer function becomes:

$$
H(s)=\frac{8928.5714}{s^2+263.5714s+357.1429}
$$

The natural frequency is obtained from:

$$
\omega_n^2=\frac{1}{C_1C_2R_2R_3}
$$

$$
\omega_n^2=357.1429
$$

Therefore,

$$
\omega_n=\sqrt{357.1429}
$$

$$
\boxed{\omega_n=18.8982\ rad/s}
$$

and

$$
f_n=\frac{\omega_n}{2\pi}
$$

$$
\boxed{f_n\approx3.008\ Hz}
$$

For a second-order Butterworth filter, the required coefficient of $s$ is:

$$
\sqrt{2}\omega_n
$$

$$
\sqrt{2}(18.8982)=26.7261
$$

However, the actual coefficient of $s$ is:

$$
263.5714
$$

Therefore,

$$
263.5714\neq26.7261
$$

Hence, the initial component selection satisfies the required natural frequency but does not satisfy the Butterworth damping condition.

### Damping Ratio Check

The standard second-order transfer function is:

$$
H(s)=\frac{H\omega_n^2}{s^2+2\zeta\omega_ns+\omega_n^2}
$$

Comparing this with the actual transfer function:

$$
H(s)=\frac{8928.5714}{s^2+263.5714s+357.1429}
$$

we have:

$$
2\zeta\omega_n=263.5714
$$

Therefore,

$$
\zeta=\frac{263.5714}{2(18.8982)}
$$

$$
\boxed{\zeta\approx6.973}
$$

For a second-order Butterworth filter:

$$
\zeta=\frac{1}{\sqrt{2}}
$$

$$
\boxed{\zeta\approx0.7071}
$$

Therefore,

$$
6.973\neq0.7071
$$

Hence, the initial design is not Butterworth.

---

## 14. Butterworth Gain Adjustment

The selected values are kept as:

$$
C_1=100\mu F
$$

$$
C_2=10\mu F
$$

$$
R_2=2.8k\Omega
$$

$$
R_3=1k\Omega
$$

The natural frequency is:

$$
\omega_n^2=\frac{1}{C_1C_2R_2R_3}
$$

Substituting:

$$
\omega_n^2=\frac{1}{(100\times10^{-6})(10\times10^{-6})(2800)(1000)}
$$

$$
\omega_n^2=357.142857
$$

Therefore,

$$
\omega_n=\sqrt{357.142857}
$$

$$
\boxed{\omega_n=18.8982\ rad/s}
$$

### Required Butterworth $s$-Coefficient

For a second-order Butterworth system:

$$
H(s)=\frac{H\omega_n^2}{s^2+\sqrt{2}\omega_ns+\omega_n^2}
$$

Therefore, the required coefficient of $s$ is:

$$
\sqrt{2}\omega_n
$$

Substituting:

$$
\sqrt{2}(18.8982)
$$

$$
\boxed{26.7261}
$$

Therefore, our circuit must satisfy:

$$
\frac{1}{C_1}\left(\frac{1}{R_1}+\frac{1}{R_2}+\frac{1}{R_3}\right)=26.7261
$$

### Solve for $R_1$

Since

$$
C_1=100\times10^{-6}
$$

we have:

$$
\frac{1}{100\times10^{-6}}\left(\frac{1}{R_1}+\frac{1}{2800}+\frac{1}{1000}\right)=26.7261
$$

Therefore,

$$
\frac{1}{R_1}+\frac{1}{2800}+\frac{1}{1000}=26.7261(100\times10^{-6})
$$

$$
\frac{1}{R_1}+0.0003571429+0.001=0.0026726124
$$

Hence,

$$
\frac{1}{R_1}=0.0026726124-0.0003571429-0.001
$$

$$
\frac{1}{R_1}=0.0013154696
$$

Therefore,

$$
R_1=\frac{1}{0.0013154696}
$$

$$
\boxed{R_1=760.185\Omega}
$$

So the ideal value is approximately:

$$
\boxed{R_1\approx760.2\Omega}
$$

### Calculate the Required Gain $H$

From the circuit relationship:

$$
R_1H=R_3
$$

Therefore,

$$
H=\frac{R_3}{R_1}
$$

Substituting:

$$
H=\frac{1000}{760.185}
$$

$$
\boxed{H=1.31547}
$$

Thus, the gain required for the Butterworth condition, with the selected $C_1$, $C_2$, $R_2$, and $R_3$, is approximately:

$$
\boxed{H\approx1.3155}
$$

### Resulting Transfer Function

The Butterworth form is:

$$
H(s)=\frac{H\omega_n^2}{s^2+\sqrt{2}\omega_ns+\omega_n^2}
$$

We have:

$$
H=1.31547
$$

and

$$
\omega_n^2=357.142857
$$

Therefore, the numerator is:

$$
1.31547(357.142857)
$$

$$
\approx469.8107
$$

Hence,

$$
\boxed{H(s)=\frac{469.8107}{s^2+26.7261s+357.1429}}
$$

### Butterworth Damping Ratio Check

Comparing the denominator:

$$
s^2+26.7261s+357.1429
$$

with the standard second-order form:

$$
s^2+2\zeta\omega_ns+\omega_n^2
$$

we have:

$$
2\zeta\omega_n=26.7261
$$

Therefore,

$$
\zeta=\frac{26.7261}{2(18.8982)}
$$

$$
\boxed{\zeta=0.7071}
$$

Since:

$$
\frac{1}{\sqrt{2}}=0.7071
$$

we obtain:

$$
\boxed{\zeta=\frac{1}{\sqrt{2}}}
$$

Thus, the adjusted system satisfies the damping-ratio requirement for a second-order Butterworth response.
### Final Component Values

$$C_1=100\mu F$$

$$C_2=10\mu F$$

$$R_1=760.2\Omega$$

$$R_2=2.8k\Omega$$

$$R_3=1k\Omega$$

$$H=1.3155$$

### Final Transfer Function

$$H(s)=\frac{469.8107}{s^2+26.7261s+357.1429}$$

### Cutoff Frequency

$$\omega_c=18.8982\ rad/s$$

$$f_c\approx3.008\ Hz$$

### Damping Ratio

$$\zeta=0.7071=\frac{1}{\sqrt{2}}$$
## 15. Routh-Hurwitz Criterion

The characteristic equation is obtained from the denominator of the final transfer function:

$$s^2+26.7261s+357.1429=0$$

The Routh table is:

| Power of $s$ | First Column | Second Column |
|---|---:|---:|
| $s^2$ | $1$ | $357.1429$ |
| $s^1$ | $26.7261$ | $0$ |
| $s^0$ | $357.1429$ | — |

The first column is:

$$1,\quad 26.7261,\quad 357.1429$$

All elements in the first column are positive.

Therefore, there are no sign changes in the first column:

$$\boxed{\text{Number of sign changes}=0}$$

Hence, there are no roots in the right-half of the $s$-plane.

$$\boxed{\text{The system is stable}}$$

---

## 16. State-Space Representation

The final transfer function is:

$$H(s)=\frac{469.8107}{s^2+26.7261s+357.1429}$$

Therefore, the corresponding differential equation is:

$$\ddot{y}+26.7261\dot{y}+357.1429y=469.8107u$$

Define the state variables as:

$$x_1=y$$

$$x_2=\dot{y}$$

Therefore:

$$\dot{x}_1=x_2$$

$$\dot{x}_2=-357.1429x_1-26.7261x_2+469.8107u$$

The output equation is:

$$y=x_1$$

The state-space representation is:

$$\boxed{\dot{x}=Ax+Bu}$$

where:

$$
A =
\begin{bmatrix}
0 & 1 \\
-357.1429 & -26.7261
\end{bmatrix}
$$

$$
B =
\begin{bmatrix}
0 \\
469.8107
\end{bmatrix}
$$

The output equation is:

$$\boxed{y=Cx+Du}$$

where:

$$\boxed{C=\begin{bmatrix}1&0\end{bmatrix}}$$

$$\boxed{D=\begin{bmatrix}0\end{bmatrix}}$$

Hence, the complete state-space model is:

$$
\boxed{
\dot{x} =
\begin{bmatrix}
0 & 1 \\
-357.1429 & -26.7261
\end{bmatrix}
x +
\begin{bmatrix}
0 \\
469.8107
\end{bmatrix}
u
}
$$

$$\boxed{y=\begin{bmatrix}1&0\end{bmatrix}x}$$
