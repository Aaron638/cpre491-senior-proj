
using System.Collections.Generic;
using System.Windows;
using System.IO;
using System;
using System.IO.Ports;

namespace PrinterControl
{
    /// <summary>
    /// Interaction logic for CubeGeneratorWindow.xaml
    /// </summary>
    public partial class GCodeParserWindow : Window
    {
        GCodeParser gCodeParser = new GCodeParser();
        string filePath;
        public static List<PrinterAction> commandList;
        double speed;
        public static int  commandIndex = 0;
        public static SerialPort sp1;
        public static SerialPort sp2;
        public static SerialPort sp3;
        public static SerialDataReceivedEventHandler serialHandler;
        public static SerialDataReceivedEventHandler sensorSerialHandler;

        public static event Action<string> MyEvent = delegate { };


        public GCodeParserWindow()
        {
            InitializeComponent();

            //xaml initialization 
            speed = Convert.ToDouble(speedInputBox.Text);
            lbCommands.ItemsSource = commandList;

            //3 axis and roller
            sp1 = new SerialPort("COM4"); //COM port should be selected by User
            sp1.BaudRate = 9600;
            sp1.Open();

            //powder beds
            sp2 = new SerialPort("COM5"); //COM port should be selected by User
            sp2.BaudRate = 9600;
            sp2.Open(); //NOT USED AS OF NOW sp2 does need to be opened if writing to the powder beds

            serialHandler = new SerialDataReceivedEventHandler(DataReceivedHandler);

            //sensor system
            sp3 = new SerialPort("COM6"); //COM port should be selected by User
            sp3.BaudRate = 9600;
            //sp3.Open();   //NOT USED AS OF NOW sp3 will be opened once sensors are installed
            sensorSerialHandler = new SerialDataReceivedEventHandler(SensorDataReceivedHandler);

            MyEvent += (x) => { updateSensorDisplay(x); };

        }

        private void updateSensorDisplay(string sensorData)
        {
            if(sensorData[0] == 'T')
            {
                temperature_val.Text = sensorData.Substring(1);
            }
            else if(sensorData[0] == 'P')
            {
                pressure_val.Text = sensorData.Substring(1);
            }
            else if(sensorData[0] == 'O')
            {
                oxygen_val.Text = sensorData.Substring(1);
            }
        }

        private static void SensorDataReceivedHandler(object sender, SerialDataReceivedEventArgs e)
        {
            SerialPort sp = (SerialPort)sender;
            int b = sp.ReadByte();

            if (b == 'T')
            {
                sp.ReadByte();

                var temperatureString = "T";
                b = sp.ReadByte();
                while (b != '\n')
                {
                    temperatureString += Convert.ToChar(b);
                    b = sp.ReadByte();
                }

                MyEvent(temperatureString);
            }
            else if (b == 'P')
            {
                sp.ReadByte();

                var pressureString = "P";
                b = sp.ReadByte();
                while (b != '\n')
                {
                    pressureString += Convert.ToChar(b);
                    b = sp.ReadByte();
                }

                MyEvent(pressureString);
            }
            else if (b == 'O')
            {
                sp.ReadByte();

                var oxygenString = "O";
                b = sp.ReadByte();
                while (b != '\n')
                {
                    oxygenString += Convert.ToChar(b);
                    b = sp.ReadByte();
                }

                MyEvent(oxygenString);
            }

        }

        //Saves file path of gcode
        private void Import_Click(object sender, RoutedEventArgs e)
        {
            Microsoft.Win32.OpenFileDialog openFileDialog1 = new Microsoft.Win32.OpenFileDialog();
            openFileDialog1.Filter = "GCODE files (*.gcode)|*.gcode|All files (*.*)|*.*";
            if (openFileDialog1.ShowDialog() == true )
            {
                filePath = openFileDialog1.FileName;
      

            }
        }

     
        //Fills command list
        private void Parse_Click(object sender, RoutedEventArgs e)
        {
            //ParseData
            speed = Convert.ToDouble(speedInputBox.Text);
            StreamReader reader = new StreamReader(filePath);
            commandList = gCodeParser.parseGCodeFile( reader , speed );

            //Update ListBox
            commandIndex = 0;
            lbCommands.ItemsSource = commandList;
            lbCommands.SelectedIndex = commandIndex;
      
        }

        //Send Command over serial
        private void Print_Click(object sender, RoutedEventArgs e)
        {
            if (commandList.Count > commandIndex + 1)
            {
                sp1.DataReceived -= serialHandler;
               
                executeNextAction();
                lbCommands.SelectedIndex = commandIndex;
            }

        }

        //TODO
        private void OneCommand_Click(object sender, RoutedEventArgs e)
        {
            //Do a serialPort . write and increase index
        }

        //Makes Listbox unselectable
        //Need to add checkbox functionality so you can change index in GUI
        private void LbCommands_PreviewMouseDown(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            e.Handled = true;           
        }

        //Makes sure the controllers send a ^ make and then runs next command
        private static void DataReceivedHandler(object sender, SerialDataReceivedEventArgs e)
        {
            SerialPort sp = (SerialPort)sender;
            string indata = sp.ReadExisting();

            // Check for move complete, then execute next action
            if (indata.Equals("^"))
            {
                executeNextAction();
            }
            else
            {
                Console.WriteLine(indata);
            }
        }

        //does a write based on the PrinterAction type
        public static void executeNextAction()
        {
           
           
            if (commandIndex >= commandList.Count)
            {
                // end of action list, exit
                return;
            }

            // Sends command to COM4
            if (commandList[commandIndex].actionType == PrinterAction.ACTION_TYPE_VELMEX_MOVE)
            {
                sp1.DataReceived -= serialHandler;
                sp1.DataReceived += serialHandler;
                //Console outputs every command send out
                Console.WriteLine(commandList[commandIndex].velmexCommand);
                sp1.Write(commandList[commandIndex].velmexCommand);
                commandIndex++;


            }
            // TODO: implement laser control
            else if (commandList[commandIndex].actionType == PrinterAction.ACTION_TYPE_LASER_OFF)
            {
                commandIndex++;
                executeNextAction();
            }
            else if (commandList[commandIndex].actionType == PrinterAction.ACTION_TYPE_LASER_ON)
            {
                commandIndex++;
                executeNextAction();
            }
            // Sends command to COM4
            else if (commandList[commandIndex].actionType == PrinterAction.ACTION_TYPE_LAYER_CHANGE)
            {
                //NEED TO DEFINE commands for layer change
                sp1.DataReceived -= serialHandler;
                sp1.DataReceived += serialHandler;

                Console.WriteLine(commandList[commandIndex].velmexCommand);
                sp1.Write(commandList[commandIndex].velmexCommand);
                commandIndex++;
            }
            // Sends command to COM5
            else if (commandList[commandIndex].actionType == PrinterAction.ACTION_TYPE_LAYER_CHANGE_2)
            {
                sp2.DataReceived -= serialHandler;
                sp2.DataReceived += serialHandler;

                Console.WriteLine(commandList[commandIndex].velmexCommand);
                sp2.Write(commandList[commandIndex].velmexCommand);
                commandIndex++;
            }
            
        }

    }
}
