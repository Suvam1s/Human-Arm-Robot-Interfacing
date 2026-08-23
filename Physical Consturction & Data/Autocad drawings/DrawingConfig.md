# Human Motion Controlled Robotic Arm

## Overview

This project presents a low-cost human motion-controlled robotic arm designed to replicate natural arm movements using wearable sensors. The robotic arm follows a master-slave architecture where human joint motions are captured through sensors and translated into corresponding servo motor movements in real time.

The system is built using an ESP32 microcontroller and combines multiple sensing techniques including an IMU, flex sensor, and strain gauge to control different joints of the robotic arm.

---

# Features

- Human arm motion replication
- Real-time control using ESP32
- Shoulder Pitch control using MPU6050
- Shoulder Yaw control using MPU6050
- Elbow control using conditioned Flex Sensor
- Wrist Bend control using conditioned Strain Gauge
- Lightweight PVC frame
- Spring-assisted elbow support
- Modular mechanical design
- Expandable architecture for additional DOFs

---

# Degrees of Freedom

| Joint | Sensor | Actuator |
|--------|---------|----------|
| Shoulder Pitch | MPU6050 | 20kg Digital Servo |
| Shoulder Yaw | MPU6050 | 360° High Torque Servo |
| Elbow | Flex Sensor | MG995 Servo |
| Wrist Bend | Strain Gauge | SG90 Servo |

Total Controlled DOF: **4**

---

# Mechanical Design

The robotic arm consists of two primary links representing the human upper arm and forearm.

## Robot Dimensions

The following table summarizes the principal dimensions of the 5R human-arm-inspired robotic manipulator. The dimensions are defined according to the coordinate system used in the kinematic analysis, with the corresponding direction of movement along the X, Y, or Z axis.

| Anatomical / Robot Section | Dimension | Direction |
|---|---:|---|
| Base → Shoulder | 5 cm | +Z |
| Shoulder Offset | 2.5 cm | +Y |
| **Upper Arm (Humerus)** | **16.5 cm** | **+Z** |
| Upper Arm Offset | 1 cm | +Y |
| **Forearm (Elbow → Wrist)** | **17.5 cm** | **+Z** |
| Forearm Offset | 1 cm | −Y |
| Wrist Section | 1.5 cm | +X |
---

# Actuator Configuration

## Shoulder Assembly

### Shoulder Pitch

- Servo: **20kg High Speed Digital Servo**
- Function:
  - Raises and lowers the arm.
  - Supports the majority of the arm load.

---

### Shoulder Yaw

- Servo: **360° High Torque Servo**
- Function:
  - Rotates the entire arm horizontally.
  - Provides base rotational movement.

---

## Elbow

Servo:

- MG995 (≈12 kg·cm)

Function:

- Controls elbow flexion and extension.

Additional Support:

- Spring assisted mechanism
- Metal reinforcement strip

Purpose:

- Reduces load on elbow servo
- Improves stability
- Increases lifting capability

---

## Wrist

Servo:

- SG90 Micro Servo

Function:

- Wrist bending

Controlled using:

- Four element strain gauge sensing system.

---

# Sensors

## MPU6050

Mounted near the shoulder.

Measures:

- 3-axis Accelerometer
- 3-axis Gyroscope

Used for:

- Shoulder Pitch
- Shoulder Yaw estimation

---

## Flex Sensor

Mounted over the human elbow.

Purpose:

- Detect elbow bending.

Signal:

- Conditioned analog output
- Read by ESP32 ADC.

---

## Four Strain Gauge System

Mounted at the wrist.

Purpose:

- Detect wrist bending.

Signal:

- Wheatstone bridge
- Amplified
- Signal conditioned
- Analog output to ESP32

---

# Structural Components

- PVC Hollow Square Pipe
- Metal Servo Mounts
- Metal Base Brackets
- Ball Bearing Support
- Compression Spring
- Metal Reinforcement Strip
- Nuts and Bolts

---

# Ball Bearing Support

Diameter:

- **3.5 cm**

Thickness:

- **1.5 cm**

Purpose:

- Supports shoulder rotation
- Reduces friction
- Improves rotational smoothness

---

# Control Architecture

```
             Human Arm

          MPU6050
        /          \
 Shoulder Pitch   Shoulder Yaw

      Flex Sensor
          │
       Elbow

 Four Strain Gauges
          │
      Wrist Bend

          │
       ESP32 Controller

          │

  -----------------------------
 | Shoulder Pitch Servo       |
 | Shoulder Yaw Servo         |
 | Elbow Servo               |
 | Wrist Servo               |
  -----------------------------

          │

      Robotic Arm
```

---

# Electronics

- ESP32 Development Board
- MPU6050 IMU
- Flex Sensor
- Four Strain Gauges
- Signal Conditioning Circuit
- Servo Power Supply
- Servo Drivers (PWM)

---

# Software

- Arduino IDE
- C++
- ESP32Servo Library
- Wire Library
- MPU6050 Library

---

# Motion Strategy

This robotic arm does **not perform autonomous path planning**.

Instead, it operates using **real-time joint angle mapping**, where:

1. Human joint movement is measured.
2. Sensor data is conditioned.
3. ESP32 converts sensor values into joint angles.
4. Servo motors replicate the human motion.

This master-slave approach provides intuitive and responsive teleoperation.

---

# Mechanical Assistance

To improve lifting capability:

- Spring-assisted elbow support reduces the torque required from the elbow servo.
- Metal reinforcement strip increases structural rigidity.
- Ball bearing support reduces shoulder friction.
- Lightweight PVC links minimize overall inertia.

---

# Future Improvements

- Inverse Kinematics
- Autonomous Path Planning
- ROS2 Integration
- Computer Vision
- Wireless Teleoperation
- Gripper Force Feedback
- Object Detection
- Machine Learning Assisted Motion Prediction

---

# Repository Contents

```
├── CAD/
│   ├── Front View
│   ├── Side View
│   ├── Assembly Drawings
│
├── Firmware/
│   ├── ESP32 Code
│
├── Electronics/
│   ├── Signal Conditioning
│   ├── Sensor Circuits
│
├── Images/
│
└── README.md
```

---

