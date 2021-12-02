% killMotors
% Interrupts running motor commands.
% Sends a kill command "K" to both serial ports connected to the VXM motors.
% Can potentially cause problems if motorspeed > 1000 steps/second
% See VXM-2 Users Manual for details
function killMotors(serialTwin, serialSolo)
    cmd = sprintf("K\r");
    write(serialTwin, cmd, "uint8");
    write(serialSolo, cmd, "uint8");
    disp("Sent kill command.");

    % Trys to get a response before flushing and deleting the device.
    rT = read(serialTwin, 1, "uint8");
    rS = read(serialSolo, 1, "uint8");
    if rT ~= '^'
        warning("WARN: Did not receieve '^' response from twin motors.");
    end
    if rS ~= '^'
        warning("WARN: Did not receieve '^' response from solo motors.");
    end

    flush(serialTwin); flush(serialSolo);
    delete(serialTwin); delete(serialSolo);
end