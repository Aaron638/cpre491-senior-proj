% killMotors
% Sends a kill command "K" to both serial ports connected to the VXM motors.
% Can potentially cause problems if motorspeed > 1000 steps/second
% See VXM-2 Users Manual for details
function killMotors(serialTwin, serialSolo)
    cmd = sprintf("K\r");
    write(serialTwin, cmd, "uint8");
    write(serialSolo, cmd, "uint8");
    disp("Sent kill command.");

    % Ensures that we encounter a response before flushing and deleting the device.
    try
        read(serialTwin, 1, "uint8");
        read(serialSolo, 1, "uint8");
    catch
        warning("WARN: Did not receieve response from kill command.");
    end

    flush(serialTwin); flush(serialSolo);
    delete(serialTwin); delete(serialSolo);
end