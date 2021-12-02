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
% Output is a .toml file
%
function compile(inputfile, outputfile)

    CFG = CONFIG();
    xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
    xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;
    objWidth = 0.0000; objLength = 0.0000;
    gcodeLineStrArr = [];
    actionNum = 0;

    if ~endsWith(outputfile, '.toml')
        warning("WARN: File: {%s} does not end with '.toml'", outputfile);
    end

    % Read inputfile line by line as a string array
    fileData = readlines(inputfile);
    disp("Reading file: " + inputfile);

    % Check if file has width and height
    curLine = fileData(1);
    disp("Line [1]: " + curLine);
    if (contains(curLine, 'Width: ') && contains(curLine, 'Length: '))
        gcodeLineStrArr = split(curLine);
        objWidth  = str2num(gcodeLineStrArr(2));
        objLength = str2num(gcodeLineStrArr(4));
    else
        error("ERROR: gcode file {%s} does not properly define width/length.\nLine 1 must start with: 'Width: {x} Length: {y}'", inputfile);
    end

    fileID = fopen(outputfile, 'w');
    % Right now gcode does not specify height, or number of defects.
    numDefects = 0;
    writeHeader(fileID, inputfile, objWidth, objLength, numDefects);

    % For each line of gcode starting at line 2, call the corresponding command
    for i = 2:length(fileData)
        curLine = fileData(i);
        disp(compose("Line [%d]: %s", i, curLine));

        device = ""; port = "";
        cmds = strings(1, 10);

        % Comment line, skip
        if startsWith(curLine, ';')
            continue;
        
        % Axis Move to {x,y}
        elseif startsWith(curLine, 'G01 X')
            gcodeLineStrArr = split(curLine);
            xCur = getNumsFromStr(gcodeLineStrArr(2));
            yCur = getNumsFromStr(gcodeLineStrArr(3));

            if xCur > objWidth || xCur < 0 || yCur > objLength || yCur < 0
                warning("WARN: Potential out-of-bounds movement on line %d.", i);                
                disp("Paused. Press any button to continue, or Ctrl+C to stop.");
                pause();
            end

            device = "Motor";
            % Move Axis motors
            port = CFG.PORT_TWIN;
            cmds = moveAxis(xPrev, yPrev, xCur, yCur);

        % Layer Change to {z} (2 commands)
        elseif startsWith(curLine, 'G01 Z')
            gcodeLineStrArr = split(curLine);
            zCur = getNumsFromStr(gcodeLineStrArr(2));

            device = "Motor";
            % Move Beds
            port = CFG.PORT_SOLO;
            cmds = moveBeds(zCur);
            actionNum = actionNum + 1;
            writeAction(fileID, actionNum, device, port, cmds, curLine);

            % Sweep Roller
            port = CFG.PORT_TWIN;
            cmds = sweepRoller();

        % Reset to absolute zero position (2 commands)
        elseif (contains(curLine, 'M200'))
            xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
            xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;
            device = "Motor";

            % Zero the Axis motors
            port = CFG.PORT_TWIN;
            cmds = homeAxisRoller();
            actionNum = actionNum + 1;
            writeAction(fileID, actionNum, device, port, cmds, curLine);

            % Zero the Beds
            port = CFG.PORT_SOLO;
            cmds = homeBeds();

        % Turn the laser on
        elseif startsWith(curLine, 'M201')
            device = "Laser";
            port = CFG.PORT_LASER;
            cmds = setLaserOn();

        % Turn the laser off
        elseif startsWith(curLine, 'M202')
            device = "Laser";
            port = CFG.PORT_LASER;
            cmds = setLaserOff();

        % Turn Function generator on
        elseif startsWith(curLine, 'M301')
            device = "FuncGen";
            port = CFG.RSRC_FG;
            cmds = "on";

        % Turn Function generator off
        elseif startsWith(curLine, 'M302')
            device = "FuncGen";
            port = CFG.RSRC_FG;
            cmds = "off";
        
        % Empty line, skip
        elseif (curLine == "")
            continue;
        
        % Encountered unexpected text, pause and wait for user
        else
            warning("WARN: Encountered unexpected text on line %d.", i);
            disp("Paused. Press any button to continue, or Ctrl+C to stop.");
            pause();
        end

        % Write printerAction to .toml file
        actionNum = actionNum + 1;
        writeAction(fileID, actionNum, device, port, cmds, curLine);
        
        xPrev = xCur; yPrev = yCur; zPrev = zCur;    
    end

    fclose(fileID);
    disp("Finished parsing gcode file.");
