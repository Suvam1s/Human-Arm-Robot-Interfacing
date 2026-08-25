# Strain-Gauge-Based Human Arm Interface: Signal Conditioning, Control and Engineering Analysis

## Table of Contents

1. [Overview](#overview)
2. [What Is Actually Present in the Repository](#what-is-actually-present-in-the-repository)
3. [Role of the Strain Gauge in the Human-Arm Interface](#1-role-of-the-strain-gauge-in-the-human-arm-interface)
4. [Why So Much Development Is Necessary for a Strain Gauge](#2-why-so-much-development-is-necessary-for-a-strain-gauge)
5. [Significance of the Amplification Stage](#3-significance-of-the-amplification-stage)
6. [From Amplification to Signal Conditioning](#4-from-amplification-to-signal-conditioning)
7. [Why Filtering Is Important for Human Movement](#5-why-filtering-is-important-for-human-movement)
8. [Complete Mathematical Model of the Signal-Conditioning Chain](#6-complete-mathematical-model-of-the-signal-conditioning-chain)
9. [Dynamic Analysis and Verification](#7-dynamic-analysis-and-verification)
10. [Stability Verification Rather Than Assumption](#8-stability-verification-rather-than-assumption)
11. [Digital Signal Processing and Embedded Control](#9-digital-signal-processing-and-embedded-control)
12. [Why the Combination of Analog and Digital Processing Matters](#10-why-the-combination-of-analog-and-digital-processing-matters)
13. [What Skills This Part of the Project Demonstrates](#11-what-skills-this-part-of-the-project-demonstrates)
14. [Why This Is a Technology Demonstration Rather Than Just a Sensor Experiment](#12-why-this-is-a-technology-demonstration-rather-than-just-a-sensor-experiment)
15. [Engineering Significance of the Complete Work](#13-engineering-significance-of-the-complete-work)
16. [Conclusion](#conclusion)

---

## Overview

This work represents another major part of the **Human Arm Robot Interfacing** skill and technology demonstration project. While the broader project concerns the interfacing of human arm movement with a robotic system, this section focuses specifically on the sensing and control path based on a **strain gauge**.

The purpose of this section is not simply to demonstrate that a strain gauge can be connected to a microcontroller and used to move a servo. The work develops the complete signal-conditioning and control chain required to transform a very small mechanical-sensing signal into a stable, usable command for a robotic actuator. The repository therefore treats the strain-gauge interface as an engineering system involving sensing, analog amplification, filtering, mathematical modelling, control-oriented signal processing, embedded implementation, and verification.

The mathematical documentation in the project explicitly describes the strain-gauge subsystem as a skill demonstrator involving analog electronics, control-system theory, mathematical modelling and engineering verification. The design proceeds from the sensor equation, through amplifier design and filtering, to the complete transfer function and stability analysis rather than relying only on empirical trial and error.

---

# What Is Actually Present in the Repository

The `Strain Gauge Control` directory contains three main pieces of work:

- `StrainGaugeControl.cpp` — the embedded control implementation. It reads the strain-gauge signal through `A0`, applies an exponential filter, maps the filtered ADC range of `120–920` to a servo command range of `45–135°`, limits the command to that range, moves the servo incrementally at one degree per loop, and transmits the ADC value and servo angle over serial communication at `115200` baud. The loop includes a `20 ms` delay.
- `Circuit/` — contains the amplifier circuit, buffer with low-pass filter, full circuit, and `MathematicalCalculations.md`.
- `Matlab simulation/` — a separate simulation component is present in the project structure.

The mathematical document is particularly substantial. It derives the strain-gauge bridge equation, derives the amplifier in stages, examines CMRR and resistor mismatch, develops a second-order low-pass Butterworth filter using an MFB topology, combines the amplifier, buffer and filter into an overall transfer function, derives the time-domain response, evaluates the natural frequency, damping ratio, quality factor, damped frequency, pole locations, overshoot and settling time, and then performs DC-gain, stability, Routh-Hurwitz, and state-space checks.

The repository explicitly frames this work as a **skill demonstrator** for analog electronics, control-system theory, mathematical modelling, and engineering verification applied to the human-arm robot interface.

---

# 1. Role of the Strain Gauge in the Human-Arm Interface

The strain gauge is used as the sensing element for detecting mechanical deformation associated with movement of the human elbow.

A strain gauge operates by exploiting the relationship between **mechanical strain** and electrical resistance. When the gauge is mechanically deformed, its resistance changes. In a bridge configuration, these resistance changes are converted into a differential voltage.

The mathematical model used in this project represents the bridge output as

$$
V_o=
\frac{V_{in}}{4}
\left(
\frac{\Delta R_1}{R_1}-\frac{\Delta R_2}{R_2}+
\frac{\Delta R_3}{R_3}-
\frac{\Delta R_4}{R_4}
\right)
$$

This is the fundamental sensing principle behind the interface.

When the human arm bends at the elbow, the mechanical structure associated with the sensing arrangement experiences deformation. A strain gauge positioned so that this deformation is transferred to the gauge experiences a corresponding change in strain. The strain produces a change in the gauge resistance, and the bridge converts that very small resistance change into a differential electrical signal.

Thus, the measurement chain can be understood as:

$$
\text{Human elbow movement}
\rightarrow
\text{mechanical deformation}
\rightarrow
\text{strain}
\rightarrow
\Delta R
\rightarrow
\text{bridge voltage}
$$

The important point is that the strain gauge is therefore being used as an indirect measurement mechanism for elbow movement. It does not measure the elbow angle in degrees at the sensing element itself. Instead, it detects the mechanical strain associated with movement, and that electrical representation can subsequently be calibrated and mapped into a control variable.

That distinction is technically important in a human-machine interface: the sensor measures a physical quantity that is strongly related to the desired motion, while the subsequent signal-processing and control stages establish the useful relationship between sensor output and robotic motion.

---

# 2. Why So Much Development Is Necessary for a Strain Gauge

At first glance, a strain gauge may appear to be an unnecessarily elaborate sensing method for what seems like a simple objective: determine whether the arm is bending and command a servo accordingly.

The difficulty becomes clear when the magnitude of the electrical signal is considered.

The strain-gauge bridge output obtained in this project was approximately

$$
V_{bridge}\approx0.005\,V
$$

or approximately

$$
V_{bridge}\approx5\,mV.
$$

A signal on the order of only a few millivolts is extremely small compared with the voltage levels normally used by embedded electronics. Consequently, directly using this signal as a control variable would provide a very limited electrical representation of the mechanical motion.

The project therefore develops a dedicated signal-conditioning chain.

The mathematical analysis explicitly identifies the small output of the strain gauge as the reason amplification is required and derives an amplifier whose intended gain is approximately 1000.

The amplifier gain is derived as

$$
A=
\frac{R_{21}}{R_{11}}
\left(
1+\frac{2R_F}{R_G}
\right)
$$

and the design starts with a target gain of

$$
A=1000.
$$

Using

$$
R_F=24\,k\Omega
$$

and

$$
R_{21}=R_{22}=32\,k\Omega
$$

with

$$
R_{11}=R_{12}=1\,k\Omega,
$$

the required value of the gain-setting resistor is calculated to be approximately

$$
R_G\approx1546\,\Omega
$$

and then approximated to the practical value

$$
R_G=1.5\,k\Omega.
$$

The resulting practical amplifier gain is therefore somewhat different from the ideal nominal target. The later DC-gain calculation gives an overall amplifier gain of

$$
A_{amplifier}=1056.
$$

The complete signal-conditioning system consequently has a DC gain of

$$
A_{total}(0)=1056
$$

because the filter was intentionally designed for unity DC gain.

This illustrates why the project required considerably more engineering than simply placing a strain gauge on an analog input.

---

# 3. Significance of the Amplification Stage

Using the approximately \(0.005\,V\) bridge output supplied for this project, the importance of amplification can be seen directly.

With the experimentally relevant bridge signal represented as

$$
V_{in}\approx0.005\,V
$$

and the mathematically obtained overall DC gain

$$
A_{total}(0)=1056,
$$

the ideal linear output corresponding to this operating point would be

$$
V_{out}\approx1056(0.005)
$$

which gives

$$
V_{out}\approx5.28\,V.
$$

This calculation should be interpreted as the theoretical amplified signal level under linear operation; the actual physical output remains subject to the supply-voltage limits and headroom of the amplifier circuitry.

Nevertheless, the calculation demonstrates the central issue: a few millivolts of sensor information can be transformed into a signal on the order of volts, making the information much more practical for subsequent signal processing and interpretation.

Without this high-gain stage, the change produced by the strain gauge would occupy an extremely small electrical range. Noise, interference, offsets and other disturbances could therefore become significant relative to the desired signal.

The amplifier consequently performs much more than merely "making the voltage bigger." It establishes the electrical scale at which the sensor information becomes useful to the rest of the system.

The project also does not stop at calculating differential gain. It investigates the **common-mode rejection ratio**, including the influence of resistor-ratio mismatch. For a \(1\%\) mismatch parameter, the analysis obtains

$$
CMRR=3300.
$$

The purpose of this analysis is to examine how well the differential sensing architecture can distinguish the desired differential signal from common-mode components introduced by the physical and electronic environment.

This is a significant engineering consideration because the desired bridge signal is very small. When the useful differential voltage is small, unwanted common-mode contributions and component mismatch cannot simply be ignored.

---

# 4. From Amplification to Signal Conditioning

Amplification alone does not guarantee a good control signal.

A large signal can still be unsuitable for a control system if it contains rapid variations or unwanted high-frequency components.

The project's mathematical documentation therefore adds a dedicated **second-order low-pass Butterworth filtering stage** after the amplifier. The purpose is to preserve the slower signal variations associated with human elbow movement while attenuating unwanted higher-frequency disturbances.

The filter is developed mathematically from its circuit representation rather than being introduced as an arbitrary collection of resistor and capacitor values.

The repository derives the MFB low-pass transfer function and compares it with the standard second-order Butterworth form:

$$
H(s)=
\frac{H\omega^2}
{s^2+0.707\omega s+\omega^2}
$$

with

$$
Q=0.707.
$$

The derived practical component values are

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

and

$$
C_2=10\,\mu F,
$$

with

$$
H=1.
$$

The unity-gain choice is deliberate: the project already establishes the required large gain in the amplifier stage, so the filter is intended to perform the frequency-selective conditioning without introducing additional unwanted gain.

---

# 5. Why Filtering Is Important for Human Movement

Human elbow motion is comparatively slow relative to many sources of electrical disturbance.

A strain-gauge interface can therefore benefit from a low-pass architecture because the desired motion information is contained in relatively slow variations, while unwanted rapid fluctuations can be attenuated.

The project calculates the practical second-order system to have

$$
\omega_n=18.8982\,rad/s
$$

corresponding to approximately

$$
f_n\approx3.007\,Hz.
$$

The calculated damped frequency is

$$
\omega_d\approx14.773\,rad/s
$$

or

$$
f_d\approx2.351\,Hz.
$$

These values describe the dynamics of the designed signal-conditioning system and establish the frequency-domain behaviour that the subsequent control implementation has to work with.

The practical component values do not produce an exactly ideal Butterworth damping ratio. Instead, the calculated damping ratio is

$$
\zeta=0.6236
$$

compared with the ideal second-order Butterworth value

$$
\zeta_{Butterworth}=0.7071.
$$

The resulting deviation is approximately

$$
11.81\%.
$$

The project explicitly identifies this difference as a consequence of practical component-value approximation rather than claiming that the physical implementation is mathematically identical to the ideal filter.

This is an important engineering distinction. The design does not simply assume that an ideal equation automatically describes the practical circuit. Instead, the actual selected component values are substituted back into the model and the resulting deviation is quantified.

---

# 6. Complete Mathematical Model of the Signal-Conditioning Chain

The system is treated as a cascade of functional blocks.

The amplifier gain is represented as

$$
A_1=
\left(
\frac{R_{21}}{R_{11}}
\right)
\left(
1+\frac{2R_F}{R_G}
\right).
$$

The buffer has unity gain:

$$
A_{buffer}=1.
$$

The filter is represented by its second-order transfer function

$$
A_2(s)=
\frac{
\frac{H}{C_1C_2R_2R_3}
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
}.
$$

Because the stages are cascaded, the overall transfer function becomes

$$
A_{total}(s)=A_1A_{buffer}A_2(s).
$$

Since the buffer has unity gain,

$$
A_{total}(s)=A_1A_2(s).
$$

After substituting the selected practical component values, the complete system becomes

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

which is the final mathematical representation developed for the signal-conditioning architecture.

This is one of the strongest aspects of the work because the project is not limited to an isolated circuit calculation. The individual physical stages are converted into a single system-level model.

The same system can therefore be viewed from several engineering perspectives:

$$
\text{Sensor}
\rightarrow
\text{Amplifier}
\rightarrow
\text{Buffer}
\rightarrow
\text{Low-pass Filter}
\rightarrow
\text{Digital Processing}
\rightarrow
\text{Actuator}
$$

and mathematically as one overall input-output system described by the transfer function above.

---

# 7. Dynamic Analysis and Verification

The project then treats the signal-conditioning chain as a second-order dynamic system.

From the denominator

$$
s^2+23.57142857s+357.142857
$$

the system parameters are extracted by comparison with the standard second-order form

$$
s^2+2\zeta\omega_n s+\omega_n^2.
$$

The calculated values include

$$
\omega_n=18.8982\,rad/s,
$$

$$
\zeta=0.6236,
$$

$$
Q\approx0.8017,
$$

and

$$
\omega_d\approx14.773\,rad/s.
$$

The resulting poles are

$$
s_{1,2}=-11.786\pm j14.773.
$$

Because the real parts of the poles are negative, the system is stable. The damping ratio also places the system in the underdamped region. The calculated percentage overshoot is approximately

$$
8.16\%.
$$

The estimated \(2\%\) settling time is

$$
T_s(2\%)\approx0.339\,s
$$

while the \(5\%\) settling-time approximation is

$$
T_s(5\%)\approx0.255\,s.
$$

These calculations allow the designer to understand not merely whether the signal is filtered, but how the conditioned signal behaves dynamically.

The analysis also checks the DC behaviour.

The filter has

$$
H(0)=1
$$

which confirms its unity DC gain, while the complete system has

$$
A_{total}(0)=1056.
$$

This agrees with the independently calculated amplifier gain of \(1056\), providing an internal consistency check between the circuit design and the system transfer function.

---

# 8. Stability Verification Rather Than Assumption

Another technically important feature of this project is that stability is not merely asserted.

The characteristic equation is

$$
s^2+23.57142857s+357.142857=0.
$$

The project explicitly verifies stability using the **Routh-Hurwitz criterion**.

The corresponding Routh table has the first column

$$
1,\qquad
23.57142857,\qquad
357.142857.
$$

Since all first-column elements are positive, there are no sign changes and therefore no right-half-plane poles.

The resulting conclusion is

$$
\boxed{\text{Number of right-half-plane poles}=0}
$$

and therefore

$$
\boxed{\text{The system is stable}}.
$$

The project additionally develops a state-space representation, giving another system-level mathematical representation of the same transfer function.

This is significant from a skills perspective because it demonstrates a movement beyond "I designed a circuit that works."

The workflow is instead:

$$
\text{Design}
\rightarrow
\text{Model}
\rightarrow
\text{Calculate}
\rightarrow
\text{Verify}
\rightarrow
\text{Implement}
$$

That is much closer to an engineering design methodology.

---

# 9. Digital Signal Processing and Embedded Control

The analog signal-conditioning chain is followed by a digital control implementation.

The embedded program uses the strain-gauge signal on

```cpp
const int strainPin = A0;
# 9. Digital Signal Processing and Embedded Control

The analog signal-conditioning chain is followed by a digital control implementation.

The embedded program uses the strain-gauge signal on

```cpp
const int strainPin = A0;
```

and drives the wrist servo on

```cpp
const int servoPin = D3;
```

The program begins by initializing serial communication at

$$
115200\,baud
$$

and initializes the filtered signal from the initial analog measurement. The servo starts at

$$
90^\circ
$$

During operation, the raw ADC signal is continuously acquired and passed through the recursive filter

$$
filtered=\alpha\,raw+(1-\alpha)\,filtered
$$

with

$$
\alpha=0.12
$$

This is an exponential smoothing operation. It provides a second layer of signal conditioning in the digital domain after the analog conditioning performed by the circuit.

The filtered ADC value is then mapped from the calibrated input range

$$
120\le ADC\le920
$$

to the actuator angle range

$$
45^\circ\le\theta\le135^\circ
$$

The command is explicitly constrained to the same range.

The actuator does not immediately jump to the target angle. Instead, the code changes the current angle by

$$
1^\circ
$$

per control iteration until the current angle reaches the target.

The loop is then repeated after a

$$
20\,ms
$$

delay.

Consequently, the digital stage performs four important operations:

$$
\text{measurement}
\rightarrow
\text{digital smoothing}
\rightarrow
\text{calibration/mapping}
\rightarrow
\text{controlled actuator motion}
$$

The serial output also reports both the raw ADC measurement and the resulting servo angle, providing a direct means of observing the sensing-to-actuation relationship during operation.

---

# 10. Why the Combination of Analog and Digital Processing Matters

One of the most meaningful aspects of this implementation is that the project does not rely exclusively on either analog electronics or software filtering.

The analog section establishes the electrical signal quality before the measurement reaches the microcontroller. The amplifier raises the tiny bridge signal to a usable level, while the second-order low-pass filter suppresses unwanted high-frequency content.

The microcontroller then performs an additional digital smoothing operation using

$$
filtered=0.12(raw)+0.88(filtered)
$$

This separation of responsibilities is useful because the two stages operate at different points in the signal chain.

The analog circuitry addresses the physical acquisition problem:

$$
\text{millivolt sensor signal}
\rightarrow
\text{amplified and frequency-conditioned voltage}
$$

while the embedded software addresses the control problem:

$$
\text{conditioned measurement}
\rightarrow
\text{stable numerical command}
\rightarrow
\text{servo position}
$$

The resulting architecture therefore demonstrates a complete sensing and control pipeline rather than a simple sensor-reading program.

---

# 11. What Skills This Part of the Project Demonstrates

This section of the Human Arm Robot Interfacing project demonstrates a considerably broader set of engineering skills than the use of a strain gauge alone would suggest.

## Analog Electronics

The work involves designing an amplifier specifically around the electrical characteristics of a very small strain-gauge bridge output. The amplifier gain is derived from circuit equations and component values rather than selected arbitrarily.

## Differential Signal Conditioning

The strain-gauge bridge produces a differential measurement, and the amplifier analysis therefore includes differential gain and common-mode rejection. The project explicitly examines the effect of resistor mismatch on CMRR.

## Filter Design

The system incorporates a second-order low-pass filter based on an MFB topology. The transfer function is derived and compared against the standard Butterworth form.

## Mathematical Modelling

The physical circuit is converted into a mathematical transfer function, culminating in

$$
A_{total}(s)=
\frac{377142.857}
{s^2+23.57142857s+357.142857}
$$

This establishes a direct mathematical relationship between the circuit design and its dynamic behaviour.

## Laplace-Domain Analysis

The work proceeds into the Laplace domain, allowing the circuit to be treated using classical control-system and linear-systems analysis.

## Dynamic-System Analysis

Natural frequency, damping ratio, quality factor, damped frequency, poles, overshoot and settling time are all explicitly evaluated.

## Stability Analysis

The system is verified using pole locations and the Routh-Hurwitz criterion rather than assuming stability.

## State-Space Modelling

The project additionally represents the transfer function in state-space form, demonstrating an ability to move between different mathematical representations of the same system.

## Embedded Control

The final signal is acquired using an ADC, filtered numerically, calibrated through an ADC-to-angle mapping, constrained to a valid actuator range, and applied incrementally to the servo.

## Engineering Verification

The design repeatedly checks whether the mathematical result agrees with the intended behaviour. The project explicitly includes DC-gain checks, filter-gain checks, stability checks, sanity checks, Routh-Hurwitz verification and final comparison of practical and ideal filter behaviour.

---

# 12. Why This Is a Technology Demonstration Rather Than Just a Sensor Experiment

The distinction between a sensor experiment and this implementation is substantial.

A basic strain-gauge experiment could stop after demonstrating that bending changes the resistance or produces a measurable bridge voltage.

This project continues much further.

The sensing element is incorporated into a complete engineering chain:

$$
\boxed{
\text{Human movement}
\rightarrow
\text{Strain}
\rightarrow
\text{Resistance variation}
\rightarrow
\text{Bridge voltage}
\rightarrow
\text{Amplification}
\rightarrow
\text{Low-pass conditioning}
\rightarrow
\text{Digital filtering}
\rightarrow
\text{Angle mapping}
\rightarrow
\text{Servo actuation}
}
$$

Each stage exists because the preceding stage produces a signal that is not yet ideal for the following one.

The bridge produces a very small voltage.

The amplifier solves the amplitude problem.

The low-pass stage solves the frequency-conditioning problem.

The digital smoothing stage further conditions the sampled measurement.

The ADC mapping converts the conditioned measurement into a usable actuator command.

The incremental servo update prevents the command from simply jumping directly to the target.

The mathematical model then provides a way of analysing and defending the behaviour of the analog signal-conditioning system.

This is precisely why considerable development is justified even though the physical sensing element is "only a strain gauge." The difficulty is not the existence of the sensor; it is transforming a very small, mechanically derived measurement into a reliable control signal that can participate in a human-machine interface.

---

# 13. Engineering Significance of the Complete Work

The strongest characteristic of this section is therefore the connection between **physical sensing, analog signal conditioning, control theory, and embedded implementation**.

The approximately $5\,mV$ bridge output illustrates the starting point. Such a small differential signal cannot simply be treated as a ready-made actuator command. It has to be electrically conditioned.

The project accordingly establishes an amplifier stage with a final calculated DC gain of $1056$, a unity-gain second-order low-pass stage, and a complete transfer function describing the resulting dynamics.

The practical filter response is shown not to be perfectly identical to the ideal Butterworth response; its damping ratio is $0.6236$, compared with the ideal $0.7071$, giving an approximately $11.81\%$ deviation. Rather than hiding this deviation, the project quantifies it and attributes it to practical component-value approximation.

The resulting system remains stable, underdamped and second order, with unity DC filter gain and an overall DC gain of $1056$.

The embedded implementation then takes the conditioned measurement and turns it into a physical servo command using calibrated ADC limits, digital smoothing and bounded incremental position control.

This makes the strain-gauge subsystem a demonstration of how a real engineering system moves from **physics to electronics, from electronics to mathematics, and from mathematics to software-controlled actuation**.

---

# Conclusion

The strain-gauge section of the Human Arm Robot Interfacing project demonstrates that reliable human-motion interfacing is fundamentally a **signal-conditioning and control problem**, not merely a sensor-selection problem.

The strain gauge provides a means of converting mechanical deformation associated with human elbow movement into a change in electrical resistance. The bridge translates that resistance variation into a differential voltage, but the resulting signal is extremely small; in this implementation, the bridge output was approximately $0.005\,V$. This small signal motivates the use of a high-gain differential amplification stage.

The project derives the amplifier mathematically and arrives at a practical overall amplifier gain of $1056$. A second-order low-pass filter is then developed to condition the resulting signal, with the filter deliberately maintaining unity DC gain so that the principal amplification remains in the dedicated amplifier stage.

The entire analog chain is represented by the system model

$$
\boxed{
A_{total}(s)=
\frac{377142.857}
{s^2+23.57142857s+357.142857}
}
$$

and this model is subjected to dynamic and stability analysis. The calculated poles have negative real parts, the Routh-Hurwitz criterion passes, the system is stable and underdamped, the filter has unity DC gain, and the overall DC gain is $1056$.

Finally, the conditioned signal is processed by embedded software. The microcontroller applies exponential smoothing with $\alpha=0.12$, maps the calibrated ADC range $120–920$ to $45–135^\circ$, constrains the command to that range, and incrementally drives the servo.

Therefore, this part of the project demonstrates a complete engineering workflow:

$$
\boxed{
\text{Mechanical sensing}
\rightarrow
\text{Analog electronics}
\rightarrow
\text{Signal conditioning}
\rightarrow
\text{Mathematical modelling}
\rightarrow
\text{Control analysis}
\rightarrow
\text{Digital processing}
\rightarrow
\text{Robotic actuation}
}
$$

The significant achievement is not simply that a strain gauge was made to move a servo. The significant achievement is that a very small physical sensor signal was developed into a mathematically analysed, frequency-conditioned, digitally processed and actuator-ready signal path, with the individual stages being derived, modelled and verified rather than treated as unexplained black boxes.
