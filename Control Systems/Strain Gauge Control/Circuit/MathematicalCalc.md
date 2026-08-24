# Introduction

This mathematical analysis presents the complete modelling, derivation, and verification of the signal-conditioning and control architecture developed for the human-arm robot interfacing system. The primary purpose of the work is not to present the circuit merely as a functional prototype, but as a skill demonstrator that illustrates the application of analog electronics, control-system theory, mathematical modelling, and engineering verification to a practical human-machine interfacing problem. The system begins with a strain-gauge-based sensing mechanism intended to capture variations associated with human elbow movement. Since the raw sensor signal is susceptible to amplification requirements and unwanted high-frequency disturbances, appropriate signal-conditioning stages are incorporated before the resulting command is supplied to the robotic interface.

The analysis therefore follows a structured engineering approach rather than relying exclusively on empirical component selection. The amplifier stages are mathematically derived to establish the required signal gain, followed by the development of a second-order low-pass filtering stage designed around the expected frequency range of human elbow motion. The filter is analysed from its circuit equations through the Laplace-domain representation and ultimately incorporated into the overall system transfer function. Practical component values are then substituted explicitly into the derived equations, allowing the theoretical model to remain directly traceable to the physical circuit. The resulting system is subsequently examined through its natural frequency, damping ratio, quality factor, damped frequency, pole locations, transient response characteristics, DC gain, and stability conditions. Additional validation is performed using the Routh-Hurwitz criterion and state-space representation, providing multiple independent methods of checking the same physical system. In this sense, the mathematical development is intended to demonstrate not only the ability to obtain an answer, but also the ability to question, verify, and defend that answer—because in engineering, a calculation that has never been sanity-checked is essentially just a very confident guess.

# Mathematical Calculations
### Strain Gauge Formula

$$
V_o=\frac{V_{in}}{4}
\left(
\frac{\Delta R_1}{R_1}
-\frac{\Delta R_2}{R_2}
+\frac{\Delta R_3}{R_3}
-\frac{\Delta R_4}{R_4}
\right)
$$


## Amplifier Designing

### Stage 1

Applying Kirchhoff's law at the output of $V_{A1}$ and $V_{A2}$:

$$
I=\frac{V_{A2}-V_{A1}}
{R_{F11}+R_G+R_{F12}}
$$

As $R_{F11}$, $R_G$ and $R_{F12}$ are in series.

Also,

$$
I=\frac{V_1-V_2}{R_G}
$$

where:

$$
V_1=\text{Input 1}
$$

$$
V_2=\text{Input 2}
$$

Substituting equation (1B) in equation (1A):

$$
\frac{V_1-V_2}{R_G}=\frac{V_{A2}-V_{A1}}{R_{F11}+R_G+R_{F12}}
$$

For $R_{F11}=R_{F12}=R_F$:

$$
\frac{(V_1-V_2)(2R_F+R_G)}{R_G}=V_{A2}-V_{A1}
$$

Therefore,

$$
(V_1-V_2)\left(\frac{2R_F}{R_G}+1\right)=V_{A2}-V_{A1}
$$

Hence, the gain of Stage 1 is:

$$
A_1=\left(1+\frac{2R_F}{R_G}\right)
$$


### Stage 2

If we now have a subtractor:

$$
\text{Gain}=\frac{V_o}{V_{in}}=\frac{R_{21}}{R_{11}}
$$

Now,

$$
V_{in}=(V_{A2}-V_{A1})
$$

Therefore,

$$
V_o=\frac{R_{21}}{R_{11}}(V_{A2}-V_{A1})
$$

Substituting Stage 2 in Stage 1:

$$
V_o=\frac{R_{21}}{R_{11}}\left(1+\frac{2R_F}{R_G}\right)(V_2-V_1)
$$

Since,

$$
V_2-V_1=V_{in}
$$

we get:

$$
\frac{V_o}{V_{in}}=\frac{R_{21}}{R_{11}}\left(1+\frac{2R_F}{R_G}\right)
$$

Therefore,

$$
A=\frac{R_{21}}{R_{11}}\left(1+\frac{2R_F}{R_G}\right)
$$


Now, as a strain gauge has a very small output, we need to amplify the output using the above amplifier.

Let:

$$
\text{Gain}=1000
$$

$$
R_F=24000\,\Omega=24\,k\Omega
$$

$$
R_2=R_{21}=R_{22}=32000\,\Omega=32\,k\Omega
$$

$$
R_1=R_{11}=R_{12}=1000\,\Omega=1\,k\Omega
$$

Substituting the above values in equation (2):

$$
1000=\frac{32000}{1000}\left(1+\frac{2\times24000}{R_G}\right)
$$

Therefore,

$$
R_G\approx1546\,\Omega
$$

$$
R_G\approx1500\,\Omega=1.5\,k\Omega
$$


### CMRR

The common-mode rejection ratio is given by:

$$
CMRR=\frac{A_d}{|A_{cm}|}
$$

Let:

$$
\frac{R_2}{R_1}=k
$$

