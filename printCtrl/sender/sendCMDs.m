% Executes the instructions in printerActions.txt by sending commands to the motor controllers and the laser.
% 
function sendCMDs(inputfile)

    % Change ports, baud, and/or IP address in CONFIG.m
    CFG = CONFIG();
    twinVXM = serialport(CFG.PORT_TWIN, CFG.BAUD_VXM);
    soloVXM = serialport(CFG.PORT_SOLO, CFG.BAUD_VXM);
    laserTCP = tcpclient(CFG.IP_LASER, CFG.PORT_LASER);

    infoFlag = false;

    pa.index = 0;
    pa.device = '';
    pa.port = '';
    pa.actions = [];
    pa.gcode = '';

    % Read file line by line as a string array
    fileData = readlines(inputfile);
    disp("Reading file: " + inputfile);

    % Parse each line of toml
    for i = 1:length(fileData)
        curLine = fileData(i);

        % Read info header and print
        if curLine == '[Info]'
            infoFlag = true;
        elseif infoFlag && curLine == '[[printerAction]]'
            infoFlag = false;
        else
            disp("%s", curLine);
        end
           
        % Execute commands once we encounter another [[printerAction]]
        if curLine == '[[printerAction]]'
            
            % If this is the first [[printerAction]], read until the next [[printerAction]]
            if pa.index == 0
                continue;

            elseif device == 'Motor'
                if pa.port == CFG.PORT_TWIN
                    r = executeMotor(pa, twinVXM);
                    disp(r);
                elseif pa.port == CFG.PORT_SOLO
                    r = executeMotor(pa, soloVXM);
                    disp(r);
                else
                    error("ERROR: Invalid motor port %s at index %d", pa.port, pa.index);
                end
                
                % TODO speicify difference between pilot and nonpilot laser
            elseif device == 'Laser'
                r = executeLaser(pa);
                disp(r);

            else
                error("ERROR: Invalid device %s at index %d", pa.device, pa.index);
            end

        % Comment
        elseif startsWith(curLine, '#')
            disp(curLine);
            continue;

        % Empty line, skip
        elseif curLine == ""
            continue;
        
        else
            % TODO: write code for reading lines into the struct.
            error("ERROR: Encountered unexpected text on line %d.", i);
            % disp("Paused. Press any button to continue, or Ctrl+C to stop.");
            % pause();
        end

    end

    flush(twinVXM); flush(soloVXM); %flush(laser);
    delete(twinVXM); delete(soloVXM); %delete(laser);

    disp("Finished Reading File.");
end
