# Flex Sensor Control

## Contents

- **`Circuits/`** — Contains the physical filter design, circuit schematic, mathematical derivation, component calculations, and root-locus analysis.
  - **`flex_sensor_filter.kicad_sch`** — KiCad schematic of the designed filter circuit.
  - **`Lowpass filter.png`** — Visual representation of the low-pass filter circuit.
  - **`MathematicalCalculation.md`** — Complete mathematical development of the filter, including the transfer-function derivation, Butterworth design, component selection, damping verification, stability analysis, state-space representation, and root-locus-based tuning.
  - **`RootLocus.py`** — Python implementation used to generate and analyse the root-locus behaviour of the system. :contentReference[oaicite:0]{index=0}

- **`Matlab simulation/`** — Contains the MATLAB-based analysis and simulation of the filter and its response to sensor data.
  - **`Control Data extraction/`** — Contains the MATLAB processing used to generate a noisy flex-sensor signal, pass it through the designed filter, and examine the resulting filtered control signal.
    - **`ControlData_Extraction_Using_Filter.m`** — MATLAB simulation and signal-processing script.
    - **`output simulation.png`** — Resulting simulation output. :contentReference[oaicite:1]{index=1}
  - **`Lowpass Filter trans data/`** — Contains the broader MATLAB analysis of the Butterworth active low-pass filter and its system characteristics.
    - **`ButterWorth_active_Lowpass filter_(MFB_topology)_Matlab_analysis_Code.m`** — MATLAB analysis code.
    - **`3D s plane.png`** — Three-dimensional s-plane representation.
    - **`Bode Plot.png`** — Bode-response analysis.
    - **`Frequency Response.png`** — Frequency-response analysis.
    - **`Group Delay.png`** — Group-delay analysis.
    - **`Impulse Response.png`** — Impulse-response analysis.
    - **`Nyquist Diagram.png`** — Nyquist analysis.
    - **`Pole-Zero Map.png`** — Pole-zero analysis.
    - **`Step Response.png`** — Step-response analysis. :contentReference[oaicite:2]{index=2}

- **`Flexsensorcontrol.cpp`** — Embedded control implementation for the flex-sensor-to-servo interface. It reads the flex sensor through the ESP32 ADC, applies an exponential moving average for real-time smoothing, maps the calibrated sensor range to the servo angle, limits the commanded angle, and drives the elbow servo progressively toward the target position. :contentReference[oaicite:3]{index=3}
- ## Overview

This section implements the control and signal-conditioning layer of the human-arm robotic interface. The primary purpose of this subsystem is to convert the physical movement of the human elbow into a clean and usable control signal for the robotic system. A flex sensor is used to measure the change associated with elbow movement, while the control system processes the sensor output before it is used to command the robotic actuator.

The raw output of a flex sensor is not an ideal control signal by itself. Real sensor measurements can contain rapid fluctuations, electrical interference, environmental disturbances, and other unwanted variations that are not representative of the actual movement of the human arm. If these variations were directly transferred to the robotic actuator, they could result in unnecessary or unstable actuator movement. The signal-conditioning stage is therefore responsible for separating the useful movement information from unwanted high-frequency variations.

The central filtering element of this subsystem is a second-order Butterworth low-pass filter. The filter is designed around the intended frequency range of human elbow movement so that the relatively slow movement of the arm can pass through while higher-frequency disturbances are progressively attenuated. This makes the filtered signal more suitable for use as a control reference.

The design process is not limited to selecting a commercially available filter configuration. The circuit is mathematically modelled from its components, its transfer behaviour is derived, and the component values are selected according to the desired response. The resulting system is then examined using classical control-system analysis and numerical simulation before being incorporated into the embedded control implementation.

The complete development therefore connects the physical sensor, analogue signal conditioning, mathematical modelling, simulation, and embedded control into a single signal-processing chain.

The development is divided into three connected stages:

- **Circuit design and mathematical modelling** establish the physical filtering system and its theoretical behaviour.
- **MATLAB and Python analysis** examine the filter response and system characteristics from multiple control-system perspectives.
- **Embedded implementation** applies the sensor processing and actuator control in real time using the ESP32.

Together, these stages provide a progression from theoretical design to computational verification and finally to practical robotic control.

---

## Circuit Design and Mathematical Analysis

The `Circuits` directory contains the hardware-level design of the signal-conditioning system together with the mathematical development used to justify the design.

The circuit is based around an active low-pass filter configuration intended to provide the required signal-conditioning behaviour for the flex sensor. The circuit schematic is developed in KiCad, allowing the physical arrangement and electrical connections of the components to be represented before implementation.

The mathematical analysis begins from the circuit itself rather than treating the filter as an unexplained black box. The currents and node relationships within the circuit are considered to obtain the system transfer behaviour. This provides a direct connection between the physical resistor and capacitor values and the resulting dynamic characteristics of the filter.

The component-selection process is then carried out according to the desired Butterworth response. The design considers the intended movement bandwidth and uses this requirement to determine appropriate component values. The resulting component selection is subsequently checked against the desired characteristics of the filter.

The mathematical document also examines the resulting system from a classical control perspective. This includes verification of the damping behaviour and system stability, together with additional analysis of the pole locations. The purpose of these additional analyses is not simply to produce mathematical results, but to demonstrate that the designed circuit behaves consistently with the theoretical model.

The KiCad schematic represents the physical implementation of the filter, while the accompanying mathematical documentation provides the reasoning behind the selected circuit parameters.

The Python root-locus analysis provides another perspective on the same system. Rather than treating the selected gain as a fixed value, the analysis investigates how the system poles move as the gain parameter changes. This makes it possible to visualise the relationship between gain selection and the resulting dynamic behaviour.

