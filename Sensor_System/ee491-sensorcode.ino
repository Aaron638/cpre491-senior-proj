/*  
 *  Powder Bed Metal Printer Ardino Sensor Code
 *  Iowa State EE 491 sddec-21-11
 *  Addison Ulrick, Dale Young, Colin Firth, Aaron Martin, Tary Todd, Chris Johannsen
 *  Professor Timothy Bigelow
 */

/*
 *  HP206C (Barometer) to Arduino
 *  GND -> GND
 *  VCC -> 3.3V
 *  SDA -> A4
 *  SCL -> A5
 *  
 *  MIX8410 or ME2-O2-Ф20 (O2 Sensor) to Arduino
 *  GND -> GND
 *  VCC -> 3.3V
 *   NC -> A1
 *  SIG -> A0
 */

#include <HP20x_dev.h>
#include <KalmanFilter.h>
#include "Arduino.h"
#include "Wire.h"

const float Vref = 3.3;
const int pinADC = A0;

KalmanFilter t_filter;    // temperature filter
KalmanFilter p_filter;    // pressure filter

void setup() 
{
    // Start serial for output
    Serial.begin(9600);       

    // Power up, delay 150ms until voltage is stable
    delay(150);
    
    // Reset HP20x_dev
    HP20x.begin();
    delay(100);
}

// Calculating, and printing temperature value (in Celsius)
void get_temp() 
{
    long Temper = HP20x.ReadTemperature();
    Serial.print("Temperature:\t");
    float t = Temper / 100.0;
    Serial.print(t_filter.Filter(t));
    Serial.println(" C");
}

// Calculating, and printing pressure value (in Pascals)
void get_pres
{
    long Pressure = HP20x.ReadPressure();
    Serial.print("Pressure:\t");
    t = Pressure / 10.0;
    Serial.print(p_filter.Filter(t));
    Serial.println(" Pa");
}

// Calculating and printing oxygen content in air
void get_ox()
{
    // NOTE: 20-30 minute preheat time
    float concPercent = readO2Concentration();
    Serial.print("Oxygen:\t\t");
    Serial.print(concPercent);
    Serial.println(" %\n");

    // Wait until next reading
    delay(1000);
}

// Calculates O2 sensor voltage, and converts to O2 concentration
float readO2Concentration()
{
    // Calculating voltage output
    long sum = 0;
    for(int i = 0; i < 32; i++)
    {
        sum += analogRead(pinADC);
    }
    sum >>= 5;
    float measuredVout = sum * (Vref / 1023.0);

    // Converts from voltage output to O2 concentration
    float concentration = measuredVout * 0.21 / 2.0;
    float concPercent = concentration * 100;
    return concPercent;
}
