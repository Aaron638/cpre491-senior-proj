% This function reads laserCMDs.txt, bedCMDs.txt, and vxmCMDs.txt line by line
% It then sends their results through the com ports

function writeCOMPorts(ThreeAxisRollerCOM, PowderBedsCOM, SensorSystemCOM)

    disp("Reading textfiles:");

    % Read file line by line as a string array
    vxmFileData = readlines("vxmCMDs.txt");
    bedFileData = readlines("bedCMDs.txt");
    % lzrFileData = readlines("lzrCMDs.txt");

    for i = 1:size(vxmFileData)

        % Write port if not (\n)
        if vxmFileData(i, 1) ~= char(10)
            curLine = vxmFileData(i);
            device = ThreeAxisRollerCOM;

        elseif bedFileData(i, 1) ~= char(10)
            curLine = bedFileData(i);
            device = PowderBedsCOM;
            
        % elseif lzrFileData(i, 1) ~= char(10)
        %     curLine = lzrFileData(i);
        %     device = SensorSystemCOM;

        % All files have a \n, go to next line
        else 
            continue;
        end
        
        % disp(compose("Line [%d]: ",i) + curLine);
        disp("Sending through COM port ");
        isComplete = false;
        while isComplete == false
            ready = readline(device);
            if ready == "^"
                isComplete = true;
            end
            % Loop will continue as long as action isn't complete
        end

        disp(curLine);
        writeline(device, curLine);

    end

end