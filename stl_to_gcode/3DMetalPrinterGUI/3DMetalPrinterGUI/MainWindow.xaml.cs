using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;
using System.Windows.Forms;
using System.Collections.Generic;

namespace _3DMetalPrinterGUI
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        private const int SCALE = 5;
        private const int OFFSET = 75;
        double zHeight = 0;
        string filePath;
        Slicer slicer;
        public MainWindow()
        {
            InitializeComponent();
            filePath = fileLocation.Text;    
        }

        private List<Point> pointsOfFromSlicer(double zHeight, Slicer slcr)
        {
            
            List<Point> points = new List<Point>();

            foreach (var line in slcr.getSliceLineSegments(zHeight))
            {
                Point pointA = line.getStartPoint();
                Point pointB = line.getEndPoint();
                pointA.X = (pointA.X + OFFSET) * SCALE;
                pointA.Y = (pointA.Y + 50) * SCALE;
                pointB.X = (pointB.X + OFFSET) * SCALE;
                pointB.Y = (pointB.Y + 50) * SCALE;
                points.Add(pointA);
                points.Add(pointB);
            }

            return points;
        }

        //I want to draw one point at a time
        private void drawPoint(Point point, Canvas c)
        {
            
        }

        private void drawPoints(List<Point> points, Canvas c)
        {
            if (points.Count > 0)
            {
                PathGeometry pGeo = new PathGeometry();
                PathFigure pFig = new PathFigure();
                pFig.StartPoint = points[0];

                PolyLineSegment pLine = new PolyLineSegment();
                pLine.Points = new PointCollection(points);
                pFig.Segments.Add(pLine);

                pGeo.Figures.Add(pFig);

                System.Windows.Shapes.Path myPath = new System.Windows.Shapes.Path();
                myPath.Data = pGeo;
                if (zHeight % 2 == 1)
                {
                    myPath.Stroke = Brushes.Red;
                }
                else
                {
                    myPath.Stroke = Brushes.Blue;
                }
                myPath.StrokeThickness = .25;
                c.Children.Add(myPath);
            }
        }
        //Displays Form for File Selection
        private void browser_Click(object sender, RoutedEventArgs e)
        {
        
            OpenFileDialog openFileDialog1 = new OpenFileDialog();
            openFileDialog1.Filter = "STL files (*.STL)|*.STL";
            if (openFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                filePath = openFileDialog1.FileName;
                fileLocation.Text = filePath;
              
            }
        }

        //RIGHT NOW THIS DRAWS 
        private void slice_Click(object sender, RoutedEventArgs e)
        {
            
            if (filePathCheck())
            {
                slicer = new Slicer(filePath);

                while (zHeight < 100)
                {

                    drawPoints(pointsOfFromSlicer(zHeight, slicer), drawingCanvas);
                    zHeight += .005;
                }
            }
        }

        private void print_Click(object sender, RoutedEventArgs e)
        {
            if (filePathCheck())
            {
                slicer = new Slicer(filePath);
                drawPoints(pointsOfFromSlicer(zHeight, slicer), drawingCanvas);
                zHeight += .1;
            }

           
        }

        //Updates filePath if Enter key is pressed when in the TextBox
        private void fileLocation_PreviewKeyDown_Enter(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if(e.Key == System.Windows.Input.Key.Return)
            {
                filePathCheck();
                e.Handled = true;
            }
        }

        //Updates filePath based of textbox
        private bool filePathCheck()
        {
           
            if (filePath != fileLocation.Text)
            {
                if (CanOpenFile(fileLocation.Text))
                {
                    filePath = fileLocation.Text;
                    return true;
                }else
                {
                    //Print error message
                    return false;
                }
            }
            return true;
        }

        //Checks to see if you can open file
        private bool CanOpenFile(String file)
        {
            try
            {
                File.Open(file, FileMode.Open, FileAccess.Read).Dispose();
                return true;
            }
            catch (IOException)
            {
                return false;
            }
        }

        private void clear_Click(object sender, RoutedEventArgs e)
        {
            drawingCanvas.Children.Clear();
        }
    }
}
