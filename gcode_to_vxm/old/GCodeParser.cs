using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

// Custom defined M codes for our 3D printer: 
// M200: Execute layer change
// M201: Laser on
// M202: Laser off

namespace PrinterControl
{
    /// <summary>
    /// A class that parses a gCode file into an array of commands
    /// </summary>
    class GCodeParser
    {
        // Both doubles are in steps/mm
        public const double UNIT_CONV_FACTOR = 400.0; // gCode number * UNIT_CONV_FACTOR = vmx steps number
        public const double BED_CONV_FACTOR = 400.0; // unit conversion factor for print and powder bed motors
        
        /// <summary>
        /// Parses a g code file into PrinterAction objects which control the operation of printer hardware
        /// </summary>
        /// <remarks>
        /// This class assumes that motor 2 controls the X axis and motor 3 controls the Y axis
        /// </remarks>
        /// <param name="gCode">
        /// StreamReader object from gCode file
        /// </param>
        /// <param name="averageSpeed">
        /// Desired speed of movement in gCode units / second
        /// </param>
        /// <returns>
        /// Array of printer action objects
        /// </returns>
        public List<PrinterAction> parseGCodeFile(StreamReader gCode, double averageSpeed)
        {
            // The array that stores the PrinterAction objects
            // This is what is returned by the method
            List<PrinterAction> ret = new List<PrinterAction>();

            var x0 = 0.0;
            var y0 = 0.0;
            var x1 = 0.0;
            var y1 = 0.0;
            var deltaX = 0.0;
            var deltaY = 0.0;
            var dist = 0.0;
            var speedX = 0.0;
            var speedY = 0.0;
            averageSpeed = averageSpeed * UNIT_CONV_FACTOR;
            bool firstMove = true; // Determines if the VELMEX_MOVE action has not been performed
            string retStr = "";
            bool starting = true; // Determines if first-time setup needs to be parsed

            
            string line;

            // Read until end of this block
            // String line will get each line from the gCode file and loop this block
            while ((line = gCode.ReadLine()) != null)
            {
                // Only iterates during the first loop
                // File must begin by specifying length and width
                if (starting)
                {
                    // Creates a string array from the first line
                    // Each element is delimited by a space (' ')
                    string[] dimension = line.Split(' ');
                    // The first element on the line indicates the width
                    // Substring(6) indicates that the width data starts at index 6 of the element
                    string width = dimension[0].Substring(6);
                    // The second element indicates the length
                    string length = dimension[1].Substring(7);
                    // Writes the width and length to the console
                    Console.WriteLine(width + ", " + length);

                    // Parses the width and length as doubles
                    // After halving the doubles, multiplies by UNIT_CONV_FACTOR
                    var w = (double.Parse(width) / 2) * UNIT_CONV_FACTOR;
                    var l= (double.Parse(length) / 2) * UNIT_CONV_FACTOR;

                    // Move the roller to the left limit
                    // Should not do anything, here as a precaution
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LAYER_CHANGE, "F,PM-1, S1M6000, I1M-0, R"));

                    // Adds a new PrinterAction object to the list of PrinterAction objects
                    // The new object is initialized to move the Velmex

                    // Enable On-Line mode, select and clear program 1, set speed of motors 2 and 3 to 1000
                    // move to positive limit, run the program
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_VELMEX_MOVE, "F, PM-1, S2M1000, S3M1000, (I3M0, I2M0,) R"));
                    
                    // Assigns String variable retStr to the given String after formatting
                    // Replaces the {0} and {1} format elements in the String with the following two objects respectively
                    // Replaces {0} with the width after rounding to the nearest whole number
                    // Replaces {1} with the length after rounding to the nearest whole number
                    
                    // Move motors 2 and 3 to the middle of the length and width at speed 100000
                    retStr = String.Format("F,PM-1,S2M10000,S3M10000,(I3M-{0},I2M-{1},)R", Math.Round(w, 0), Math.Round(l, 0));
                    