and let the resistor-ratio mismatch be represented by $\epsilon$.

The differential gain is:

$$
V_o=kV_{A2}-k(1+\epsilon)V_{A1}
$$

Here,

$$
V_{out}=k\left(1+\frac{2R_F}{R_G}\right)(V_2-V_1)
$$

and

$$
V_{din}=(V_2-V_1)
$$

Therefore,

$$
A_d=\frac{R_2}{R_1}\left(1+\frac{2R_F}{R_G}\right)
$$


The common-mode gain is:

$$
A_{cm}=\frac{V_{out}}{V_{cm}}=\frac{V_o}{\frac{V_{A2}-V_{A1}}{2}}
$$


### General Non-Ideal Difference Amplifier

For a non-ideal difference amplifier:

$$
V_o={A2}-k(1+\epsilon)V_{A1}
$$

Also,

$$
V_o=A_d(\omega)V_d+A_{cm}(\omega)V_{cm}
$$

For common-mode operation:

$$
V_{A2}=V_{A1}=V_{cm}
$$

Therefore,

$$
V_o=kV_{cm}-k(1+\epsilon)V_{cm}
$$

$$
V_o=kV_{cm}-kV_{cm}-k\epsilon V_{cm}
$$

$$
V_o=-k\epsilon V_{cm}
$$

Therefore,

$$
A_{cm}=\frac{-k\epsilon V_{cm}}{V_{cm}}
$$

$$
A_{cm}=-k\epsilon
$$

Since,

$$
k=\frac{R_2}{R_1}
$$

we get:

$$
A_{cm}=-\frac{R_2}{R_1}\epsilon
$$

Thus,

$$
CMRR=\frac{\frac{R_2}{R_1}\left(1+\frac{2R_F}{R_G}\right)}{\frac{R_2}{R_1}\epsilon}
$$

Therefore,

$$
CMRR=\frac{1+\frac{2R_F}{R_G}}{\epsilon}
$$


### Testing of CMRR of Our Designed Amplifier

Here,

$$
R_F=24\,k\Omega=24000\,\Omega
$$

$$
R_G=1500\,\Omega
$$

Let:

$$
\epsilon=0.01
$$

Therefore,

$$
CMRR=
\frac{
1+\frac{2\times24000}{1500}
}{0.01}
$$

$$
CMRR=3300
$$

Therefore, at $1\%$ resistor mismatch:

$$
CMRR=3300
$$

This is not great, but not bad.


### Low-Pass Butterworth Filter

From our previously derived equation of the low-pass Butterworth filter using MFB topology, we have:

$$
H(s)=
\frac{
\frac{H}{C_1C_2R_2R_1}
}{
s^2+
s\left(
\frac{1}{C_1}
\left(
\frac{1}{R_1}
+\frac{1}{R_2}
+\frac{1}{R_3}
\right)
\right)
+
\frac{1}{C_1C_2R_2R_3}
}
$$

The general low-pass Butterworth filter transfer function is:

$$
H(s)=
\frac{H\omega^2}
{s^2+0.707\omega s+\omega^2}
$$

where $H$ is the overall gain.

Also,

$$
Q=0.707
$$


After comparing, we can figure out the following relationships:

$$
\frac{1}{C_1R_2C_2R_3}=\omega^2
$$

and

$$
\omega^2H=\frac{1}{C_1C_2R_2R_1}
$$

Substituting the value of $\omega^2$:

$$
\frac{1}{C_1R_2C_2R_3}H=\frac{1}{C_1C_2R_2R_1}
$$

Therefore,

$$
R_1H=R_3
$$

Also,

$$
0.707\omega=
\frac{1}{C_1}
\left(
\frac{1}{R_1}
+\frac{1}{R_2}
+\frac{1}{R_3}
\right)
$$


Now let $H=1$, as we do not need any unwanted gain for this filter after our amplifier.

Therefore,

$$
R_1=R_3
$$

Taking all the values from our previous derivation, we will get:

$$
R_1=1000\,\Omega
$$

$$
R_2=2.8\,k\Omega
$$

$$
R_3=1000\,\Omega
$$

$$
C_1=100\,\mu F
$$

$$
C_2=10\,\mu F
$$


### Final Circuit Model

Now from our above final circuit we can model it as:

$$
A_1=
\left(
\frac{R_{21}}{R_{11}}
\right)
\left(
1+\frac{2R_F}{R_G}
\right)
$$

where $A_1$ is the amplifier gain.

The filter transfer function is:

$$
A_2(s)=
\frac{
\frac{H}{C_1C_2R_2R_3}
}{
s^2+
s\left(
\frac{1}{C_1}
\left(
\frac{1}{R_1}
+\frac{1}{R_2}
+\frac{1}{R_3}
\right)
\right)
+
\frac{1}{C_1C_2R_2R_3}
}
$$

The buffer gain is:

$$
A_{buffer}=1
$$

Cascading the above equations, as all are in series:

$$
A_1A_{buffer}A_2(s)=A_{total}(s)
$$

Since,

