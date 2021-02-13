using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace _3DMetalPrinterGUI
{
    class LineSegment
    {
        private Point startPoint;
        private Point endPoint;

        
        public LineSegment()
        {
            startPoint = new Point(-1, -1);
            endPoint = new Point(-1, -1);
        }

        public LineSegment(Point start, Point end)
        {
            startPoint = start;
            endPoint = end;
        }

        public LineSegment(double x1, double y1, double x2, double y2)
        {
            startPoint = new Point(x1, y1);
            endPoint = new Point(x2, y2);
        }

        public void setStartPoint(Point start)
        {
            startPoint = start;
        }

        public void setStartPoint(double x, double y)
        {
            startPoint = new Point(x,y);
        }

        public void setEndPoint(Point end)
        {
            endPoint = end;
        }

        public void setEndPoint(double x, double y)
        {
            endPoint = new Point(x, y);
        }

        public Point getStartPoint()
        {
            return startPoint;
        }

        public Point getEndPoint()
        {
            return endPoint;
        }

        public override string ToString()
        {
            //return "( " + startPoint.X + " , " + startPoint.Y + " ) - " + "( " + endPoint.X + " , " + endPoint.Y + " )";
            return startPoint.X + "," + startPoint.Y + '\n' + endPoint.X + "," + endPoint.Y;
        }
    }
}