                    // Adds a new PrinterAction object to the list with a VELMEX_MOVE action type
                    // The Velmex command is passed as the previously assigned String retStr
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_VELMEX_MOVE, retStr));

                    //ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LAYER_CHANGE_2, "F, PM-1, S1M50000, S2M50000, (I1M0, IA2M19000,) R"));

                    // Adds a new PrinterAction object to the list with a LAYER_CHANGE_2 action type
                    // Moves motor 2 to the negative limit at a speed of 100
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LAYER_CHANGE_2, "F, PM-1, S2M100, I2M-0, R"));
                    
                    starting = false; // Ensures that this if statement only iterates once
                }
                // After startup is complete (so for all lines after the first) determine which action needs to be performed

                // Layer change
                else if (line.StartsWith("M200"))
                {
                    // Assign variable s with everything on the line starting at index 5
                    // s = millimeters to move
                    string s = line.Substring(5);
                    // Write the new String to console
                    Console.WriteLine(s);

                    // Parse a double from String s and multiply by BED_CONV_FACTOR
                    // Cast the double as an int and assign to stepsMoved
                    int stepsMoved =(int)( double.Parse(s) * BED_CONV_FACTOR);
                   

                    // Add two new PrinterAction objects with action type LAYER_CHANGE_2
                    // Replace the {0} in both strings with the int variable inchesMoved

                    // Move the left bed up by stepsMoved, move the right bed down by stepsMoved
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LAYER_CHANGE_2, String.Format( "F, PM-1, S1M2000, I1M-{0}, R", stepsMoved)));
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LAYER_CHANGE_2, String.Format( "F, PM-1, S2M2000, I2M{0}, R", stepsMoved)));

                    // Add two new PrinterAction objects with action type LAYER_CHANGE
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LAYER_CHANGE, "F,PM-1,S1M6000,I1M0, R"));
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LAYER_CHANGE, "F,PM-1, S1M6000, I1M-0, R"));
                }
                // Laser on
                else if (line.Equals("M201"))
                {
                    // Add a new PrinterAction object to the list
                    // Turns on the laser
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LASER_ON, ""));
                }
                // Laser off
                else if (line.Equals("M202"))
                {
                    // Add a new PrinterAction object to the list
                    // Turns off the laser
                    ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_LASER_OFF, ""));
                }
                // Velmex move
                else
                {
                    // Get starting x and y
                    if (firstMove)
                    {   
                        // Search the line for the X and Y variables
                        // The functions called already factor in the unit conversions
                        x0 = getXFromGCodeLine(line);
                        y0 = getYFromGCodeLine(line);
                        // All other variables assigned to 0.0
                        // These variables depend on the previous assignments of x0 and y0
                        x1 = 0.0;
                        y1 = 0.0;
                        deltaX = 0.0;
                        deltaY = 0.0;
                        dist = 0.0;
                        speedX = 0.0;
                        speedY = 0.0;
                        firstMove = false; // Ensures this if statement only executes once
                    }
                    else
                    {
                        // Search the line for the X and Y variables
                        x1 = getXFromGCodeLine(line);
                        y1 = getYFromGCodeLine(line);

                        // Find the change in X and Y
                        deltaX = x1 - x0;
                        deltaY = y1 - y0;
                        // Find the distance the motors move
                        dist = Math.Sqrt(Math.Pow(deltaX, 2) + Math.Pow(deltaY, 2));

                        // Using averageSpeed, find the speed at which X and Y change
                        speedX = Math.Abs(averageSpeed * (deltaX / dist));
                        speedY = Math.Abs(averageSpeed * (deltaY / dist));

                        // Assuming motor 2 is x axis, motor 3 is y axis
                        // If X and Y do not change position, the Velmex command is an empty string
                        if (Math.Round(deltaX) == 0 && Math.Round(deltaY) == 0)
                        {
                            retStr = "";
                        }
                        // If X does not move, the Velmex command only updates Y (motor 3)
                        else if (Math.Round(deltaX) == 0)
                        {
                            retStr = String.Format("F,PM-1,S3M{0},I3M{1},R", Math.Round(speedY, 0), Math.Round(deltaY, 0));
                        }
                        // If Y does not move, the Velmex command only updates X (motor 2)
                        else if (Math.Round(deltaY) ==0)
                        {
                            retStr = String.Format("F,PM-1,S2M{0},I2M{1},R", Math.Round(speedX, 0), Math.Round(deltaX, 0));
                        }
                        // Otherwise, the Velmex command moves both motor 2 and motor 3
                        else
                        {
                            retStr = String.Format("F,PM-1,S2M{0},S3M{1},(I3M{2},I2M{3},)R", Math.Round(speedX, 0), Math.Round(speedY, 0), Math.Round(deltaY, 0), Math.Round(deltaX, 0));
                        }
                        
                        // Update x0 and y0 to the previously found variables
                        // Ensures that deltaX and deltaY will be accurate the next time this block is reached
                        x0 = x1;
                        y0 = y1;

                        // Add a new PrinterAction object to the list with action type VELMEX_MOVE
                        // retStr holds the Velmex command being passed
                        ret.Add(new PrinterAction(PrinterAction.ACTION_TYPE_VELMEX_MOVE, retStr));
                    }
                    
                }
            }

            // while loop ends after reaching the end of the gCode file
            // Return the List stored with PrinterAction objects
            return ret;
        }

        /// <summary>
        /// Gets an X variable from a line of gCode. Helper method for parseGCodeFile()
        /// </summary>
        /// <param name="line">
        /// The line being read from
        /// </param>
        /// <returns>
        /// The X value as a variable type double
        /// </returns>
        private double getXFromGCodeLine(string line)
        {
            // Assigns a variable with each element in the line
            // The delimiter used is a space
            // TODO: check to see if args needs to be an array
            var args = line.Split(' ');

            // Output a warning to console if the line is a non G1 line
            if(args[0] != "G1")
                Console.WriteLine("Warning - Parsing non G1 gcode line");

            // Loop through args until X is found
            for(var i = 1; i < args.Length; i++)
            {
                // Upon finding X, return a substring parsed as a double
                // Substring(1) means ignore the first index of the string (so ignore 'X')
                if(args[i][0] == 'X')
                    // Multiply by UNIT_CONV_FACTOR before returning
                    return UNIT_CONV_FACTOR * double.Parse(args[i].Substring(1));
            }

            // Return 0.0 if X is not found
            return 0.0;
        }

        /// <summary>
        /// Gets a Y variable from a line of gCode. Helper method for parseGCodeFile()
        /// </summary>
        /// <param name="line">
        /// The line being read from
        /// </param>
        /// <returns>
        /// The Y value as a variable type double
        /// </returns>
        private double getYFromGCodeLine(string line)
        {
            // Assigns a variable with each element in the line
            // The delimiter used is a space
            // TODO: check to see if args needs to be an array
            var args = line.Split(' ');

            // Output a warning to console if the line is a non G1 line
            if (args[0] != "G1")
                Console.WriteLine("Warning - Parsing non G1 gcode line");

            // Loop through args until Y is found
            for (var i = 1; i < args.Length; i++)
            {
                // Upon finding Y, return a substring parsed as a double
                // Substring(1) means ignore the first index of the string (so ignore 'Y')
                if (args[i][0] == 'Y')
                    // Multiply by UNIT_CONV_FACTOR before returning
                    return UNIT_CONV_FACTOR * double.Parse(args[i].Substring(1));
            }

            // Return 0.0 if Y is not found
            return 0.0;
        }
    }
}
