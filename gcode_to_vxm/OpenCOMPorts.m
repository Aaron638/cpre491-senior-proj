function [ThreeAxisRollerCOM, PowderBedsCOM] = OpenCOMPorts()
    %SERIALCOM This function connects to the COM port
    baud = 9600;

    serialportlist

    prompt = 'Select a COM port for the Three Axis and Roller: ';
    ThreeAxisRollerInput = input(prompt);

    prompt = 'Select a COM port for the Powder Beds: ';
    PowderBedsInput = input(prompt);

    %prompt = 'Select a COM port for the Sensor System: ';
    %SensorSystemInput = input(prompt);

    ThreeAxisRollerCOM = serialport(ThreeAxisRollerInput, baud);
    PowderBedsCOM = serialport(PowderBedsInput, baud);
    %SensorSystemCOM = serialport(SensorSystemInput, baud);
    
    %writeline(ThreeAxisRollerCOM,"F");
    %writeline(PowderBedsCOM,"F");

end

