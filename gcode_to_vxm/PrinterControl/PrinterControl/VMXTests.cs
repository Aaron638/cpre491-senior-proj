using System;
using System.Collections.Generic;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PrinterControl
{
    class VMXTests
    {
        public static void CoordinateMotionTest(SerialPort sp)
        {
            // Should draw a box with chamfered corners
            //sp.Write("F PM-1,");            // Set to online mode with no echo, select and clear program 1
            //sp.Write("A1M10,");             // Set acceleration/decceleration constant for motor 1 to 10. Higher is faster
            //sp.Write("A3M10,");             // Set acceleration/decceleration constant for motor 3 to 10. Higher is faster
            //sp.Write("S1M2000,");           // Set steps per second of motor 1 to 2000
            //sp.Write("S3M2000,");           // Set steps per second of motor 3 to 2000
            //sp.Write("I1M2000,");           // Increment motor 1 2000 steps
            //sp.Write("(I3M2000,I1M2000,)"); // Incrmenet both axes coordinated to do chamfer
            //sp.Write("I3M4000,");
            //sp.Write("(I3M2000,I1M-2000,)");
            //sp.Write("I1M-4000,");
            //sp.Write("(I3M-2000,I1M-2000,)");
            //sp.Write("I3M-4000,");
            //sp.Write("(I3M-2000,I1M2000,)");
            //sp.Write("I1M2000,");
            //sp.Write("PM1");                // Select program 1
            //sp.Write("R");                  // Run current program (program 1)



            sp.Write("F,PM-1,");            // Set to online mode with no echo, select and clear program 1
            sp.Write("S2M1000,");
            sp.Write("S3M1000,");
            sp.Write("IA2M0,");
            sp.Write("R");                  // Run current program (program 1)
        }

        public static void ProgramSwitchTest(SerialPort sp)
        {
            // Should draw a box with chamfered corners
            sp.Write("F PM-1,");            // Set to online mode with no echo, select and clear program 1
            sp.Write("A1M10,");             // Set acceleration/decceleration constant for motor 1 to 10. Higher is faster
            sp.Write("A3M10,");             // Set acceleration/decceleration constant for motor 3 to 10. Higher is faster
            sp.Write("S1M2000,");           // Set steps per second of motor 1 to 2000
            sp.Write("S3M2000,");           // Set steps per second of motor 3 to 2000
            sp.Write("I1M2000,");           // Increment motor 1 2000 steps
            sp.Write("(I3M2000,I1M2000,)"); // Incrmenet both axes coordinated to do chamfer
            sp.Write("I3M4000,");
            sp.Write("JM0,");               // Jump to program 0
            sp.Write("PM-0,");              // Select and clear program 0
            sp.Write("(I3M2000,I1M-2000,)");
            sp.Write("I1M-4000,");
            sp.Write("(I3M-2000,I1M-2000,)");
            sp.Write("I3M-4000,");
            sp.Write("(I3M-2000,I1M2000,)");
            sp.Write("I1M2000,");
            sp.Write("PM1");                // Select program 1
            sp.Write("R");                  // Run current program (program 1)
        }
    }
}
