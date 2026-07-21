#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

float pitch = 0.0;
float roll = 0.0;

unsigned long previousTime;

const float alpha = 0.98;

void setup()
{
    Serial.begin(115200);

    Wire.begin();

    mpu.initialize();

    if(!mpu.testConnection())
    {
        Serial.println("MPU6500 Connection Failed");

        while(1);
    }

    Serial.println("MPU6500 Connected");

    previousTime = micros();
}

void loop()
{
    int16_t ax, ay, az;
    int16_t gx, gy, gz;

    mpu.getMotion6(
        &ax, &ay, &az,
        &gx, &gy, &gz
    );

    unsigned long currentTime = micros();

    float dt =
        (currentTime - previousTime) / 1000000.0;

    previousTime = currentTime;

    //-----------------------------
    // Accelerometer Angle
    //-----------------------------

    float accelPitch =
        atan2(ay,
              sqrt(ax * ax + az * az))
              * 180.0 / PI;

    float accelRoll =
        atan2(-ax,
              sqrt(ay * ay + az * az))
              * 180.0 / PI;

    //-----------------------------
    // Gyroscope
    //-----------------------------

    float gyroPitchRate =
        gx / 131.0;

    float gyroRollRate =
        gy / 131.0;

    //-----------------------------
    // Complementary Filter
    //-----------------------------

    pitch =
        alpha *
        (pitch + gyroPitchRate * dt)
        +
        (1 - alpha) *
        accelPitch;

    roll =
        alpha *
        (roll + gyroRollRate * dt)
        +
        (1 - alpha) *
        accelRoll;

    Serial.print("Pitch : ");
    Serial.print(pitch);

    Serial.print("   Roll : ");
    Serial.println(roll);

    delay(5);
}
