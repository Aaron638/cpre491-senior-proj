/*  
 *  Powder Bed Metal Printer Ardino Sensor Functions
 *  Iowa State EE 491 sddec-21-11
 *  Addison Ulrick, Dale Young, Colin Firth, Aaron Martin, Tary Todd, Chris Johannsen
 *  Professor Timothy Bigelow
 */

// Calculating, and printing temperature value (in Celsius)
float get_temp() 
{
    float t = HP20x.ReadTemperature() / 100.0;
    float temp = t_filter.Filter(t);
    
    Serial.print("Temperature:\t");
    Serial.print(temp);
    Serial.println(" C");

    return temp;
    delay(500);
}

// Calculating, and printing pressure value (in Pascals)
float get_pres()
{
    float p = HP20x.ReadPressure() / 10.0;
    float pres = p_filter.Filter(p);
    
    Serial.print("Pressure:\t");
    Serial.print(pres);
    Serial.println(" Pa");

    return pres;
    delay(500);
}

// Calculating and printing oxygen content in air
float get_ox()
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

    Serial.print("Oxygen:\t\t");
    Serial.print(concPercent);
    Serial.println(" %\n");

    return concPercent;
    delay(500);
}
