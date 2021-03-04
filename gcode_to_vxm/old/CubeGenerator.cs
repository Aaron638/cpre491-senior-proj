using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PrinterControl
{
    class CubeGenerator
    {
        // Enum constants for various options
        public const int HATCH_ALTERNATION_CHECKERBOARD = 0;
        public const int HATCH_ALTERNATION_RANDOM = 1;
        public const int HATCH_ALTERNATION_NONE = 2;

        public const int INFILL_SQUARE_ORDER_SEQUENTIAL = 0;
        public const int INFILL_SQUARE_ORDER_RANDOM = 2;
        public const int INFILL_SQUARE_ORDER_EVERY_OTHER = 1;
        public const int INFILL_SQUARE_ORDER_RANDOM_AVOID_NEIGHBORS = 3;

        public const int HATCH_DIRECTION_1 = 0;
        public const int HATCH_DIRECTION_2 = 1;

        private StreamWriter outfile;

        private int spotSize;
        private int angleSpotSize;
        private int numInfillPerimeterLines;
        private int numPerimeterLines;
        private int numberInfillSquaresX;
        private int numberInfillSquaresY;
        private int infillSquareSize;
        private int hatchDirectionAlternation;
        private int infillSquareOrder;

        private bool firstLine = true;
        private bool laserState;
        private bool laserStateDefect;
        private bool defectState = false;
        private int defectX1;
        private int defectX2;
        private int defectY1;
        private int defectY2;
        private int defectZ1;
        private int defectZ2;

        private int currentZ = 0;

        private int writeXOffset = 0;
        private int writeYOffset = 0;
        private int writeMultiply = 1;

        /// <summary>
        /// Coonstructor for a CubeGenerator object. Initializes the StreamWriter by passing a string.
        /// </summary>
        /// <param name="outfile">
        /// The name of the file to be passed to the StreamWriter
        /// </param>
        public CubeGenerator(string outfile)
        {
            this.outfile = new StreamWriter(outfile);
        }

        /// <summary>
        /// Clears the buffer of the StreamWriter and closes the file to writing
        /// </summary>
        public void closeFile()
        {
            outfile.Flush();
            outfile.Close();
        }

        public void setHatchDirectionAlternation(int direction)
        {
            this.hatchDirectionAlternation = direction;
        }

        public void setInfillSquareOrder(int order)
        {
            this.infillSquareOrder = order;
        }

        public void setSpotSize(int spotSize)
        {
            this.spotSize = spotSize;
            // For infill hatching, space the grid larger to keep parallel line spacing at spot size. this assumes all infill hatches are drawn at 45 angle
            this.angleSpotSize = (spotSize * 1414) / 1000;
        }

        public void setNumInfillPerimeterLines(int numInfillPerimeterLines)
        {
            this.numInfillPerimeterLines = numInfillPerimeterLines;
        }

        public void setNumPerimeterLines(int numPerimeterLines)
        {
            this.numPerimeterLines = numPerimeterLines;
        }

        public void setNumberInfillSquares(int numberInfillSquaresX, int numberInfillSquaresY)
        {
            this.numberInfillSquaresX = numberInfillSquaresX;
            this.numberInfillSquaresY = numberInfillSquaresY;
        }

        public void setInfillSquareSize(int infillSquareSize)
        {
            this.infillSquareSize = infillSquareSize;
        }

        public void setDefectState(bool defectState)
        {
            this.defectState = defectState;
        }

        public void setDefect(double sizeX, double sizeY, double sizeZ, double x, double y, double z)
        {
            defectX1 = Convert.ToInt32(x * 1000000);
            defectX2 = Convert.ToInt32(sizeX * 1000000) + defectX1;
            defectY1 = Convert.ToInt32(y * 1000000);
            defectY2 = Convert.ToInt32(sizeY * 1000000) + defectY1;
            defectZ1 = Convert.ToInt32(z * 1000000);
            defectZ2 = Convert.ToInt32(sizeZ * 1000000) + defectZ1;
        }

        /// <summary>
        /// Draws a cube by writing instructions to the outfile. The first line specifies the length and width. Continues to write lines to the file for each layer.
        /// </summary>
        /// <param name="layerThickness">
        /// The thickness of each individual layer in millimeters. One of two variables that determine the number of layers.
        /// </param>
        /// <param name="height">
        /// The height in millimeters of the cube that is being drawn. The other variable for determining the number of layers.
        /// </param>
        public void drawCube(double layerThickness, double height)
        {
            // Determine the number of layers in the cube
            int numLayers = Convert.ToInt32(Math.Round(height / layerThickness));
            // Write the width and length as the first line in the outfile
            outfile.WriteLine("Width:" + numberInfillSquaresX * (infillSquareSize / spotSize) + " Length:" + numberInfillSquaresY * (infillSquareSize / spotSize));
            // Loops once for each layer in the cube
            for (int i = 0; i < numLayers; i++)
            {
                // Writes a new line to the file
                // Instruction is for a layer change
                outfile.WriteLine("M200 " + layerThickness.ToString());
                // Update the current Z position of the cube
                currentZ += Convert.ToInt32(layerThickness * 100000);
                drawLayer(i % 2);
            }
        }

        // direction = 0 -> top left square direction 0, checkerboard; direction = 1 -> top left square direction 1, checkerboard; direction = 2 -> random
        public void drawLayer(int direction)
        {
            List<InfillSquare> infillSquareList = new List<InfillSquare>();
            Random r = new Random();

            setWriteOffset(0, 0);

            setWriteMultiply(spotSize);

            // Draw perimeter
            for (int i = 1; i < numPerimeterLines + 1; i++)
            {
                writeLaserOn();
                writePoint(-i, -i);
                writePoint(-i, numberInfillSquaresY * (infillSquareSize / spotSize) + i + numberInfillSquaresY - 1);
                writePoint(numberInfillSquaresX * (infillSquareSize / spotSize) + i + numberInfillSquaresX - 1, numberInfillSquaresY * (infillSquareSize / spotSize) + i + numberInfillSquaresY - 1);
                writePoint(numberInfillSquaresX * (infillSquareSize / spotSize) + i + numberInfillSquaresX - 1, -i);
                writePoint(-i, -i);
                writeLaserOff();
            }

            // Populate the infill square list
            if (hatchDirectionAlternation == HATCH_ALTERNATION_CHECKERBOARD)
            {
                for (int i = 0; i < numberInfillSquaresY; i++)
                {
                    for (int j = 0; j < numberInfillSquaresX; j++)
                    {
                        if (direction == 0)
                        {
                            infillSquareList.Add(new InfillSquare(j * (infillSquareSize + spotSize), i * (infillSquareSize + spotSize), (i * numberInfillSquaresX + j) % 2));
                        }
                        else
                        {
                            infillSquareList.Add(new InfillSquare(j * (infillSquareSize + spotSize), i * (infillSquareSize + spotSize), (i * numberInfillSquaresX + j + 1) % 2));
                        }
                    }
                }
            }
            else if (hatchDirectionAlternation == HATCH_ALTERNATION_NONE)
            {
                for (int i = 0; i < numberInfillSquaresY; i++)
                {
                    for (int j = 0; j < numberInfillSquaresX; j++)
                    {
                        infillSquareList.Add(new InfillSquare(j * (infillSquareSize + spotSize), i * (infillSquareSize + spotSize), 0));
                    }
                }
            }
            else if (hatchDirectionAlternation == HATCH_ALTERNATION_RANDOM)
            {
                for (int i = 0; i < numberInfillSquaresY; i++)
                {
                    for (int j = 0; j < numberInfillSquaresX; j++)
                    {
                        infillSquareList.Add(new InfillSquare(j * (infillSquareSize + spotSize), i * (infillSquareSize + spotSize), r.Next() % 2));
                    }
                }
            }

            if (infillSquareOrder == INFILL_SQUARE_ORDER_SEQUENTIAL)
            {
                for (int i = 0; i < infillSquareList.Count; i++)
                {
                    InfillSquare square = infillSquareList[i];
                    drawInfillSquare(square.startX, square.startY, infillSquareSize / spotSize, square.hatchDirection);
                }
            }
            else if (infillSquareOrder == INFILL_SQUARE_ORDER_EVERY_OTHER)
            {
                for (int i = 0; i < infillSquareList.Count; i += 2)
                {
                    InfillSquare square = infillSquareList[i];
                    drawInfillSquare(square.startX, square.startY, infillSquareSize / spotSize, square.hatchDirection);
                }

                for (int i = 1; i < infillSquareList.Count; i += 2)
                {
                    InfillSquare square = infillSquareList[i];
                    drawInfillSquare(square.startX, square.startY, infillSquareSize / spotSize, square.hatchDirection);
                }
            }
            else if (infillSquareOrder == INFILL_SQUARE_ORDER_RANDOM)
            {
                while (infillSquareList.Count > 0)
                {
                    int squareIndex = r.Next() % infillSquareList.Count;
                    InfillSquare square = infillSquareList[squareIndex];
                    infillSquareList.RemoveAt(squareIndex);
                    drawInfillSquare(square.startX, square.startY, infillSquareSize / spotSize, square.hatchDirection);
                }
            }
            else if (infillSquareOrder == INFILL_SQUARE_ORDER_RANDOM_AVOID_NEIGHBORS)
            {
                //TODO - Not worrying about this for now
            }

        }

        // Units of integer values = nanometers
        public void drawInfillSquare(int startX, int startY, int sizeInSpotSizes, int hatchDirection)
        {
            var i = 0;
            setWriteOffset(startX, startY);
            setWriteMultiply(spotSize);

            int sizeInAngleSpotSizes = (sizeInSpotSizes * 1000) / 1414;

            if (hatchDirection == HATCH_DIRECTION_1)
            {
                // Draw perimeter
                if (numInfillPerimeterLines > 0)
                {
                    writePoint(0, 0);
                    writeLaserOn();  // Laser on

                    for (i = 0; i < numInfillPerimeterLines; i++)
                    {
                        writePoint(i, sizeInSpotSizes - i);
                        writePoint(sizeInSpotSizes - i, sizeInSpotSizes - i);
                        writePoint(sizeInSpotSizes - i, i);
                        writePoint(i + 1, i);
                    }
                }

                setWriteMultiply(1);

                // Draw hatches
                i = 1;
                var alternate = true;
                while (i * angleSpotSize < (sizeInSpotSizes - numInfillPerimeterLines * 2) * spotSize)
                {
                    if (alternate)
                    {
                        writePoint(numInfillPerimeterLines * spotSize, numInfillPerimeterLines * spotSize + i * angleSpotSize);
                        writePoint(numInfillPerimeterLines * spotSize + i * angleSpotSize, numInfillPerimeterLines * spotSize);
                    }
                    else
                    {
                        writePoint(numInfillPerimeterLines * spotSize + i * angleSpotSize, numInfillPerimeterLines * spotSize);
                        writePoint(numInfillPerimeterLines * spotSize, numInfillPerimeterLines * spotSize + i * angleSpotSize);
                    }
                    alternate = !alternate;
                    i++;
                }

                i = 1;
                while (i * angleSpotSize < (sizeInSpotSizes - numInfillPerimeterLines * 2) * spotSize)
                {
                    if (alternate)
                    {
                        writePoint(numInfillPerimeterLines * spotSize + i * angleSpotSize, (sizeInSpotSizes - numInfillPerimeterLines) * spotSize);
                        writePoint((sizeInSpotSizes - numInfillPerimeterLines) * spotSize, numInfillPerimeterLines * spotSize + i * angleSpotSize);
                    }
                    else
                    {
                        writePoint((sizeInSpotSizes - numInfillPerimeterLines) * spotSize, numInfillPerimeterLines * spotSize + i * angleSpotSize);
                        writePoint(numInfillPerimeterLines * spotSize + i * angleSpotSize, (sizeInSpotSizes - numInfillPerimeterLines) * spotSize);
                    }
                    alternate = !alternate;
                    i++;
                }
                writeLaserOff();  // Laser off
            }
            else
            {
                setWriteMultiply(spotSize);

                // Draw perimeter
                if (numInfillPerimeterLines > 0)
                {
                    writePoint(0, sizeInSpotSizes);
                    writeLaserOn();  // Laser on

                    for (i = 0; i < numInfillPerimeterLines; i++)
                    {
                        writePoint(i, i);
                        writePoint(sizeInSpotSizes - i, i);
                        writePoint(sizeInSpotSizes - i, sizeInSpotSizes - i);
                        writePoint(i + 1, sizeInSpotSizes - i);
                    }
                }

                setWriteMultiply(1);

                // Draw hatches
                i = 1;
                var alternate = false;
                while (i * angleSpotSize < (sizeInSpotSizes - numInfillPerimeterLines * 2) * spotSize)
                {
                    if (alternate)
                    {
                        writePoint(numInfillPerimeterLines * spotSize + i * angleSpotSize, (sizeInSpotSizes - numInfillPerimeterLines) * spotSize);
                        writePoint(numInfillPerimeterLines * spotSize, (sizeInSpotSizes - numInfillPerimeterLines) * spotSize - i * angleSpotSize);
                    }
                    else
                    {
                        writePoint(numInfillPerimeterLines * spotSize, (sizeInSpotSizes - numInfillPerimeterLines) * spotSize - i * angleSpotSize);
                        writePoint(numInfillPerimeterLines * spotSize + i * angleSpotSize, (sizeInSpotSizes - numInfillPerimeterLines) * spotSize);
                    }
                    alternate = !alternate;
                    i++;
                }

                i = 1;
                while (i * angleSpotSize < (sizeInSpotSizes - numInfillPerimeterLines * 2) * spotSize)
                {
                    if (alternate)
                    {
                        writePoint((sizeInSpotSizes - numInfillPerimeterLines) * spotSize, (sizeInSpotSizes - numInfillPerimeterLines) * spotSize - i * angleSpotSize);
                        writePoint(numInfillPerimeterLines * spotSize + i * angleSpotSize, numInfillPerimeterLines * spotSize);
                    }
                    else
                    {
                        writePoint(numInfillPerimeterLines * spotSize + i * angleSpotSize, numInfillPerimeterLines * spotSize);
                        writePoint((sizeInSpotSizes - numInfillPerimeterLines) * spotSize, (sizeInSpotSizes - numInfillPerimeterLines) * spotSize - i * angleSpotSize);
                    }
                    alternate = !alternate;
                    i++;
                }
                writeLaserOff();  // Laser off

                setWriteMultiply(spotSize);
            }
        }

        private void setWriteOffset(int x, int y)
        {
            writeXOffset = x;
            writeYOffset = y;
        }

        private void setWriteMultiply(int m)
        {
            writeMultiply = m;
        }

        /// <summary>
        /// Writes a new line to the outfile with the instruction to turn on the laser
        /// </summary>
        private void writeLaserOn()
        {
            laserState = true;
            outfile.WriteLine("M201");
        }

        /// <summary>
        /// Writes a new line to the outfile with the instruction to turn off the laser
        /// </summary>
        private void writeLaserOff()
        {
            laserState = false;
            outfile.WriteLine("M202");
        }

        /// <summary>
        /// Writes a new line to the outfile with the instruction to enable the defect mode of the laser
        /// </summary>
        private void writeLaserOnDefect()
        {
            laserStateDefect = true;
            outfile.WriteLine("M201");
        }

        /// <summary>
        /// Writes a new line to the outfile with the instruction to disable the defect mode of the laser
        /// </summary>
        private void writeLaserOffDefect()
        {
            laserStateDefect = false;
            outfile.WriteLine("M202");
        }

        private bool inDefectZone(int x, int y)
        {
            x = (x * writeMultiply) + writeXOffset;
            y = (y * writeMultiply) + writeYOffset;

            if (currentZ >= defectZ1 && currentZ <= defectZ2)
            {
                if (x >= defectX1 && x <= defectX2)
                {
                    if (y >= defectY1 && y <= defectY2)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        private void writePoint(int x, int y)
        {
            if (defectState)
            {
                if (inDefectZone(x, y))
                {
                    if (laserState && laserStateDefect)
                    {
                        writeLaserOffDefect();
                    }
                }
                else
                {
                    if (laserState && !laserStateDefect)
                    {
                        writeLaserOnDefect();
                    }
                }
            }


            double xInUm = ((x * writeMultiply) + writeXOffset) / 1000;
            double yInUm = ((y * writeMultiply) + writeYOffset) / 1000;

            double xInMm = xInUm / 1000.0;
            double yInMm = yInUm / 1000.0;
            outfile.WriteLine("G1 X{0:0.0000} Y{1:0.0000}", xInMm, yInMm);

            //Console.WriteLine("G1 X{0} Y{1}", x, y);
        }
    }
}