$$
A_{buffer}=1
$$

we get:

$$
A_1A_2(s)=A_{total}(s)
$$

Further substituting the values of the equations:

$$
A_{total}(s)=
\left(
\frac{R_{21}}{R_{11}}
\right)
\left(
1+\frac{2R_F}{R_G}
\right)
\frac{
\frac{H}{C_1C_2R_2R_3}
}{
s^2+
s\left(
\frac{1}{C_1}
\left(
\frac{1}{R_1}
+\frac{1}{R_2}
+\frac{1}{R_3}
\right)
\right)
+
\frac{1}{C_1C_2R_2R_3}
}
$$

Therefore,

$$
A_{total}(s)=
\frac{
\left(
\frac{R_{21}}{R_{11}}
\right)
\left(
1+\frac{2R_F}{R_G}
\right)
\left(
\frac{H}{C_1C_2R_2R_3}
\right)
}{
s^2+
s\left(
\frac{1}{C_1}
\left(
\frac{1}{R_1}
+\frac{1}{R_2}
+\frac{1}{R_3}
\right)
\right)
+
\frac{1}{C_1C_2R_2R_3}
}
$$

Let:

$$
K=
\left(
\frac{R_{21}}{R_{11}}
\right)
\left(
1+\frac{2R_F}{R_G}
\right)
\left(
\frac{H}{C_1C_2R_2R_3}
\right)
$$

Therefore,

$$
A_{total}(s)=
\frac{K}{s^2+as+b}
$$

where:

$$
a=
\frac{1}{C_1}
\left(
\frac{1}{R_1}
+\frac{1}{R_2}
+\frac{1}{R_3}
\right)
$$

and

$$
b=
\frac{1}{C_1C_2R_2R_3}
$$


### Inverse Laplace Transform

Performing inverse Laplace transform on the above equation:

$$
\mathcal{L}^{-1}
\left(
\frac{1}{s}
\right)
=1
$$

Also,

$$
\mathcal{L}^{-1}
\left(
\frac{s+a}{s^2+as+b}
\right)=
e^{-Q\omega_nt}
\left(
\cos(\omega_dt)
+
\frac{Q}{\sqrt{1-Q^2}}
\sin(\omega_dt)
\right)
$$

The standard denominator for a Butterworth filter is:

$$
s^2+\sqrt{2}\omega_ns+\omega_n^2
$$

Comparing with:

$$
s^2+\frac{1}{Q}\omega_ns+\omega_n^2=
s^2+as+b
$$

Therefore,

$$
Q=\frac{1}{\sqrt{2}}
$$

Also,

$$
\omega_n=\sqrt{b}
$$

Therefore,

$$
\omega_n=
\sqrt{
\frac{1}{C_1C_2R_2R_3}
}
$$

Since,

$$
a=\sqrt{2}\omega_n
$$

The natural damped frequency is:

$$
\omega_d=
\omega_n\sqrt{1-Q^2}
$$

and

$$
Q=\frac{1}{\sqrt{2}}
$$

Therefore,

$$
\omega_d=
\frac{\omega_n}{\sqrt{2}}
$$


Now from all the above equations we get:

$$
y(t)=
\frac{K}{b}
\left[
1-
e^{-Q\omega_nt}
\left(
\cos(\omega_dt)
+
\frac{Q}{\sqrt{1-Q^2}}
\sin(\omega_dt)
\right)
\right]
$$

Substituting $Q=0.707$ and $\omega_d=\frac{\omega_n}{\sqrt{2}}$:

$$
y(t)=
\frac{K}{b}
\left[
1-
e^{-0.707\omega_nt}
\left(
\cos\left(\frac{\omega_n}{\sqrt{2}}t\right)
+
\frac{0.707}{\sqrt{1-(0.707)^2}}
\sin\left(\frac{\omega_n}{\sqrt{2}}t\right)
\right)
\right]
$$

Since,

$$
\frac{0.707}{\sqrt{1-(0.707)^2}}
\approx 1
$$

we get:

$$
y(t)=
\frac{K}{b}
\left[
1-
e^{-0.707\omega_nt}
\left(
\cos\left(\frac{\omega_n}{\sqrt{2}}t\right)
+
\sin\left(\frac{\omega_n}{\sqrt{2}}t\right)
\right)
\right]
$$

where:

$$
K=
\left(
\frac{R_{21}}{R_{11}}
\right)
\left(
1+\frac{2R_F}{R_G}
\right)
\left(
\frac{H}{C_1C_2R_2R_3}
\right)
$$

and

$$
b=
\frac{1}{C_1C_2R_2R_3}
$$


### Step Response

Step response of an LTI system:

$$
Y(s)=X(s)H(s)
$$

Therefore,

$$
Y(s)=u(t)A_{total}(s)
$$

For a unit step:

$$
U(s)=\frac{1}{s}
$$

Therefore,

$$
Y(s)=
\frac{1}{s}
\cdot
\frac{K}{s^2+as+b}
$$


By partial fractions:

