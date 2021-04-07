function M = MinimumCodeToMoveMotor
%See VXM Driver Documentation for Details
%
%
%The DriverTerminalShowState command is for debug purposes and not
%necessary to move the VXM motor
    LoadDriver
    %DriverTerminalShowState(1, 0)   %Show Terminal on Desktop
    PortOpen(1, 9600)   %Open Com1 at 9600 Baud
    PortSendCommands('F,C,I1M400,I1M-400,R')    %Motor 1 Move 400 steps positive then 400 steps negative
    PortWaitForChar('^', 0)     %Halt program until VXM sends back a "^" indicating that it has completed its program
    PortClose
    DriverTerminalShowState(0, 0)   %Hide Terminal   
end