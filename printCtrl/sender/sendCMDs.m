% Executes the instructions in the compiler generated .toml file by sending commands to the motor controllers and the laser.
% 
% Potential optimizations:
% Use regular expressions and a switch statement
% Vectorize more things
% Rearrange control flow for minor runtime improvements
%   comment and emptyline detection before other if statements
%
%{
    UNFINISHED:
    As of right now, we don't actually properly parse toml. For example:
        actions = ["cmd", "cmd", "cmd"]
    is not valid syntax, as we expect a carriage return before the closing bracket.
    
%} 
%
function sendCMDs(inputfile)

    % Change ports, baud, and/or IP address in CONFIG.m
    CFG = CONFIG();
    % twinVXMdevice = serialport(CFG.PORT_TWIN, CFG.BAUD_VXM);
    % soloVXMdevice = serialport(CFG.PORT_SOLO, CFG.BAUD_VXM);
    % laserTCPdevice = tcpclient(CFG.IP_LASER, CFG.PORT_LASER);
    % VISAobj = = visa('keysight', 'USB::0x0957::0x0407::MY44034072::0::INSTR');
    % funcGendevice = icdevice('agilent_33220a.mdd', VISAobj);
    % connect(funcGendevice);
    % devicereset(funcGendevice);

    isFirstAction = true;
    stringBlock = "";
    
    pa.index = 0;
    pa.device = '';
    pa.port = '';
    pa.actions = [];
    pa.gcode = '';

    % Read file line by line as a string array
    fileData = readlines(inputfile);
    disp("Reading file: " + inputfile);

    for i = 1:length(fileData)
        curLine = fileData(i);
        % disp(compose("Line [%d]: %s", i, curLine));

        if curLine == "[[printerAction]]" || i == length(fileData)

            % Print [Info]
            % Skip the first "[[printerAction]]" string
            if isFirstAction
                disp(stringBlock);
                stringBlock = "";
                isFirstAction = false;
                continue;
            end

            % Completed reading printerAction
            % Parse and execute commands
            try
                pa = toml.decode(stringBlock);
            catch
                % Potential error with invalid toml syntax.
                error("ERROR: Issues parsing syntax at index %d", pa.index);
            end

            % Execute Motor Commands
            if pa.device == 'Motor'
                pa.actions = string(pa.actions);

                if pa.port == CFG.PORT_TWIN
                    % executeMotor(pa, twinVXMdevice);

                elseif pa.port == CFG.PORT_SOLO
                    % executeMotor(pa, soloVXMdevice);
                else
                    error("ERROR: Invalid motor port %s at index %d", pa.port, pa.index);
                end
                disp("Sent to " + pa.port + ":");
                disp(sprintf("%s\r", pa.actions));
                
            % Execute Laser Commands
            elseif pa.device == 'Laser'
                pa.actions = uint8(pa.actions);

                % TODO: Verify proper syntax before sending
                % executeLaser(pa, laserTCPdevice);
                disp("Sent to Laser:");
                disp(sprintf("%02X ", pa.actions));
                % r = readLaser(laserTCPdevice);
                % disp("Recieved: " + r);
                % TODO: If r is an error, trigger error handling.

            % Toggle the Function Generator
            elseif pa.device == 'FuncGen'
                if pa.actions == 'on'
                    % set(funcGendevice, 'Output', 'on')
                elseif pa.actions == 'off'
                    % set(funcGendevice, 'Output', 'off')
                else
                    killMotors();
                    killLaser();
                    error("CRITICAL ERROR: Invalid function generator command %s at index %d", pa.actions, pa.index);
                end

            else
                error("ERROR: Invalid device %s at index %d", pa.device, pa.index);
            end

            % Clear the stringBlock
            stringBlock = "";

        % Append to stringBlock
        else
           stringBlock = sprintf("%s%s\n", stringBlock, curLine);
        end
    end

    % flush(twinVXMdevice); flush(soloVXMdevice); %flush(laser);
    % delete(twinVXMdevice); delete(soloVXMdevice); delete(laserTCPdevice);
    % disconnect(funcGendevice);
    % delete(funcGendevice);
    % delete(VISAobj);

    disp("Finished Reading File.");
end