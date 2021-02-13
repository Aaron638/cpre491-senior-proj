using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using QuantumConcepts.Formats.StereoLithography;
using System.Windows;

namespace _3DMetalPrinterGUI
{ 
    class Slicer
    {
        public const double EPSILON = 0.001;
        //will calculated instead of constant
        

        private STLDocument stl;

        

        public Slicer()
        {

        }

       

        public Slicer(String stlFile)
        {
            this.stl = STLDocument.Open(stlFile);
        }


        private void openSTL(string stlFile)
        {
            this.stl = STLDocument.Open(stlFile);
        }

        public List<LineSegment> getSliceLineSegments(double zHeight)
        {
            List<LineSegment> results = new List<LineSegment>();

            // Iterate through each facet, if it does intersect, find eqn of line
            foreach(var facet in stl.Facets)
            {
                if(doesIntersect(facet, zHeight))
                {
                    
                    LineSegment ls = findLineSegment(facet, findIntersection(facet, zHeight), zHeight);
                    results.Add(ls);
                }
            }
   
            return results;
        }

        private bool doesIntersect(Facet facet, double zHeight)
        {
            // Check if one point on facet lies above zHeight and one lies below zHeight
            bool greaterThan = false;
            bool lessThan = false;

            for (var i = 0; i < 3; i++)
            {
                if (facet.Vertices[i].Z > zHeight)
                    greaterThan = true;
                else if (facet.Vertices[i].Z < zHeight)
                    lessThan = true;
            }

            // What to do for facets parallel to z plane? Probably ignore them...

            return greaterThan && lessThan;
        }

        private EquationOfLine findIntersection(Facet facet, double zHeight)
        {
            // First check if this will be a vertical line
            if (facet.Normal.Y == 0)
            {
                double x = (facet.Normal.X * facet.Vertices[0].X + facet.Normal.Y * facet.Vertices[0].Y + facet.Normal.Z * facet.Vertices[0].Z - facet.Normal.Z * zHeight) / facet.Normal.X;
                return new EquationOfLine(x);
            }

            // If not a vertical line
            double slope = -facet.Normal.X / facet.Normal.Y;
            double b = (facet.Normal.X * facet.Vertices[0].X + facet.Normal.Y * facet.Vertices[0].Y + facet.Normal.Z * facet.Vertices[0].Z - facet.Normal.Z * zHeight) / facet.Normal.Y;

            return new EquationOfLine(slope, b);
        }

        private LineSegment findLineSegment(Facet facet, EquationOfLine eqn, double zHeight)
        {
            int pointNumber = 0;
            Point p1 = new Point();
            Point p2 = new Point();
            
            // Line 2 is the z plane line
            double a2 = eqn.isVerticalLine() ? 0 : 1.0;
            double b2 = eqn.isVerticalLine() ? 1.0 : eqn.getSlope();
            double c2 = 0.0;

            double x2 = eqn.getPoint().X;
            double y2 = eqn.getPoint().Y;
            double z2 = zHeight;

            // Line 1 is the facet line
            // Go through each of the three facet lines as only two of them should intersect the z line
            for (var i = 0; i < 3; i++)
            {
                if (facet.Vertices[i].Z < zHeight && facet.Vertices[(i + 1) % 3].Z > zHeight
                    || facet.Vertices[i].Z > zHeight && facet.Vertices[(i + 1) % 3].Z < zHeight)
                {
                    double a1 = facet.Vertices[(i + 1) % 3].X - facet.Vertices[i].X;
                    double b1 = facet.Vertices[(i + 1) % 3].Y - facet.Vertices[i].Y;
                    double c1 = facet.Vertices[(i + 1) % 3].Z - facet.Vertices[i].Z;

                    double x1 = facet.Vertices[i].X;
                    double y1 = facet.Vertices[i].Y;
                    double z1 = facet.Vertices[i].Z;

                    //Console.WriteLine(x1.ToString() + " + " + a1.ToString() + " * t1 = " + x2.ToString() + " + " + a2.ToString() + " * t2");
                    //Console.WriteLine(y1.ToString() + " + " + b1.ToString() + " * t1 = " + y2.ToString() + " + " + b2.ToString() + " * t2");

                    double t1 = ((x2 - x1) * -b2 + a2 * (y2 - y1)) / (a1 * -b2 + a2 * b1);
                    double t2 = ((y2 - y1) * a1 - b1 * (x2 - x1)) / (a1 * -b2 + a2 * b1);

                    //Console.WriteLine("a1 = " + a1);
                    //Console.WriteLine("b1 = " + b1);
                    //Console.WriteLine("c1 = " + c1);
                    //Console.WriteLine("x1 = " + x1);
                    //Console.WriteLine("y1 = " + y1);
                    //Console.WriteLine("z1 = " + z1);
                    //Console.WriteLine("a2 = " + a2);
                    //Console.WriteLine("b2 = " + b2);
                    //Console.WriteLine("c2 = " + c2);
                    //Console.WriteLine("x2 = " + x2);
                    //Console.WriteLine("y2 = " + y2);
                    //Console.WriteLine("z2 = " + z2);
                    //Console.WriteLine("t1 = " + t1);
                    //Console.WriteLine("t2 = " + t2);

                    double xLine1 = x1 + a1 * t1;
                    double yLine1 = y1 + b1 * t1;
                    double zLine1 = z1 + c1 * t1;

                    double xLine2 = x2 + a2 * t2;
                    double yLine2 = y2 + b2 * t2;
                    double zLine2 = z2 + c2 * t2;

                    if(Math.Abs(xLine1 - xLine2) > EPSILON || Math.Abs(yLine1 - yLine2) > EPSILON || Math.Abs(zLine1 - zLine2) > EPSILON)
                    {
                        //TODO
                        //NEED TO FIGURE OUT WHAT TO DO WITH HOLLOW SHAPES
                        Console.WriteLine(Math.Abs(xLine1 - xLine2) + " " + Math.Abs(yLine1 - yLine2) + "    " + Math.Abs(zLine1 - zLine2));
                        Console.WriteLine("Epsilon error");
                        return null;
                    }
                    
                    //Console.WriteLine("(" + xLine1 + "," + yLine1 + "," + zLine1 + ") (" + xLine2 + "," + yLine2 + "," + zLine2 + ")");
                    
                    if (pointNumber == 0)
                    {
                        p1 = new Point(xLine1, yLine1);
                        pointNumber++;
                    }
                    else if(pointNumber == 1)
                    {
                        p2 = new Point(xLine1, yLine1);
                        pointNumber++;
                    }
                    else
                    {
                        Console.WriteLine("Too many intersection points error");
                        return null;
                    }
                }
            }

            return new LineSegment(p1, p2);
        }
    }
}
