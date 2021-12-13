% stopMotors
% Interrupts running motor commands.
% Sends a stop command "D" to both serial ports connected to the VXM motors.
% Causes motors to decelerate to a stop. Safer than a kill command.
% See VXM-2 Users Manual for details
function stopMotors(serialTwin, serialSolo)
    cmd = sprintf("D\r");
    write(serialTwin, cmd, "uint8");
    write(serialSolo, cmd, "uint8");
    disp("Sent kill command.");

    % Ensures that we encounter a response before flushing and deleting the device.
    % Reads bytes until encoutnering '^' terminator
    configureTerminator(serialTwin, "^");
    configureTerminator(serialSolo, "^");

    try
        rT = readline(serialTwin, 1, "uint8");
        rS = readline(serialSolo, 1, "uint8");
    catch
        warning("WARN: Did not receieve '^' response from twin motors.");
        warning("WARN: Did not receieve '^' response from solo motors.");
    end
    
    disp(rT); disp(rS);
    flush(serialTwin); flush(serialSolo);
    delete(serialTwin); delete(serialSolo);
end