$$
\frac{K}{s(s^2+as+b)}=
\frac{A}{s}
+
\frac{Bs+C}{s^2+as+b}
$$

Multiplying the whole equation by $s(s^2+as+b)$:

$$
K=
A(s^2+as+b)
+
Bs^2
+
Cs
$$

Therefore,

$$
K=
As^2+Aas+Ab+Bs^2+Cs
$$

$$
K=
s^2(A+B)
+
s(Aa+C)
+
Ab
$$


Comparing both sides:

$$
A+B=0
$$

$$
Aa+C=0
$$

$$
Ab=K
$$

Therefore,

$$
A=\frac{K}{b}
$$

$$
C=-\frac{Ka}{b}
$$

$$
B=-\frac{K}{b}
$$


Substituting the above values in equation (iii):

$$
Y(s)=
\frac{K}{b}\frac{1}{s}
+
\frac{
-\frac{Ka}{b}
-\frac{K}{b}s
}{
s^2+as+b
}
$$

Therefore,

$$
Y(s)=
\frac{K}{b}
\left[
1-
\frac{s+a}{s^2+as+b}
\right]
$$


### Final Step Response

Substituting the above $K$ value into equation (V):

$$
y(t)=
\left(
\frac{R_{21}}{R_{11}}
\right)
\left(
1+\frac{2R_F}{R_G}
\right)
\left(
\frac{H}{C_1C_2R_2R_3}
\right)
\left(
C_1C_2R_2R_3
\right)
\left[
1-
e^{-0.707\omega_nt}
\left(
\cos\left(\frac{\omega_n}{\sqrt{2}}t\right)
+
\sin\left(\frac{\omega_n}{\sqrt{2}}t\right)
\right)
\right]
$$

Therefore, the final step response equation is:

$$
y(t)=\left(\frac{R_{21}}{R_{11}}\right)\left(1+\frac{2R_F}{R_G}\right)H\frac{R_2}{R_1}\left[1-e^{-0.707\omega_nt}\left(\cos\left(\frac{\omega_n}{\sqrt{2}}t\right)+\sin\left(\frac{\omega_n}{\sqrt{2}}t\right)\right)\right]
$$

### Final Component Values and Transfer Function

The final component values selected for the circuit are:

$$
R_{21}=32\,k\Omega
$$

$$
R_{11}=1\,k\Omega
$$

$$
R_F=24\,k\Omega
$$

$$
R_G=1.5\,k\Omega
$$

$$
R_1=1\,k\Omega
$$

$$
R_2=2.8\,k\Omega
$$

$$
R_3=1\,k\Omega
$$

$$
C_1=100\,\mu F
$$

$$
C_2=10\,\mu F
$$

$$
H=1
$$

The complete transfer function of the system is:

$$
A_{total}(s)=
\frac{
\left(\frac{R_{21}}{R_{11}}\right)
\left(1+\frac{2R_F}{R_G}\right)
\left(\frac{H}{C_1C_2R_2R_3}\right)
}{
s^2+
s\left[
\frac{1}{C_1}
\left(
\frac{1}{R_1}
+\frac{1}{R_2}
+\frac{1}{R_3}
\right)
\right]
+
\frac{1}{C_1C_2R_2R_3}
}
$$

Substituting the Values

Substituting all the selected component values into the above equation:

$$
A_{total}(s)=
\frac{
\left(\frac{32\times10^3}{1\times10^3}\right)
\left(
1+\frac{2(24\times10^3)}
{1.5\times10^3}
\right)
\left(
\frac{1}
{
(100\times10^{-6})
(10\times10^{-6})
(2.8\times10^3)
(1\times10^3)
}
\right)
}{
s^2+
s\left[
\frac{1}{100\times10^{-6}}
\left(
\frac{1}{1\times10^3}
+\frac{1}{2.8\times10^3}
+\frac{1}{1\times10^3}
\right)
\right]
+
\frac{1}
{
(100\times10^{-6})
(10\times10^{-6})
(2.8\times10^3)
(1\times10^3)
}
}
$$

Calculating the individual terms:

$$
\frac{32\times10^3}{1\times10^3}=
32
$$

$$
1+\frac{2(24\times10^3)}{1.5\times10^3}=
33
$$

and:

$$
\frac{1}
{
(100\times10^{-6})
(10\times10^{-6})
(2.8\times10^3)
(1\times10^3)
}=
357.142857
$$

Therefore, the numerator becomes:

$$
32(33)(357.142857)=
377142.857
$$

The coefficient of $s$ is:

$$
\frac{1}{100\times10^{-6}}
\left(
\frac{1}{1\times10^3}
+\frac{1}{2.8\times10^3}
+\frac{1}{1\times10^3}
\right)=
23.57142857
$$

Therefore:

$$
A_{total}(s)=
\frac{
377142.857
}{
s^2+23.57142857s+357.142857
}
$$

Hence, the final transfer function of the complete system is:

$$
\boxed{
A_{total}(s)=
\frac{
377142.857
}{
s^2+23.57142857s+357.142857
}
}
$$

### System Sanity Checks

