/*  
 *  Powder Bed Metal Printer Ardino Sensor Code
 *  Iowa State EE 491 sddec-21-11
 *  Addison Ulrick, Dale Young, Colin Firth, Aaron Martin, Tary Todd, Chris Johannsen
 *  Professor Timothy Bigelow
 */

/*
 *  HP206C (Barometer) to Arduino
 *    GND -> GND
 *    VCC -> 3.3V
 *    SDA -> A4
 *    SCL -> A5
 *    
 *  OLED Display to Arduino
 *    GND -> GND
 *    VCC -> 5V
 *    SDA -> A4
 *    SCL -> A5
 *  
 *  MIX8410 (External O2 Sensor) to Arduino - N/A as of 4/18/2021
 *    GND -> GND
 *    VCC -> 5V
 *     NC -> A1
 *    SIG -> A0
 *  
 *  Gove Buzzer to Arduino - N/A as of 4/18/2021
 *    GND -> GND
 *    VCC -> 5V
 *     NC -> A1
 *    SIG -> A6
 */

#include <HP20x_dev.h>
#include <KalmanFilter.h>
#include <SSD1306Ascii.h>
#include <SSD1306AsciiAvrI2c.h>
#include "Arduino.h"
#include "Wire.h"

// 0x3C or 0x3D
#define I2C_ADDRESS 0x3C
#define RST_PIN -1

const float Vref = 3.3;
const int pinADC = A0;

// Temperature and pressure filters
KalmanFilter t_filter;          
KalmanFilter p_filter;    
// OLED device    
SSD1306AsciiAvrI2c oled;  

void setup() 
{
    // Start serial for output
    Serial.begin(9600);   
    delay(150);

    // OLED display settings
    oled.begin(&Adafruit128x64, I2C_ADDRESS, RST_PIN);
    oled.clear();
    oled.setFont(System5x7);
    oled.setCursor(0, 10);

    // Barometer Initialization
    HP20x.begin();
    delay(100);
    /*
        // Buzzer Initialization
        pinMode(6, OUTPUT);
        delay(100);
    */
}

void loop()
{     
    float temp = get_temp();
    float pres = get_pres();
    float ox_con = get_ox();
    delay(100);
    /*    
        // If O2 is below 22%

        while(ox_con < 22.0)
        {
            // Sound Alarm
            digitalWrite(6, HIGH);
            delay(500);
            digitalWrite(6, LOW);
            delay(500);
        }
    */
    // Display values to OLED
    oled.clear();
    oled.println("EE 491 Powder Bed Printer Sensors\n");
    
    oled.print("Temperature: ");
    oled.print(temp);
    oled.println(" °C\n");
    
    oled.print("Pressure: ");
    oled.print(pres);
    oled.println(" Pa\n");
    
    oled.print("Oxygen: ");
    oled.print(ox_con);
    oled.println(" %\n");
  
    delay(500);
}
