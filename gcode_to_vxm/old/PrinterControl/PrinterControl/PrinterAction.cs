using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PrinterControl
{
    public class PrinterAction
    {
        // Each possible action for the printer motor is assigned a specific integer
        public const int ACTION_TYPE_VELMEX_MOVE = 1;
        public const int ACTION_TYPE_LASER_ON = 2;
        public const int ACTION_TYPE_LASER_OFF = 3;
        public const int ACTION_TYPE_LAYER_CHANGE = 4;
        public const int ACTION_TYPE_LAYER_CHANGE_2 = 5;

        // These are the only two instance variables for this object
        public int actionType;
        public string velmexCommand;

        /// <summary>
        /// Constructs a new PrinterAction object and initializes its variables
        /// </summary>
        /// <param name="actionType">
        /// The type of action the object will perform in integer form
        /// </param>
        /// The string name of the command that will be passed to the velmex
        /// <param name="velmexCommand"></param>
        public PrinterAction(int actionType, string velmexCommand)
        {
            this.actionType = actionType;
            this.velmexCommand = velmexCommand;
        }

        /// <summary>
        /// Converts its variables into a readable string format
        /// </summary>
        /// <returns>
        /// Returns the integer for the action type and the string associated with the command
        /// </returns>
        public override string ToString()
        {
            return actionType + ": " + velmexCommand;
        }
    }
}
