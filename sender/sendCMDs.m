% Parses and executes the instructions in the TOML file by sending commands to the motor controllers and the laser. 
% Potential optimizations:
% Use regular expressions and a switch statement
% Vectorize more things
% Rearrange control flow for minor runtime improvements
%   comment and emptyline detection before other if statements
%
% UNFINISHED:
%    As of right now, we don't actually parse toml properly. For example:
%        actions = ["cmd", "cmd", "cmd"]
%    is not valid syntax for this file, as we expect a carriage return before the closing bracket.
%   Parse the laser response to see what it means.
%       Use bitmapping to map response bits to different meanings.
% 
function sendCMDs(inputfile)

    % Change ports, baud, or IP address in CONFIG.m if needed
    CFG = CONFIG();
    twinVXMdevice = serialport(CFG.PORT_TWIN, CFG.BAUD_VXM);
    soloVXMdevice = serialport(CFG.PORT_SOLO, CFG.BAUD_VXM);
    laserTCPdevice = tcpclient(CFG.IP_LASER, CFG.PORT_LASER);
    % VISAobj = visa('keysight', 'USB::0x0957::0x0407::MY44034072::0::INSTR');
    % funcGendevice = icdevice('agilent_33220a.mdd', VISAobj);
    VISAobj = visa(CFG.VISA_VENDOR_FG, CFG.RSRC_FG);
    funcGendevice = icdevice(CFG.DRIVER_FG, VISAobj);
    connect(funcGendevice);
    %devicereset(funcGendevice);

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
        % fprintf("Line [%d]: %s", i, curLine);

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
            if pa.device == "Motor"
                pa.actions = string(pa.actions);

                if pa.port == CFG.PORT_TWIN
                    executeMotor(pa, twinVXMdevice);

                elseif pa.port == CFG.PORT_SOLO
                    executeMotor(pa, soloVXMdevice);
                else
                    error("ERROR: Invalid motor port %s at index %d", pa.port, pa.index);
                end
                disp("Sent to " + pa.port + ":");
                fprintf("%s\r", pa.actions);
                
            % Execute Laser Commands
            elseif pa.device == "Laser"
                pa.actions = uint8(pa.actions);

                % UNFINISHED: Verify proper syntax before sending
                executeLaser(pa, laserTCPdevice);
                disp("Sent to Laser:");
                fprintf("%02X ", pa.actions);
                fprintf("\n");

                % UNFINISHED: Laser reading is potentially broken
                %r = readLaser(laserTCPdevice);
                %validLaserResp(r); % Validates laser response
                %disp("Recieved from Laser:")
                %fprintf("%02X ", r);

                % UNFINISHED: Parse the laser response

            % Toggle the Function Generator
            elseif pa.device == "FuncGen"
                if pa.actions == "on"
                    set(funcGendevice, 'Output', 'on');
                
                elseif pa.actions == "off"
                    set(funcGendevice, 'Output', 'off');
                
                else
                    killMotors();
                    % Maybe use try-catch block here?
                    set(funcGendevice, 'Output', 'off');
                    disconnect(funcGendevice);
                    delete(funcGendevice);
                    delete(VISAobj);
                    error("ERROR: Invalid function generator command %s at index %d", pa.actions, pa.index);
                end

            else
                error("ERROR: Invalid device %s at index %d", pa.device, pa.index);
            end

            % Clear the stringBlock
            stringBlock = "";

        % Append curLine to stringBlock
        else
           stringBlock = sprintf("%s%s\n", stringBlock, curLine);
        end
    end

    flush(twinVXMdevice); flush(soloVXMdevice); %flush(laser);
    delete(twinVXMdevice); delete(soloVXMdevice); delete(laserTCPdevice);
    disconnect(funcGendevice);
    delete(funcGendevice);
    delete(VISAobj);

    disp("Finished Reading File.");
end