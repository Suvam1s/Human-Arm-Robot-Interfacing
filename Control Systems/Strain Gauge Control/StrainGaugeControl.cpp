
#include <Servo.h>

Servo wrist;

const int strainPin = A0;
const int servoPin = D3;

const int adcMin = 120;
const int adcMax = 920;

const float alpha = 0.12;

float filtered = 0;

int currentAngle = 90;

const int speed = 1;

void setup()
{
    Serial.begin(115200);

    wrist.attach(servoPin);

    filtered = analogRead(strainPin);

    wrist.write(currentAngle);
}

void loop()
{
    int raw = analogRead(strainPin);

    filtered = alpha * raw + (1-alpha) * filtered;

    int target =
        map(filtered,
            adcMin,
            adcMax,
            45,
            135);

    target = constrain(target,45,135);

    if(currentAngle < target)
        currentAngle += speed;

    else if(currentAngle > target)
        currentAngle -= speed;

    wrist.write(currentAngle);

    Serial.print("ADC = ");
    Serial.print(raw);

    Serial.print("  Angle = ");
    Serial.println(currentAngle);

    delay(20);
}
