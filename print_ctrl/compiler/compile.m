% Reads in a .gcode file, and maps each line to a printer action:
%   G01 X{x} Y{y} = Move 3-axis roller to x,y
%   G01 Z{z}      = Increment Print Bed and Decrement Supply Bed by z
%   M200          = Reset roller b3d, and 3-axis motors to absolute zero
%   M201          = Laser On
%   M202          = Laser Off
%
%   Outputs a txt file printerActions.txt with 2 columns separated by a space.
%   First column indiciates device, the port to send the command to.
%   Second column indicates actual command to be sent.
%   Returns early if gcode file is invalid
%
% gcode uses millimeters as units.
% All positioning is absolute, not relative.

function compile(filename)

    map = VXM_MOTOR_MAP;
    xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
    xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;
    gcodeLineStrArr = [];
    printerAction   = "";
    printerDevice   = "";

    % Read file line by line as a string array
    fileData = readlines(filename);
    disp("Reading file: " + filename);

    % Write actions to printerActions.txt
    actionsFile = fopen('printerActions.txt','w');

    % Check if file has width and height
    curLine = fileData(1);
    disp("Line [1]: " + curLine);
    if (contains(curLine, 'Width: ') && contains(curLine, 'Length: '))
        gcodeLineStrArr = split(curLine);
        objWidth  = gcodeLineStrArr(2);
        objLength = gcodeLineStrArr(4);
    else
        disp("ERROR: gcode file does not properly define width/length.");
        disp("Line 1 must start with: 'Width: {x} Length: {y}'");
        return;
    end

    % For each line starting at line 2, call the corresponding command
    for i = 2:size(fileData)

        curLine = fileData(i);
        disp(compose("Line [%d]: ", i) + curLine);

        % Axis Move to (x,y)
        if startsWith(curLine, 'G01 X')
            gcodeLineStrArr = split(curLine);
            xCur = getNumsFromStr(gcodeLineStrArr(2));
            yCur = getNumsFromStr(gcodeLineStrArr(3));

            printerDevice = map.port_a; % see VXM_MOTOR_MAP
            printerAction = moveAxis(xPrev, yPrev, xCur, yCur);

        % Layer Change to (z)
        elseif startsWith(curLine, 'G01 Z')
            gcodeLineStrArr = split(curLine);
            zCur = getNumsFromStr(gcodeLineStrArr(2));

            % First, Move Print and Supply Bed
            % Assume Motor 5 & 6 have the same port
            printerDevice = map.port_b;
            printerAction = moveBed(zCur);
            % Write to file
            fprintf(actionsFile, '%s, \t %s\r', printerDevice, printerAction);

            % Next, Sweep the Roller
            printerDevice = map.port_a;
            printerAction = sweepRoller();

        % Reset to absolute zero position
        elseif (contains(curLine, 'M200'))
            xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
            xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;

            % Zero the Axis motors
            printerDevice = map.port_a; 
            printerAction = zeroAxis();
            fprintf(actionsFile, '%s, \t %s\r', printerDevice, printerAction);
            
            % Zero the Roller by sweeping it
            printerDevice = map.port_a;
            printerAction = sweepRoller();
            fprintf(actionsFile, '%s, \t %s\r', printerDevice, printerAction);
            
            % Zero the Beds
            printerDevice = map.port_b; 
            printerAction = zeroBeds();

        % Turn the laser on
        elseif startsWith(curLine, 'M201')
            printerDevice = LASER_PORT; 
            printerAction = laserOn();

        % Turn the laser off
        elseif startsWith(curLine, 'M202')
            printerDevice = LASER_PORT; 
            printerAction = laserOff();
        
        % Empty line, ignore
        elseif startsWith(curLine, "")
            continue;

        % Encountered unexpected text, pause and wait for user
        else
            disp("ERROR: Encountered unexpected text.");
            disp("PAUSED. Press any key to unpause");
            pause;

        end

        % Write printer action to actionsFile
        fprintf(actionsFile, '%s, \t %s\r', printerDevice, printerAction);

        % Update previous (x,y,z)
        xPrev = xCur; yPrev = yCur; zPrev = zCur;
        
    end

    fclose(actionsFile);
    disp("Finished parsing gcode file.");
    
end
