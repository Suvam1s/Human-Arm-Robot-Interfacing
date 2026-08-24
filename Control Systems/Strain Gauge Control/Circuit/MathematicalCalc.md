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
