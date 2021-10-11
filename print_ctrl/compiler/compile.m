% Function that takes in the location to a .gcode file, and an output text file location.
% Maps each line of g-code to a command for the motor controllers or the laser.
% 
% Usage: 
%   compile("./test_files/small.gcode", "./test_files/printerActions.txt");
% 
% Possible g-code commands:
%   G01 X{x} Y{y} => Move 3-axis motors to x,y
%   G01 Z{z}      => Increment Print Bed and Decrement Supply Bed by z, then sweep the roller
%   M200          => Reset all motors to defined zero
%   M201          => Laser On
%   M202          => Laser Off
%
% The commands are first stored into a cell array object 'cellarray'.
% We use a cell array because some g-code instructions map into multiple commands for different ports.
% The function should return early if gcode file is invalid.
% After the function is finished parsing the gcode, the results are written to an output file.
%
% Output is a txt file with 3 columns separated by a bar "|":
%   First column indiciates the port to send the command to.
%   Second column indicates actual command to be sent.
%   Third column prints out the line of gcode for debugging.
%
function compile(inputfile, outputfile)

    VXM = VXM_MOTOR_MAP;
    xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
    xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;
    gcodeLineStrArr = [];
    printerAction   = "";
    cellarray = {"Port", "Command", "G-Code"};

    % Read file line by line as a string array
    fileData = readlines(inputfile);
    disp("Reading file: " + inputfile);

    % Check if file has width and height
    curLine = fileData(1);
    disp("Line [1]: " + curLine);
    if (contains(curLine, 'Width: ') && contains(curLine, 'Length: '))
        gcodeLineStrArr = split(curLine);
        objWidth  = gcodeLineStrArr(2);
        objLength = gcodeLineStrArr(4);
    else
        error("ERROR: gcode file does not properly define width/length.\nLine 1 must start with: 'Width: {x} Length: {y}'");
        return;
    end

    % For each line of gcode starting at line 2, call the corresponding command
    for i = 2:size(fileData)

        resCellArr = {};
        curLine = fileData(i);
        disp("Line [%d]: %s", i, curLine);

        % Axis Move to (x,y)
        if startsWith(curLine, 'G01 X')
            gcodeLineStrArr = split(curLine);
            xCur = getNumsFromStr(gcodeLineStrArr(2));
            yCur = getNumsFromStr(gcodeLineStrArr(3));

            printerAction = moveAxis(xPrev, yPrev, xCur, yCur);
            resCellArr = {VXM.PORT_M1234, printerAction, curLine};

        % Layer Change to (z)
        elseif startsWith(curLine, 'G01 Z')
            gcodeLineStrArr = split(curLine);
            zCur = getNumsFromStr(gcodeLineStrArr(2));

            % First, Move Print and Supply Bed
            printerAction = moveBeds(zCur);
            resCellArr(1,:) = {VXM.PORT_M56, printerAction, curLine};

            % Next, Sweep the Roller
            printerAction = sweepRoller();
            resCellArr(2,:) = {VXM.PORT_M1234, printerAction(1), curLine};
            resCellArr(3,:) = {VXM.PORT_M1234, printerAction(2), curLine};

        % Reset to absolute zero position
        elseif (contains(curLine, 'M200'))
            xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
            xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;

            % Zero the Axis motors
            printerAction = homeAxisRoller();
            resCellArr(1,:) = {VXM.PORT_M1234, printerAction(1), curLine};
            resCellArr(2,:) = {VXM.PORT_M1234, printerAction(2), curLine};
            resCellArr(3,:) = {VXM.PORT_M1234, printerAction(3), curLine};
            resCellArr(4,:) = {VXM.PORT_M1234, printerAction(4), curLine};
            
            % Zero the Beds
            printerAction = homeBeds();
            resCellArr(5,:) = {VXM.PORT_M56, printerAction(1), curLine};
            resCellArr

        % Turn the laser on
        elseif startsWith(curLine, 'M201')
            printerAction = "LASER_ON";
            resCellArr = {LASER_PORT, printerAction, curLine};

        % Turn the laser off
        elseif startsWith(curLine, 'M202')
            printerAction = "LASER_OFF";
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

    % Write cellarray to outputfile printerActions.txt
    writecell(cellarray, outputfile, "Delimiter", "bar");

    disp("Finished parsing gcode file.");
    
end