The root-locus analysis is included as an additional control-systems analysis and skill demonstration. It provides a graphical interpretation of the pole movement and allows the desired operating point to be examined in relation to the damping characteristics of the system.

The `Circuits` directory therefore represents the theoretical and physical foundation of the entire control subsystem: the schematic describes the hardware, the mathematical calculation describes its behaviour, and the root-locus analysis provides an additional graphical interpretation of its dynamics.

---

## MATLAB Simulation

The MATLAB section evaluates the designed filter independently from the physical circuit and embedded implementation. This provides a controlled environment in which the behaviour of the filter can be examined before relying on the actual hardware.

The first part of the MATLAB work focuses on the relationship between a representative flex-sensor signal and the filtering process. A simulated movement signal is combined with different forms of unwanted variation in order to represent the type of disturbances that may be encountered during practical operation.

The simulated signal includes components representing mains-frequency interference, higher-frequency disturbances, and random noise. These additions are useful because they provide a more realistic representation of the difference between an ideal movement signal and an actual sensor measurement.

The resulting signal is then passed through the designed low-pass filter. The filtered output can subsequently be compared with the original movement information to observe how the unwanted high-frequency components are suppressed while the lower-frequency movement information is retained.

This simulation is particularly important for the robotic application because the purpose of the filter is not simply to produce a mathematically correct response. The ultimate objective is to obtain a signal that can be interpreted reliably by the robotic control system.

The MATLAB analysis also examines the filter as a classical control system. Multiple system-response representations are generated to study different aspects of the same design. These include frequency-domain behaviour, time-domain behaviour, pole locations, stability characteristics, and other system-response properties.

The frequency-domain analysis provides an understanding of how the filter responds to different input frequencies. The time-domain analyses provide insight into how the system behaves when subjected to changes in its input. Pole-related analysis provides information about the dynamic characteristics and stability of the system.

Using several representations is useful because no single plot completely describes a dynamic system. The frequency response shows what happens across the input spectrum, while the time-domain responses show how the system behaves over time. The pole and stability analyses provide another layer of verification by examining the underlying system dynamics.

The MATLAB simulations therefore act as a bridge between the mathematical derivation and the eventual physical implementation. They allow the theoretical design to be tested computationally and provide visual evidence of the expected filtering behaviour before the system is used for real-time robotic control.

---

## Embedded Control

The `Flexsensorcontrol.cpp` program represents the real-time implementation of the flex-sensor control subsystem. While the circuit and simulation establish the theoretical and computational behaviour of the system, the embedded program is responsible for processing actual sensor measurements and converting them into actuator commands.

The ESP32 acquires the flex-sensor signal through its analogue-to-digital converter. This provides a digital representation of the physical sensor measurement that can be processed by the embedded control program.

The measured signal is subjected to real-time smoothing using an exponential moving average. This additional digital processing reduces rapid fluctuations in the sensor measurement and helps prevent small variations from being interpreted as meaningful changes in the desired robotic position.

After signal conditioning, the calibrated sensor range is converted into a corresponding servo-angle command. This creates the direct relationship between human elbow movement and robotic actuator movement.

The resulting command is constrained within the permitted operating range of the servo. This prevents the control system from requesting positions outside the intended mechanical limits and provides an additional layer of protection between the processed sensor signal and the actuator.

The servo is then moved progressively toward the requested position rather than responding to every instantaneous sensor variation as an independent command. This contributes to smoother actuator behaviour and reduces unnecessary abrupt movements.

The embedded implementation therefore performs the final stages of the signal-processing chain:

**sensor measurement → signal conditioning → movement interpretation → command limiting → servo actuation**

This architecture allows the physical movement of the human arm to be translated into a corresponding robotic movement while reducing the influence of unwanted sensor variations.

The embedded implementation also demonstrates how the theoretical filtering and control concepts are ultimately connected to an actual microcontroller-based robotic system. The mathematical model and simulations describe the intended behaviour, while the ESP32 implementation applies the signal-processing and control logic to real sensor data.

---

## Overall Structure

The complete `Flex Sensor Control` section combines physical circuit design, mathematical control-system modelling, computational analysis, signal simulation, and embedded implementation into a single development workflow.

The **circuit stage** establishes the physical signal-conditioning system. It defines how the electrical components are arranged and provides the hardware through which the sensor signal is conditioned.

The **mathematical stage** develops a model of the circuit and determines how its component values influence the overall system behaviour. This stage provides the theoretical justification for the selected filter configuration rather than relying solely on experimental tuning.

The **control-system analysis stage** examines the resulting dynamic system using classical methods. The system's frequency behaviour, time response, pole locations, damping characteristics, and stability can therefore be considered from multiple perspectives. The root-locus analysis additionally demonstrates how changing the selected gain affects the system poles.

The **MATLAB simulation stage** then applies the designed filter to representative sensor signals containing both useful movement information and unwanted disturbances. This provides a practical demonstration of the filtering objective and allows the expected behaviour to be observed before deployment.

Finally, the **embedded stage** transfers the signal-processing and control concept into the ESP32-based implementation. The physical sensor is sampled, the resulting signal is conditioned, the movement is interpreted, and the corresponding servo command is generated.

This creates a continuous development path:

**Physical movement → Flex sensor → Signal conditioning → Mathematical model → Simulation and analysis → Embedded processing → Robotic actuator**

Each stage has a distinct purpose, but the stages are directly connected. The circuit provides the physical filtering mechanism, the mathematical model explains its behaviour, the simulations verify that behaviour, and the embedded implementation turns the processed sensor information into an actual robotic movement.

The result is therefore not simply a low-pass filter placed between a sensor and a microcontroller. It is a complete signal-conditioning and control subsystem developed from the physical sensing requirement through theoretical modelling, computational verification, and real-time implementation.
