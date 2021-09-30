% Reads in a .gcode file, and maps each line to a printer action(s):
%   G01 X{x} Y{y} = Move 3-axis roller to x,y
%   G01 Z{z}      = Increment Print Bed and Decrement Supply Bed by z
%   M200          = Reset roller bed, and 3-axis motors to absolute zero
%   M201          = Laser On
%   M202          = Laser Off
%
%   Outputs a txt file printerActions.txt with 3 columns
%       First column indiciates the port to send the command to
%       Second column indicates actual command to be sent
%       Third column prints out the line of gcode for debugging
%   Should return early if gcode file is invalid
%
% gcode uses millimeters as units.
% All positioning is absolute, not relative.

function compile(filename)

    map = VXM_MOTOR_MAP;
    xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
    xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;
    gcodeLineStrArr = [];
    printerAction   = "";
    cellarray = {"Port", "Command", "G-Code"};

    % Read file line by line as a string array
    fileData = readlines(filename);
    disp("Reading file: " + filename);

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

    % For each line of gcode starting at line 2, call the corresponding command
    for i = 2:size(fileData)

        resCellArr = {};
        curLine = fileData(i);
        disp(compose("Line [%d]: ", i) + curLine);

        % Axis Move to (x,y)
        if startsWith(curLine, 'G01 X')
            gcodeLineStrArr = split(curLine);
            xCur = getNumsFromStr(gcodeLineStrArr(2));
            yCur = getNumsFromStr(gcodeLineStrArr(3));

            printerAction = moveAxis(xPrev, yPrev, xCur, yCur);
            resCellArr = {map.port_a, printerAction, curLine};

        % Layer Change to (z)
        elseif startsWith(curLine, 'G01 Z')
            gcodeLineStrArr = split(curLine);
            zCur = getNumsFromStr(gcodeLineStrArr(2));

            % First, Move Print and Supply Bed
            printerAction = moveBed(zCur);
            resCellArr(1,:) = {map.port_b, printerAction, curLine};

            % Next, Sweep the Roller
            printerAction = sweepRoller();
            resCellArr(2,:) = {map.port_a, printerAction(1), curLine};
            resCellArr(3,:) = {map.port_a, printerAction(2), curLine};

        % Reset to absolute zero position
        elseif (contains(curLine, 'M200'))
            xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
            xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;

            % Zero the Axis motors
            printerAction = homeAxisRoller();
            resCellArr(1,:) = {map.port_a, printerAction(1), curLine};
            resCellArr(2,:) = {map.port_a, printerAction(2), curLine};
            resCellArr(3,:) = {map.port_a, printerAction(3), curLine};
            resCellArr(4,:) = {map.port_a, printerAction(4), curLine};
            
            % Zero the Beds
            printerAction = homeBeds();
            resCellArr(5,:) = {map.port_b, printerAction(1), curLine};
            resCellArr

        % Turn the laser on
        elseif startsWith(curLine, 'M201')
            printerAction = setLaserOn();
            resCellArr = {LASER_PORT, printerAction, curLine};

        % Turn the laser off
        elseif startsWith(curLine, 'M202')
            printerAction = setLaserOff();
            resCellArr = {LASER_PORT, printerAction, curLine};
        
        % Empty line, ignore
        elseif startsWith(curLine, "")
            continue;

        % Encountered unexpected text, pause and wait for user
        else
            disp("ERROR: Encountered unexpected text.");
            disp("PAUSED. Press any key to unpause");
            pause;

        end

        % Vertically concat cellarray with resCellArr
        cellarray = vertcat(cellarray, resCellArr);

        xPrev = xCur; yPrev = yCur; zPrev = zCur;
        
    end

    % Write cellarray to printerActions.txt
    writecell(cellarray, "printerActions.txt", "Delimiter", "bar");

    disp("Finished parsing gcode file.");
    
end