The final transfer function obtained for the complete system is:

$$
A_{total}(s)=
\frac{377142.857}
{s^2+23.57142857s+357.142857}
$$

To verify the correctness and behaviour of the designed system, the denominator is compared with the standard second-order system equation.

The standard second-order denominator is:

$$
s^2+2\zeta\omega_n s+\omega_n^2
$$

Comparing this with:

$$
s^2+23.57142857s+357.142857
$$

we obtain:

$$
2\zeta\omega_n=23.57142857
$$

and:

$$
\omega_n^2=357.142857
$$

1. Natural Frequency

From:

$$
\omega_n^2=357.142857
$$

we get:

$$
\omega_n=\sqrt{357.142857}
$$

Therefore:

$$
\boxed{\omega_n=18.8982\ rad/s}
$$

The natural frequency in Hertz is:

$$
f_n=\frac{\omega_n}{2\pi}
$$

Substituting:

$$
f_n=\frac{18.8982}{2\pi}
$$

Therefore:

$$
\boxed{f_n\approx3.007\ Hz}
$$


2. Damping Ratio

From the standard second-order equation:

$$
2\zeta\omega_n=23.57142857
$$

Therefore:

$$
\zeta=
\frac{23.57142857}{2\omega_n}
$$

Substituting $\omega_n=18.8982$:

$$
\zeta=
\frac{23.57142857}
{2(18.8982)}
$$

$$
\zeta=
\frac{23.57142857}{37.7964}
$$

Therefore:

$$
\boxed{\zeta\approx0.6236}
$$


3. Damping Classification

The calculated damping ratio is:

$$
\zeta=0.6236
$$

For a second-order system:

- If $\zeta=0$, the system is undamped.
- If $0<\zeta<1$, the system is underdamped.
- If $\zeta=1$, the system is critically damped.
- If $\zeta>1$, the system is overdamped.

Since:

$$
0<0.6236<1
$$

the system is:

$$
\boxed{\text{Underdamped}}
$$

Therefore, the step response is expected to contain a decaying oscillatory component.


4. Quality Factor

The relationship between damping ratio and quality factor is:

$$
Q=\frac{1}{2\zeta}
$$

Substituting:

$$
Q=
\frac{1}{2(0.6236)}
$$

Therefore:

$$
\boxed{Q\approx0.8017}
$$


5. Butterworth Damping Ratio Check

For an ideal second-order Butterworth filter:

$$
\zeta_{Butterworth}=
\frac{1}{\sqrt{2}}
$$

Therefore:

$$
\boxed{\zeta_{Butterworth}\approx0.7071}
$$

The actual damping ratio obtained from the selected component values is:

$$
\zeta_{actual}=0.6236
$$

The difference is:

$$
\Delta\zeta=
0.7071-0.6236
$$

$$
\Delta\zeta=0.0835
$$

The percentage deviation is:

$$
\text{Deviation}=
\frac{
0.7071-0.6236
}{
0.7071
}
\times100
$$

Therefore:

$$
\boxed{
\text{Deviation}\approx11.81\%
}
$$

Thus, the practical component values do not produce an exact theoretical Butterworth response, but the damping ratio remains reasonably close to the ideal value.


6. Butterworth $s$-Coefficient Check

For an ideal second-order Butterworth system:

$$
\zeta=\frac{1}{\sqrt{2}}
$$

Therefore:

$$
2\zeta\omega_n=
2
\left(
\frac{1}{\sqrt{2}}
\right)
\omega_n
$$

which simplifies to:

$$
2\zeta\omega_n=
\sqrt{2}\omega_n
$$

Using:

$$
\omega_n=18.8982\ rad/s
$$

we obtain:

$$
\sqrt{2}(18.8982)=
26.7261
$$

The actual coefficient of $s$ in the transfer function is:

$$
23.5714
$$

Therefore:

$$
\boxed{
23.5714\neq26.7261
}
$$

This confirms that the selected practical component values do not produce an exact Butterworth response.

The deviation originates from the practical component selection, particularly the approximation of the required resistor values.


7. Damped Natural Frequency

For an underdamped second-order system:

$$
\omega_d=
\omega_n\sqrt{1-\zeta^2}
$$

Substituting:

$$
\omega_d=
18.8982
\sqrt{1-(0.6236)^2}
$$

Therefore:

$$
\boxed{
\omega_d\approx14.773\ rad/s
}
$$

The damped frequency in Hertz is:

$$
f_d=
\frac{\omega_d}{2\pi}
$$

Therefore:

$$
f_d=
\frac{14.773}{2\pi}
$$

$$
\boxed{
f_d\approx2.351\ Hz
}
$$


8. Pole Location Check

For a second-order system, the poles are given by:

$$
s_{1,2}=
-\zeta\omega_n
\pm
j\omega_d
$$

First calculate:

$$
\zeta\omega_n=
0.6236(18.8982)
$$

$$
\zeta\omega_n
\approx11.7857
$$

Therefore:

$$
s_{1,2}=
-11.7857
\pm
j14.773
$$

