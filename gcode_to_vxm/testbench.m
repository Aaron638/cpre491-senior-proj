% Testbench for testing things

% Read test.gcode
%gcodeReader("../test_files/gcode/test.gcode")

% Open the COM Ports
%[ThreeAxisRollerCOM, PowderBedsCOM] = OpenCOMPorts;

% Read the cmd files, and write to the COM ports
%writeCOMPorts(ThreeAxisRollerCOM, PowderBedsCOM);
%writeline(ThreeAxisRollerCOM,"F, PM-1, S3M 0 I3M 0, R\r\n");
%writeline(PowderBedsCOM,"E, PM-1, S3M 0 I3M 0, R\r\n");
%readline(ThreeAxisRollerCOM)

device = serialport("COM5",9600);
% writeline(device, "E")
% writeline(device, "V")
% writeline(device,"F, PM-1, S3M 0 I3M 0, R\r\n");
readline(device);