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
function r = compile(inputfile, outputfile)

    CFG = CONFIG();
    xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
    xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;
    bedWidth = 0.0000; bedLength = 0.0000;
    gcodeLineStrArr = [];

    % Read inputfile line by line as a string array
    fileData = readlines(inputfile);
    disp("Reading file: " + inputfile);

    % Check if file has width and height
    curLine = fileData(1);
    disp("Line [1]: " + curLine);
    if (contains(curLine, 'Width: ') && contains(curLine, 'Length: '))
        gcodeLineStrArr = split(curLine);
        bedWidth  = gcodeLineStrArr(2);
        bedLength = gcodeLineStrArr(4);
    else
        error("ERROR: gcode file does not properly define width/length.\nLine 1 must start with: 'Width: {x} Length: {y}'");
    end

    % Preallocate space for printer action array
    N = length(fileData) * 6;
    parray(1:N) = struct("ports", [], "actions", [], "gcode", "");

    % Headers;
    parray(1).ports = "Port";
    parray(1).actions = "Action";
    parray(1).gcode = "G-Code";

    % Open outputfile for writing
    % fileID = fopen(outputfile, "w");

    % For each line of gcode starting at line 2, call the corresponding command
    for i = 2:size(fileData)
        
        curLine = fileData(i);
        disp(compose("Line [%d]: %s", i, curLine));

        % Axis Move to (x,y)
        if startsWith(curLine, 'G01 X')
            gcodeLineStrArr = split(curLine);
            xCur = getNumsFromStr(gcodeLineStrArr(2));
            yCur = getNumsFromStr(gcodeLineStrArr(3));

            % Move axis motors relative to prev position
            % parray(i).n = 1;
            parray(i).ports = [CFG.PORT_TWIN];
            parray(i).actions = moveAxis(xPrev, yPrev, xCur, yCur);

        % Layer Change to (z)
        elseif startsWith(curLine, 'G01 Z')
            gcodeLineStrArr = split(curLine);
            zCur = getNumsFromStr(gcodeLineStrArr(2));

            % Move pbed and sbed, then sweep roller
            % parray(i).n = 3;
            parray(i).ports = [CFG.PORT_SOLO, CFG.PORT_TWIN, CFG.PORT_TWIN];
            parray(i).actions = [moveBeds(zCur), sweepRoller()];

        % Reset to absolute zero position
        elseif (contains(curLine, 'M200'))
            xCur  = 0.0000; yCur  = 0.0000; zCur  = 0.0000;
            xPrev = 0.0000; yPrev = 0.0000; zPrev = 0.0000;

            % Zero the Axis motors           
            % Zero the Beds
            % parray(i).n = 5;
            parray(i).ports = [CFG.PORT_TWIN, CFG.PORT_TWIN, CFG.PORT_TWIN, CFG.PORT_TWIN, CFG.PORT_SOLO];
            parray(i).actions = [homeAxisRoller(), homeBeds()];

        % Turn the laser on
        elseif startsWith(curLine, 'M201')
            % parray(i).n = 6;
            % parray(i).actions = setLaserOn();
            % for j = 1:6
                % parray(i).ports(j) = CFG.PORT_LASER;
            % end
            continue;

        % Turn the laser off
        elseif startsWith(curLine, 'M202')
            % parray(i).n = 6;
            % parray(i).actions = setLaserOff();
            % for j = 1:6
                % parray(i).ports(j) = CFG.PORT_LASER;
            % end
            continue;
        
        % Empty line, skip
        elseif (curLine == "")
            continue;
            
        % Comment line, skip
        elseif startsWith(curLine, ';')
            continue;

        % Encountered unexpected text, pause and wait for user
        else
            disp("ERROR: Encountered unexpected text.");
            disp("PAUSED. Press any key to unpause");
            pause;
        end

        % Make sure ports and actions arrays have the same length
        if (length(parray(i).ports) ~= length(parray(i).actions))
            disp(parray(i).ports);
            disp(parray(i).actions);
            error("ERROR: Mismatching port and action array sizes");
        end

        parray(i).ports = convertStringsToChars(parray(i).ports);
        parray(i).actions = convertStringsToChars(parray(i).actions);
        parray(i).gcode = convertStringsToChars(curLine);
        
        xPrev = xCur; yPrev = yCur; zPrev = zCur;    
    end

    r = parray;

    
    % Write parray to outputfile
    toml.write("test.toml", parray);

    % fclose(fileID);
    disp("Finished parsing gcode file.");
    

