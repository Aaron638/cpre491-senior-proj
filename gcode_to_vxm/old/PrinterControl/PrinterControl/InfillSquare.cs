using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PrinterControl
{
    class InfillSquare
    {
        public int startX;
        public int startY;
        public int hatchDirection;

        public InfillSquare(int startX, int startY, int hatchDirection)
        {
            this.startX = startX;
            this.startY = startY;
            this.hatchDirection = hatchDirection;
        }
    }
}
