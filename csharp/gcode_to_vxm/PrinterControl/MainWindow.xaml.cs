using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace PrinterControl
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public static string[] commands;
        public static List<PrinterAction> actionList;
        public static int currentIndex;
        public static SerialPort vxmSp;
        public static SerialDataReceivedEventHandler vxmSerialHandler;

        public static event Action<string> MyEvent = delegate { };

        public MainWindow()
        {
           // MyEvent += (x) => { internalTemperatureSensorText.Content = x; };

            //commands = new string[] { "F,PM-1,S2M500,S3M500,(I3M1000,I2M1000,)R",
            //                        "F,PM-1,S2M500,S3M500,(I3M1000,I2M-1000,)R",
            //                        "F,PM-1,S2M500,S3M500,(I3M-1000,I2M-1000,)R",
            //                        "F,PM-1,S2M500,S3M500,(I3M-1000,I2M1000,)R",
            //                        /*absolute zero at end for motor 2 and 3*/"F,PM-1,S2M1000,S3M1000,IA2M0,IA3M0,R" };
            currentIndex = 0;

            InitializeComponent();

            //StreamReader file = new StreamReader("../../test.gcode");

            //GCodeParser g = new GCodeParser();
            //actionList = g.parseGCodeFile(file, 25);

            //sp = new SerialPort("COM6");           
            //sp.BaudRate = 9600;
            //sp.Open();
            //serialHandler = new SerialDataReceivedEventHandler(DataReceivedHandler);

            //executeNextAction();

            //CubeGenerator cgen = new CubeGenerator("../../test.out");
            //cgen.setInfillSquareSize(100000);
            //cgen.setNumberInfillSquares(5, 5);
            //cgen.setNumInfillPerimeterLines(3);
            //cgen.setSpotSize(10000);
            //cgen.drawLayer(0, 0);
            //cgen.drawInfillSquare(0, 0, 20, 0);
            //cgen.drawInfillSquare(0, 300000, 20, 1);
            //cgen.closeFile();

            //// Initial code, sets speeds and does 'dummy' move to absolute zero (shouldn't move, always zero at end of program)
            //sp.Write("F,PM-1,");            // Set to online mode with no echo, select and clear program 1
            //sp.Write("S2M1000,");
            //sp.Write("S3M1000,");
            //sp.Write("IA2M0,");
            //sp.Write("R");                  // Run current program (program 1)
        }

        //public static void executeNextAction()
        //{
        //    if(currentIndex > 0) currentIndex++;    // dont increment on first action
        //    if(currentIndex >= actionList.Count)
        //    {
        //        // end of action list, exit
        //        return;
        //    }

        //    if(actionList[currentIndex].actionType == PrinterAction.ACTION_TYPE_VELMEX_MOVE)
        //    {
        //        vxmSp.DataReceived -= vxmSerialHandler;
        //        vxmSp.DataReceived += vxmSerialHandler;
        //        vxmSp.Write(actionList[currentIndex].velmexCommand);
        //    }
        //    else if(actionList[currentIndex].actionType == PrinterAction.ACTION_TYPE_LASER_OFF)
        //    {

        //    }
        //    else if (actionList[currentIndex].actionType == PrinterAction.ACTION_TYPE_LASER_ON)
        //    {

        //    }
        //    else if (actionList[currentIndex].actionType == PrinterAction.ACTION_TYPE_LAYER_CHANGE)
        //    {
        //        vxmSp.DataReceived -= vxmSerialHandler;
        //    }
        //}

        private static void VxmDataReceivedHandler(object sender, SerialDataReceivedEventArgs e)
        {
            SerialPort sp = (SerialPort)sender;
            string indata = sp.ReadExisting();

            // Check for move complete, then execute next action
            if (indata.Equals("^"))
            { 
                //executeNextAction();                
            }
            else
            {
                Console.WriteLine(indata);
            }
        }

        private static void SensorDataReceivedHandler(object sender, SerialDataReceivedEventArgs e)
        {
            SerialPort sp = (SerialPort)sender;
            int b = sp.ReadByte();

            // Check for move complete, then execute next action
            if (b == 'T')
            {
                sp.ReadByte();

                var temperatureString = "";
                b = sp.ReadByte();
                while(b != '\n')
                {
                    temperatureString += Convert.ToChar(b);
                    b = sp.ReadByte();
                }

                MainWindow.MyEvent(temperatureString);
            }

        }

        private void button_Click(object sender, RoutedEventArgs e)
        {
            CubeGeneratorWindow cubeGenWindow = new CubeGeneratorWindow();
            cubeGenWindow.Show();
        }

        private void button2_Click(object sender, RoutedEventArgs e)
        {
            GCodeParserWindow cubeGenWindow = new GCodeParserWindow();
            cubeGenWindow.Show();
        }
    }
}
