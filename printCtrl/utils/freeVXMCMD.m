% Utility function which opens a com port, then runs the VXM command.
% Will send any ASCII command to the VXM motor controllers without any validation.
% The function will continue to read until it recieves a '^' character, indicating termination or until it times out.
% Returns the response from the VXM motor controller.
% 
function response = freeVXMCMD(port, cmdString)
    device = serialport(port, 9600);
    flush(device);
    cmdString = compose("%s\r", cmdString);
    write(device, cmdString, "uint8");
    response = "";
    while response ~= '^'
        response = read(device, 1, "uint8");
    end
    flush(device);
    delete(device);

end