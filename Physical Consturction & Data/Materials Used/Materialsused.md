# Materials Used

## 1. ESP32 Development Board

The ESP32 microcontroller serves as the central processing unit of the robotic arm. It acquires data from all sensing modules, processes the signals, and generates PWM outputs to control the servo motors. The ESP32 was selected due to its high processing speed, multiple ADC channels, numerous GPIO pins, built-in Wi-Fi/Bluetooth capability, and compatibility with various sensors.

---

## 2. Servo Motors

### a) 20 kg High-Speed Digital Servo Motor

* **Application:** Shoulder Pitch Joint
* **Purpose:** Provides high torque required for lifting and lowering the robotic arm.
* **Features:**

  * High torque output
  * Metal gear construction
  * High positional accuracy
  * Fast response suitable for robotic applications

### b) 15 kg Servo Motor

* **Application:** Shoulder Yaw Joint
* **Purpose:** Rotates the shoulder assembly about the vertical axis, enabling left and right movement of the robotic arm.

### c) MG995 Servo Motor

* **Application:** Elbow Joint
* **Purpose:** Controls elbow flexion and extension according to the conditioned flex sensor output. The MG995 provides sufficient torque to support the forearm section of the robotic arm.

### d) SG90 Servo Motor

* **Application:** Wrist Bend
* **Purpose:** Controls wrist bending using the processed output obtained from the strain gauge sensing system. Due to the lower load at the wrist, the lightweight SG90 servo is adequate for this application.

---

## 3. Flex Sensor

The flex sensor is mounted on the user's elbow to detect bending motion. As the sensor bends, its electrical characteristics change, and after signal conditioning, the processed analog voltage is supplied to the ESP32. The microcontroller converts this signal into the corresponding elbow joint angle.

**Application:** Elbow movement detection.

---

## 4. Four-Element Strain Gauge System

A four-element strain gauge arrangement is employed to detect wrist bending. The strain gauges are connected in an appropriate bridge configuration and their output is amplified and conditioned to produce a stable analog voltage suitable for the ESP32 ADC.

**Application:** Wrist bend detection.

---

## 5. MPU6050 Inertial Measurement Unit (IMU)

The MPU6050 contains a three-axis accelerometer and a three-axis gyroscope. It is mounted near the user's shoulder to measure shoulder orientation. Sensor fusion using the accelerometer and gyroscope provides stable estimation of shoulder pitch, while gyroscope data is used to estimate shoulder yaw.

**Application:**

* Shoulder Pitch
* Shoulder Yaw

---

## 6. PVC Hollow Square Pipe

Lightweight PVC hollow square pipes are used as the primary structural members of the robotic arm. These members form the upper arm and forearm sections while keeping the overall weight low and maintaining adequate mechanical strength.

**Purpose:**

* Structural frame
* Weight reduction
* Easy fabrication and machining

---

## 7. Metal Mounting Brackets and Servo Holders

Metal brackets are used to securely mount the servo motors and provide rigid mechanical joints. They also improve alignment between rotating components and increase the overall structural stability of the robotic arm.

**Applications:**

* Base mounting
* Shoulder assembly
* Elbow assembly
* Servo fixation

---

## 8. Compression/Tension Spring

A mechanical spring is incorporated near the elbow joint to assist in supporting the weight of the forearm. The spring reduces the load experienced by the elbow servo, improves motion smoothness, and minimizes unnecessary power consumption.

**Purpose:**

* Weight compensation
* Servo load reduction
* Improved joint stability

---

## 9. Metal Support Strip

A flat metal strip is integrated into the elbow mechanism to reinforce the joint structure and provide additional mechanical support. It works together with the spring to distribute loads more evenly during arm movement.

**Purpose:**

* Structural reinforcement
* Load distribution
* Improved durability

---

## 10. Connecting Hardware

Various mechanical fasteners are used during assembly, including:

* Nuts
* Bolts
* Screws
* Washers
* Servo horns
* Couplers and spacers (where required)

These components ensure secure mechanical assembly and reliable operation of the robotic arm.

---

# Summary of Components

| Component                    | Purpose                             |
| ---------------------------- | ----------------------------------- |
| ESP32 Development Board      | Main controller                     |
| 20 kg Digital Servo          | Shoulder pitch                      |
| 15 kg Servo(360 degree)      | Shoulder yaw                        |
| MG995 Servo                  | Elbow movement                      |
| SG90 Servo                   | Wrist bend                          |
| Flex Sensor                  | Elbow motion sensing                |
| Four Strain Gauges           | Wrist bend sensing                  |
| MPU6050 IMU                  | Shoulder orientation sensing        |
| PVC Hollow Square Pipe       | Structural frame                    |
| Metal Brackets               | Servo and frame mounting            |
| Spring                       | Elbow support and load compensation |
| Metal Support Strip          | Elbow reinforcement                 |
| Nuts, Bolts, Screws, Washers | Mechanical assembly                 |

