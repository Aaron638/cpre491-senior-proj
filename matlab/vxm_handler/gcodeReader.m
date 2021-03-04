% Reads in a .gcode file and calls one of the following functions:
% G1   = vxmMove()
% M200 = vxmLayer()
% M201 = laserOn()
% M202 = laserOff()

% CHANGING CONVENTION:
% Add spaces btwn Width and Height in line 1 of our gcode files
%   "Width: 30 Height: 30"

function gcodeReader(filename)

    % read file line by line as a string array
    fileData = readlines(filename);

    % Update GUI with Line 1's width and height
    curLine = fileData(1);
    disp(compose("\tLine [%d]: ",1) + curLine);
    
    if (contains(curLine, 'Width'))
        L1 = split(curLine);
        w = L1(2);
        h = L1(4);
        disp("Update GUI: Width: " + w);
        disp("Update GUI: Height: " + h);
    else
        disp("ERROR: gcode file does not define width/height.");
        disp("Line 1 must start with 'Width: {x} Height: {y}'");
        return;
    end

    % For each line starting at line 2, call the corresponding command
    xCur  = 0.0; yCur  = 0.0; zCur = 0;
    xPrev = 0.0; yPrev = 0.0;
    curLineStrArr = [];

    for i = 2:size(fileData)
        curLine = fileData(i);
        disp(compose("\tLine [%d]: ",i) + curLine);

        % Move to (x,y)
        if startsWith(curLine, 'G1')
            curLineStrArr = split(curLine);
            xCur = getNumsFromStr(curLineStrArr(2));
            yCur = getNumsFromStr(curLineStrArr(3));

            vxmCMD = vxmMove(xPrev, yPrev, xCur, yCur);
            disp("Sending through COM port:");
            disp(vxmCMD);

        % Increase elevation by z
        % I think it should also reset position to (0,0)?
        elseif startsWith(curLine, 'M200')
            curLineStrArr = split(curLine);
            zCur = getNumsFromStr(curLineStrArr(2));

            vxmCMD = vxmLayer(zCur);
            disp("Sending through COM port:");
            disp(vxmCMD);

            xCur = 0.0; yCur = 0.0;
            xPrev = 0.0; yPrev = 0.0;

        % Turn the laser on
        elseif startsWith(curLine, 'M201')
            laserOn();

        % Turn the laser off
        elseif startsWith(curLine, 'M202')
            laserOff();
        
        % Empty line, ignore
        elseif startsWith(curLine, "")
            continue;

        % Encountered unexpected text, pause and wait for user
        else
            laserOff();
            disp("WARNING: Encountered unexpected text at line: " + i);
            disp(curLine);
            disp("Update GUI: PAUSED");
        end

        % Update previous (x,y) for vxmMove()
        xPrev = xCur; yPrev = yCur;
    end

    disp("Finished Reading gcode file");

end
