#include <Wire.h>
#include <MPU6050.h>
#include <ESP32Servo.h>

MPU6050 imu;

Servo pitchServo;
Servo yawServo;

// Servo Pins
const int PITCH_SERVO_PIN = 18;
const int YAW_SERVO_PIN   = 19;

// Current angles
float pitch = 90.0;
float yaw   = 90.0;

// Gyro integration
unsigned long previousTime = 0;

void setup()
{
    Serial.begin(115200);

    Wire.begin();

    imu.initialize();

    if(!imu.testConnection())
    {
        Serial.println("MPU6500 Not Connected");

        while(1);
    }

    Serial.println("MPU6500 Connected");

    pitchServo.setPeriodHertz(50);
    yawServo.setPeriodHertz(50);

    pitchServo.attach(PITCH_SERVO_PIN,500,2500);
    yawServo.attach(YAW_SERVO_PIN,500,2500);

    previousTime = micros();
}

void loop()
{
    int16_t gx,gy,gz;
    imu.getRotation(&gx,&gy,&gz);

    unsigned long currentTime = micros();

    float dt = (currentTime-previousTime)/1000000.0;

    previousTime = currentTime;

    // ±250°/s sensitivity
    float gyroX = gx / 131.0;
    float gyroZ = gz / 131.0;

    pitch += gyroX * dt;
    yaw   += gyroZ * dt;

    pitch = constrain(pitch,0,180);
    yaw   = constrain(yaw,0,180);

    pitchServo.write((int)pitch);
    yawServo.write((int)yaw);

    Serial.print("Pitch : ");
    Serial.print(pitch);

    Serial.print("    Yaw : ");
    Serial.println(yaw);

    delay(10);
}