Thus, the poles are:

$$
\boxed{
s_{1,2}=
-11.786
\pm
j14.773
}
$$

The real part of both poles is negative:

The real part of both poles is negative:

$$
\mathrm{Re}(s)<0
$$

Therefore:

$$
\boxed{\text{The system is stable}}
$$

9. Percent Overshoot

For an underdamped second-order system, the percentage overshoot is:

$$
\%OS=
100e^{
-\frac{\zeta\pi}
{\sqrt{1-\zeta^2}}
}
$$

Substituting $\zeta=0.6236$:

$$
\%OS=
100e^{
-\frac{0.6236\pi}
{\sqrt{1-(0.6236)^2}}
}
$$

Therefore:

$$
\boxed{
\%OS\approx8.16\%
}
$$

Thus, the output is expected to overshoot its final value by approximately $8.16\%$ before settling.


10. Settling Time

For the standard $2\%$ settling-time approximation:

$$
T_s\approx
\frac{4}{\zeta\omega_n}
$$

We already have:

$$
\zeta\omega_n\approx11.7857
$$

Therefore:

$$
T_s=
\frac{4}{11.7857}
$$

Hence:

$$
\boxed{
T_s\approx0.339\ s
}
$$

Therefore, the response is expected to settle within approximately:

$$
\boxed{339\ ms}
$$

For the $5\%$ settling-time approximation:

$$
T_s\approx
\frac{3}{\zeta\omega_n}
$$

Therefore:

$$
T_s=
\frac{3}{11.7857}
$$

$$
\boxed{
T_s\approx0.255\ s
}
$$


11. DC Gain Check

The DC gain is obtained by evaluating the transfer function at:

$$
s=0
$$

Therefore:

$$
A_{total}(0)=
\frac{377142.857}
{357.142857}
$$

Hence:

$$
\boxed{
A_{total}(0)=1056
}
$$

The amplifier gain was previously calculated as:

$$
A_{amplifier}=1056
$$

and the filter was designed with:

$$
H=1
$$

Therefore:

$$
A_{total}=
A_{amplifier}\times H
$$

$$
A_{total}=
1056\times1
$$

$$
\boxed{
A_{total}=1056
}
$$

The DC gain calculation therefore agrees with the expected cascaded gain.

$$
\boxed{\text{DC gain check passed}}
$$


12. Filter DC Gain Check

The filter transfer function is:

$$
H(s)=
\frac{
357.142857
}{
s^2+23.57142857s+357.142857
}
$$

At DC:

$$
s=0
$$

Therefore:

$$
H(0)=
\frac{357.142857}
{357.142857}
$$

Thus:

$$
\boxed{
H(0)=1
}
$$

This confirms that the filter has unity DC gain as intended.

$$
\boxed{\text{Filter DC gain check passed}}
$$


13. Stability Check

The characteristic equation is obtained from the denominator:

$$
s^2+23.57142857s+357.142857=0
$$

For a second-order polynomial:

$$
s^2+a_1s+a_0
$$

the system is stable when:

$$
a_1>0
$$

and:

$$
a_0>0
$$

Here:

$$
a_1=23.57142857>0
$$

and:

$$
a_0=357.142857>0
$$

Therefore:

$$
\boxed{\text{The system is stable}}
$$

This agrees with the pole-location analysis.


14. Overall Sanity Check

The final system characteristics are:

$$
\omega_n=18.8982\ rad/s
$$

$$
f_n\approx3.007\ Hz
$$

$$
\zeta\approx0.6236
$$

$$
Q\approx0.8017
$$

$$
\omega_d\approx14.773\ rad/s
$$

$$
f_d\approx2.351\ Hz
$$

$$
s_{1,2}=
-11.786\pm j14.773
$$

$$
\%OS\approx8.16\%
$$

$$
T_s(2\%)\approx0.339\ s
$$

$$
T_s(5\%)\approx0.255\ s
$$

$$
H(0)=1
$$

$$
A_{total}(0)=1056
$$


15. Sanity Check Summary

| Parameter | Calculated Value | Expected/Reference | Check |
|---|---:|---:|---|
| Natural frequency $\omega_n$ | $18.8982\ rad/s$ | Positive | Passed |
| Natural frequency $f_n$ | $3.007\ Hz$ | Positive | Passed |
| Damping ratio $\zeta$ | $0.6236$ | $0<\zeta<1$ | Passed |
| Ideal Butterworth $\zeta$ | $0.7071$ | $0.7071$ | Reference |
| Butterworth deviation | $11.81\%$ | $0\%$ ideal | Approximation |
| Quality factor $Q$ | $0.8017$ | Positive | Passed |
| Damped frequency $\omega_d$ | $14.773\ rad/s$ | Less than $\omega_n$ | Passed |
| Pole locations | $-11.786\pm j14.773$ | Negative real part | Passed |
| System damping | Underdamped | $0<\zeta<1$ | Passed |
| System stability | Stable | Negative pole real parts | Passed |
| Percent overshoot | $8.16\%$ | Consistent with underdamping | Passed |
| $2\%$ settling time | $0.339\ s$ | Finite | Passed |
| $5\%$ settling time | $0.255\ s$ | Finite | Passed |
| Filter DC gain | $1$ | Unity gain | Passed |
| Total DC gain | $1056$ | Amplifier gain $\times$ filter gain | Passed |


