% Utility function which opens a com port, then moves the given motor a given distance in steps.
% Uses the standard move command ImMx, where m is the motor index, and x is the distance in steps.
% The function will continue to read until it recieves a '^' character, indicating termination or until it times out.
% Returns the response from the VXM motor controller.
% 
% Usage: 
%   % Use freemove function to move motor 3, 500 steps:
%   freeMove(CFG.PORT_TWIN, CFG.VXM_XAXIS, 500);  % Using the global constants
% 
%   freeMove("COM5", 2, 500);               % Or do it manually
% 
function response = freeMove(port, motornum, dist_in_steps)
    device = serialport(port, 9600);
    flush(device);
    string = compose("F, C, I%dM%d, R,\r", motornum, dist_in_steps);
    write(device, string, "uint8");
    response = "";
    while response ~= '^'
        response = response + read(device, 1, "uint8");
    end
    flush(device);
    delete(device);

end