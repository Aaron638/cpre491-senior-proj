/*
 * Demo name   : HP20x_dev demo 
 * Usage       : I2C PRECISION BAROMETER AND ALTIMETER [HP206C hopeRF] 
 * Author      : Oliver Wang from Seeed Studio
 * Version     : V0.1
 * Change log  : Add kalman filter 2014/04/04
*/

#include <HP20x_dev.h>
#include "Arduino.h"
#include "Wire.h" 
#include <KalmanFilter.h>
unsigned char ret = 0;

/* Instance */
KalmanFilter t_filter;    //temperature filter
KalmanFilter p_filter;    //pressure filter
KalmanFilter a_filter;    //altitude filter


void setup()
{  
  Serial.begin(9600);        // start serial for output
  
  Serial.println("****HP20x_dev demo by seeed studio****\n");
  Serial.println("Calculation formula: H = [8.5(101325-P)]/100 \n");
  /* Power up,delay 150ms,until voltage is stable */
  delay(150);
  /* Reset HP20x_dev */
  HP20x.begin();
  delay(100);
  
  /* Determine HP20x_dev is available or not */
  ret = HP20x.isAvailable();
  if(OK_HP20X_DEV == ret)
  {
    Serial.println("HP20x_dev is available.\n");    
  }
  else
  {
    Serial.println("HP20x_dev isn't available.\n");
  }
  
}
 

void loop()
{
    char display[40];
    if(OK_HP20X_DEV == ret)
    { 
	  Serial.println("------------------\n");
	  long Temper = HP20x.ReadTemperature();
	  Serial.println("T:");
	  float t = Temper/100.0;
	  Serial.print(t);	  
	  Serial.println("C.\n");
	  //Serial.println("Filter:");
	  //Serial.print(t_filter.Filter(t));
	  //Serial.println("C.\n");
 
      long Pressure = HP20x.ReadPressure();
	  Serial.println("P:");
	  t = Pressure/100.0;
	  Serial.print(t);
	  Serial.println("hPa.\n");
	  //Serial.println("Filter:");
	  //Serial.print(p_filter.Filter(t));
	  //Serial0.println("hPa\n");

   //ADC Output for INTERNAL OXYGEN SENSOR // NEED 250 OHM

    int o = 0;
    o = analogRead(A0); //gives 0-1023
    //range = [insert here] ;
    //Oxygen_Level = [insert here];
    Serial.println("O:");
    Serial.println(Oxygen_Level);
    
	  
	  /*long Altitude = HP20x.ReadAltitude();
	  Serial.println("Altitude:");
	  t = Altitude/100.0;
	  Serial.print(t);
	  Serial.println("m.\n");
	  Serial.println("Filter:");
	  Serial.print(a_filter.Filter(t));
	  Serial.println("m.\n");
	  Serial.println("------------------\n");*/
      delay(1000);
    }
}
 