16. Final Verification

The complete transfer function obtained from the selected practical component values is:

$$
\boxed{
A_{total}(s)=
\frac{377142.857}
{s^2+23.57142857s+357.142857}
}
$$

The sanity checks show that the system is:

$$
\boxed{\text{Stable}}
$$

$$
\boxed{\text{Underdamped}}
$$

$$
\boxed{\text{Second-order}}
$$

and has:

$$
\boxed{\text{Unity DC filter gain}}
$$

and:

$$
\boxed{\text{Overall DC gain}=1056}
$$

The calculated damping ratio is:

$$
\boxed{\zeta=0.6236}
$$

compared with the ideal second-order Butterworth value:

$$
\boxed{\zeta_{Butterworth}=0.7071}
$$

giving a deviation of approximately:

$$
\text{Deviation}\approx11.81\%
$$

Therefore, the selected practical component values result in a response that is close to, but not exactly equal to, the ideal Butterworth response. The deviation is primarily due to the practical approximation of component values.

The system remains stable and exhibits the expected characteristics of a second-order low-pass system.

### Routh-Hurwitz Criterion

The final transfer function of the complete system is:

$$
A_{total}(s)=
\frac{377142.857}
{s^2+23.57142857s+357.142857}
$$

The characteristic equation is obtained from the denominator:

$$
s^2+23.57142857s+357.142857=0
$$

For a second-order polynomial:

$$
a_2s^2+a_1s+a_0=0
$$

the Routh-Hurwitz table is:

$$
\begin{bmatrix}{c|cc}
s^2 & a_2 & a_0 \\
s^1 & a_1 & 0 \\
s^0 & a_0 & 0
\end{bmatrix}
$$

For the given system:

$$
a_2=1
$$

$$
a_1=23.57142857
$$

$$
a_0=357.142857
$$

Therefore, the Routh table becomes:

$$
\begin{bmatrix}{c|cc}
s^2 & 1 & 357.142857 \\
s^1 & 23.57142857 & 0 \\
s^0 & 357.142857 & 0
\end{bmatrix}
$$

The first column is:

$$
1
$$

$$
23.57142857
$$

$$
357.142857
$$

All elements in the first column are positive:

$$
1>0
$$

$$
23.57142857>0
$$

$$
357.142857>0
$$

There are therefore no sign changes in the first column.

Hence:

$$
\boxed{\text{Number of right-half-plane poles}=0}
$$

Therefore, according to the Routh-Hurwitz criterion:

$$
\boxed{\text{The system is stable}}
$$

The Routh-Hurwitz criterion therefore passes:

$$
\boxed{\text{Routh-Hurwitz Criterion: PASSED}}
$$

---

### State-Space Representation

The transfer function is:

$$
A_{total}(s)=
\frac{377142.857}
{s^2+23.57142857s+357.142857}
$$

The standard state-space representation is:

$$
\dot{x}=Ax+Bu
$$

$$
y=Cx+Du
$$

The transfer function can be written in the standard form:

$$
G(s)=
\frac{b_0}
{s^2+a_1s+a_0}
$$

Comparing with the given transfer function:

$$
G(s)=
\frac{377142.857}
{s^2+23.57142857s+357.142857}
$$

we obtain:

$$
a_1=23.57142857
$$

$$
a_0=357.142857
$$

and:

$$
b_0=377142.857
$$

1. State Variables

For the controllable canonical form, the state variables are chosen as:

$$
x_1=y
$$

and:

$$
x_2=\dot{y}
$$

The transfer-function equation is:

$$
s^2Y(s)
+
23.57142857sY(s)
+
357.142857Y(s)=
377142.857U(s)
$$

Taking the inverse Laplace transform:

$$
\ddot{y}
+
23.57142857\dot{y}
+
357.142857y=
377142.857u
$$

Rearranging:

$$
\ddot{y}=
-23.57142857\dot{y}
-357.142857y
+377142.857u
$$

Since:

$$
x_1=y
$$

and:

$$
x_2=\dot{y}
$$

we obtain:

$$
\dot{x}_1=x_2
$$

and:

$$
\dot{x}_2=
-357.142857x_1
-23.57142857x_2
+377142.857u
$$

2. State-Space Matrices

The state-space model is:

$$
\dot{x}=Ax+Bu
$$

where:

$$
x=
\begin{bmatrix}
x_1\\
x_2
\end{bmatrix}
$$

The state matrix is:

$$
\boxed{
A=
\begin{bmatrix}
0 & 1\\
-357.142857 & -23.57142857
\end{bmatrix}
}
$$

The input matrix is:

$$
\boxed{
B=
\begin{bmatrix}
0\\
377142.857
\end{bmatrix}
}
$$

