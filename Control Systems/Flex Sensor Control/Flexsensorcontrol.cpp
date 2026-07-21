#include <ESP32Servo.h>

Servo elbow;

const int sensorPin = 34;
const int servoPin = 18;

// Calibration values
const int adcStraight = 620;
const int adcBent     = 3720;

// Exponential Moving Average
const float alpha = 0.15;

float filtered = 0;

int currentAngle = 90;
const int servoSpeed = 2;

void setup()
{
    Serial.begin(115200);

    analogReadResolution(12);        // 0-4095
    analogSetAttenuation(ADC_11db);  // ~0-3.3V input

    elbow.setPeriodHertz(50);
    elbow.attach(servoPin, 500, 2500);

    filtered = analogRead(sensorPin);

    elbow.write(currentAngle);
}

void loop()
{
    int raw = analogRead(sensorPin);

    filtered = alpha * raw + (1 - alpha) * filtered;

    int target = map(
        filtered,
        adcStraight,
        adcBent,
        0,
        180
    );

    target = constrain(target, 0, 180);

    if(currentAngle < target)
        currentAngle += servoSpeed;
    else if(currentAngle > target)
        currentAngle -= servoSpeed;

    elbow.write(currentAngle);

    Serial.print("ADC = ");
    Serial.print(raw);

    Serial.print("  Filtered = ");
    Serial.print(filtered);

    Serial.print("  Angle = ");
    Serial.println(currentAngle);

    delay(15);
}
