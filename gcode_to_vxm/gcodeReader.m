% Reads in a .gcode file line by line and calls one of the following functions:
% G1   = vxmMove()
% M200 = vxmLayer()
% M201 = laserOn()
% M202 = laserOff()

% Output Files:
% vxm motors    "vxmCMDs.txt"
% powder bed    "bedCMDs.txt"
% laser         "lzrCMDs.txt"

function gcodeReader(filename)

    % Read file line by line as a string array
    fileData = readlines(filename);

    curLine = fileData(1);
    disp("Read Line [1]: " + curLine);
    
    % Check if file is valid
    if (contains(curLine, 'Width: '))
        L1 = split(curLine);
        w = L1(2);
        h = L1(4);
    else
        disp("ERROR: gcode file does not properly define width/height.");
        disp("Line 1 must start with: 'Width: {x} Height: {y}'");
        return;
    end

    xCur  = 0.0; yCur  = 0.0; zCur = 0.0;
    xPrev = 0.0; yPrev = 0.0;
    curLineStrArr = [];
    vxmCMDArr = []; lzrCMDArr = []; bedCMDArr = [];

    % For each line starting at line 2, call the corresponding command
    for i = 2:size(fileData)
        vxmCMDResult = compose("\r\n");
        bedCMDResult = compose("\r\n");
        lzrCMDResult = compose("LASER_OFF\n");

        curLine = fileData(i);
        disp(compose("Line [%d]: ",i) + curLine);

        % Move to (x,y)
        if startsWith(curLine, 'G01')
            curLineStrArr = split(curLine);
            xCur = getNumsFromStr(curLineStrArr(2));
            yCur = getNumsFromStr(curLineStrArr(3));

            vxmCMDResult = vxmMove(xPrev, yPrev, xCur, yCur);

        % Increment elevation by z
        % Reset position to (0,0)
        elseif startsWith(curLine, 'M200')
            curLineStrArr = split(curLine);
            zCur = zCur + getNumsFromStr(curLineStrArr(2));

            xCur = 0.0; yCur = 0.0;
            xPrev = 0.0; yPrev = 0.0;

            bedCMDResult = vxmLayer(zCur);
            vxmCMDResult = compose("\r\n\r\n\r\n\r\n");
            lzrCMDResult = compose("\r\n\r\n\r\n\r\n");

        % Turn the laser on
        elseif startsWith(curLine, 'M201')
            lzrCMDResult = laserOn();

        % Turn the laser off
        elseif startsWith(curLine, 'M202')
            lzrCMDResult = laserOff();
        
        % Empty line, ignore
        elseif startsWith(curLine, "")
            continue;

        % Encountered unexpected text, pause and wait for user
        else
            disp("ERROR: Encountered unexpected text. PAUSED.");
            disp("Press any key to unpause");
            pause;

        end

        if vxmCMDResult == compose("\r\n\r\n\r\n\r\n")
            disp(compose("BED CMD: " + bedCMDResult));
        else
            disp(compose("VXM CMD: " + vxmCMDResult));
        end

        % Add the current command(s) to the end of array
        vxmCMDArr = [vxmCMDArr; vxmCMDResult];
        bedCMDArr = [bedCMDArr; bedCMDResult];
        lzrCMDArr = [lzrCMDArr; lzrCMDResult];

        % Update previous (x,y) for vxmMove()
        xPrev = xCur; yPrev = yCur;
    end

    disp("Finished Reading gcode file");
    
    % Write commands from array to txt files
    vxmCMDFile = fopen("vxmCMDs.txt", "w");
    vxmCMDArr = compose(vxmCMDArr);
    fprintf(vxmCMDFile, "%s", vxmCMDArr);

    bedCMDFile = fopen("bedCMDs.txt", "w");
    bedCMDArr = compose(bedCMDArr);
    fprintf(bedCMDFile, "%s", bedCMDArr);

    lzrCMDFile = fopen("lzrCMDs.txt", "w");
    lzrCMDArr = compose(lzrCMDArr);
    fprintf(lzrCMDFile, "%s", lzrCMDArr);

end
