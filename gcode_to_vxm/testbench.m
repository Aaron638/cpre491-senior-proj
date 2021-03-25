% Testbench for testing things

% Read test.gcode
gcodeReader("../test_files/gcode/test.gcode")

% Open the COM Ports
[ThreeAxisRollerCOM, PowderBedsCOM, SensorSystemCOM] = openCOMPorts;

% Read the cmd files, and write to the COM ports
writeCOMPort(ThreeAxisRollerCOM, PowderBedsCOM, SensorSystemCOM);