% Reads in a .gcode file, and maps each line to a printer action:
%   G01 X{x} Y{y} = Move 3-axis roller to x,y
%   G01 Z{z}      = Move Powder Bed to z
%   M200          = Reset roller and bed to absolute zero
%   M201          = Laser On
%   M202          = Laser Off
%
%   Outputs a txt file printerActions.txt with 2 columns separated by a space.
%       First column indiciates device to send command to i.e. 'pbed', 'roll', 'lasr'.
%       Second column indicates actual command to be sent.
%   Returns early if gcode file is invalid
%
% gcode uses millimeters as units.
% All positioning is absolute, not relative.

function parseGcode(filename)

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

        % Move to (x,y)
        if startsWith(curLine, 'G01 X')
            gcodeLineStrArr = split(curLine);
            xCur = getNumsFromStr(gcodeLineStrArr(2));
            yCur = getNumsFromStr(gcodeLineStrArr(3));
            printerDevice = 'roll';
            printerAction = rollerMove(xPrev, yPrev, xCur, yCur);

        % Change elevation to (z)
        elseif startsWith(curLine, 'G01 Z')
            gcodeLineStrArr = split(curLine);
            zCur = getNumsFromStr(gcodeLineStrArr(2));
            printerDevice = 'pbed';
            printerAction = bedMove(zCur);

        % Reset to absolute zero position
        elseif (contains(curLine, 'M200'))
            fprintf(actionsFile, '%s, \t %s\r', 'roll', rollerZero());
            fprintf(actionsFile, '%s, \t %s\r', 'pbed', bedZero());
            xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
            xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;
            continue;

        % Turn the laser on
        elseif startsWith(curLine, 'M201')
            printerDevice = 'lasr';
            printerAction = laserOn();

        % Turn the laser off
        elseif startsWith(curLine, 'M202')
            printerDevice = 'lasr';
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