Since:

$$
y=x_1
$$

the output matrix is:

$$
\boxed{C=
\begin{bmatrix}
1 & 0
\end{bmatrix}
}
$$

There is no direct feedthrough from the input to the output:

$$
\boxed{D=0}
$$

Therefore, the complete state-space model is:

$$
\boxed{
\dot{x}=
\begin{bmatrix}
0 & 1\\
-357.142857 & -23.57142857
\end{bmatrix}
x
+
\begin{bmatrix}
0\\
377142.857
\end{bmatrix}
u
}
$$

and:

$$
\boxed{
y=
\begin{bmatrix}
1 & 0
\end{bmatrix}x
}
$$

---

#### State-Space Stability Check

The eigenvalues of the state matrix $A$ correspond to the poles of the system.

The characteristic equation is:

$$
\det(sI-A)=0
$$

The matrix $sI-A$ is:

$$
sI-A=
\begin{bmatrix}
s & -1\\
357.142857 & s+23.57142857
\end{bmatrix}
$$

Therefore:

$$
\det(sI-A)=
s(s+23.57142857)+357.142857
$$

Expanding:

$$
s^2+23.57142857s+357.142857=0
$$

This is identical to the original characteristic equation.

Therefore, the eigenvalues are:

$$
\boxed{
\lambda_{1,2}=
-11.786\pm j14.773
}
$$

Since the real parts of both eigenvalues are negative, the state-space model is stable:

$$
\boxed{\text{The state-space model is stable}}
$$

---

#### Final Stability Verification

The stability of the system has now been verified using three independent methods.

1. Pole Analysis

The poles are:

$$
s_{1,2}=
-11.786\pm j14.773
$$

Both poles have negative real parts.

Therefore:

$$
\boxed{\text{Stable}}
$$

2. Routh-Hurwitz Analysis

The first column of the Routh table is:

$$
1,\quad23.57142857,\quad357.142857
$$

There are no sign changes.

Therefore:

$$
\boxed{\text{Stable}}
$$

3. State-Space Eigenvalue Analysis

The eigenvalues of the state matrix are:

$$
\lambda_{1,2}=
-11.786\pm j14.773
$$

Both eigenvalues have negative real parts.

Therefore:

$$
\boxed{\text{Stable}}
$$

All three methods produce the same result:

$$
\boxed{
\text{The complete system is asymptotically stable.}
}
$$

# Conclusion

The completed analysis demonstrates a complete engineering workflow for translating a physical human-motion sensing problem into a mathematically characterised signal-processing and control system. The final model combines the amplifier and filtering stages into a second-order transfer function and provides quantitative insight into how the implemented circuit responds to an input generated by human elbow movement. The calculated natural frequency of approximately $18.8982\ rad/s$, damping ratio of approximately $0.6236$, quality factor of approximately $0.8017$, damped frequency of approximately $14.773\ rad/s$, and pole locations of approximately $-11.786\pm j14.773$ collectively establish the dynamic behaviour of the system. The calculated overshoot and settling time further provide an estimate of the transient behaviour that can be expected when the system responds to changes in the sensor input. The unity DC gain of the filter and the overall low-frequency gain of $1056$ were independently verified, ensuring that the derived transfer function remains consistent with the intended gain structure of the circuit.

An important aspect of this work is that the final result is evaluated against the ideal mathematical design rather than being declared correct merely because the equations produce a numerical answer. The calculated damping ratio differs from the ideal second-order Butterworth value of $0.7071$ by approximately $11.81%$. This difference demonstrates the practical consequence of selecting real component values instead of theoretically perfect values and provides an opportunity to evaluate the distinction between an idealised filter and its practical implementation. Rather than treating this deviation as a failure, it forms part of the engineering validation process: the deviation is quantified, its effect on the system dynamics is identified, and the resulting behaviour is checked for stability and suitability. The Routh-Hurwitz criterion produces no right-half-plane poles, while the state-space eigenvalues independently reproduce the same stable pole locations obtained from the transfer-function analysis. The agreement between these independent methods strengthens confidence in the mathematical model and demonstrates that the derivation is internally consistent.

Ultimately, the value of this work as a skill demonstrator lies not simply in the final circuit or transfer function, but in the methodology used to reach and validate them. The project demonstrates the ability to move between physical sensing, circuit-level equations, frequency-domain analysis, Laplace-domain modelling, control-system parameters, stability theory, and state-space representation while maintaining a traceable connection between theoretical calculations and practical hardware. It also demonstrates an important engineering habit: when the mathematics says something unexpected, the appropriate response is not to quietly edit the number until it looks nicer, but to investigate why it happened. In that respect, the approximately $11.81%$ Butterworth deviation is arguably as useful as an exact theoretical result because it shows the transition from ideal textbook design to practical engineering judgement. The system may therefore be regarded not only as a functional human-arm robotic interface, but as a compact demonstration of multidisciplinary engineering capability—where the signals are conditioned, the equations are checked, the poles behave themselves, and, fortunately, nothing needed to be taken personally.
