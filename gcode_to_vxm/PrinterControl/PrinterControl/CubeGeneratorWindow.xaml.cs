using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace PrinterControl
{
    /// <summary>
    /// Interaction logic for CubeGeneratorWindow.xaml
    /// </summary>
    public partial class CubeGeneratorWindow : Window
    {
        public CubeGeneratorWindow()
        {
            InitializeComponent();
        }

        private void button_Click(object sender, RoutedEventArgs e)
        {
            Microsoft.Win32.SaveFileDialog dlg = new Microsoft.Win32.SaveFileDialog();
            dlg.FileName = "out"; // Default file name
            dlg.DefaultExt = ".gcode"; // Default file extension
            dlg.Filter = "All Files|*.*"; // Filter files by extension

            // Show save file dialog box
            Nullable<bool> result = dlg.ShowDialog();

            // Process save file dialog box results
            if (result == true)
            {
                // Save document
                string filename = dlg.FileName;

                CubeGenerator cgen = new CubeGenerator(filename);
                cgen.setInfillSquareSize(Convert.ToInt32(Convert.ToDouble(textBox_infillSquareSize.Text) * 1000000));
                cgen.setNumberInfillSquares(Convert.ToInt32(textBox_numInfillSquaresX.Text), Convert.ToInt32(textBox_numInfillSquaresY.Text));
                cgen.setNumInfillPerimeterLines(Convert.ToInt32(textBox_perimeterLinesInfill.Text));
                cgen.setNumPerimeterLines(Convert.ToInt32(textBox_perimeterLinesLayer.Text));
                cgen.setSpotSize(Convert.ToInt32(Convert.ToDouble(textBox_SpotSize.Text) * 1000000));
                cgen.setInfillSquareOrder(comboBox_infillSquareOrder.SelectedIndex);
                cgen.setHatchDirectionAlternation(comboBox_hatchDirection.SelectedIndex);
                if(checkBox_defect.IsChecked == true)
                {
                    cgen.setDefectState(true);
                    cgen.setDefect(Convert.ToDouble(textBox_defectSizeX.Text), Convert.ToDouble(textBox_defectSizeY.Text), Convert.ToDouble(textBox_defectSizeZ.Text), Convert.ToDouble(textBox_defectLocationX.Text), Convert.ToDouble(textBox_defectLocationY.Text), Convert.ToDouble(textBox_defectLocationZ.Text));
                }

                cgen.drawCube(Convert.ToDouble(textBox_layerThickness.Text), Convert.ToDouble(textBox_Height.Text));
                cgen.closeFile();
            }
        }

        private void textBox_layerThickness_TextChanged(object sender, System.EventArgs e)
        {
            try
            {
                var x = Convert.ToDouble(textBox_layerThickness.Text);
                int value = Convert.ToInt32(x * 100000);

                // Print bed and powder bed slides have 5 um step increments. If height isn't divisible by this, change it
                if (value % 500 != 0)
                {
                    value -= value % 500;
                    textBox_layerThickness.Text = (value / 100000.0).ToString();
                }
            }
            catch(Exception ex)
            { }
                
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
