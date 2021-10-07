% Executes the instructions in printerActions.txt by sending commands to the motor controllers and the laser.
% 
function sendCMDs()

    VXM = VXM_MOTOR_VXM;

    twinVXM = serialport(VXM.port_a, 9600);
    soloVXM = serialport(VXM.port_b, 9600);
    laser   = serialport(LASER_PORT, 9600);
    prntAxnStrArr;
    string = "";

    % Read file line by line as a string array
    fileData = readlines("printerActions.txt");
    disp("Reading printerActions.txt");

    for i = 2:size(fileData)

        curLine = fileData(i);
        disp(compose("Line [%d]: ", i) + curLine);
        prntAxnStrArr = split(curLine, '|');
        disp("Sending: %s\n", prntAxnStrArr(2));

        % TODO: Rename port_a and port_b to be ALL_CAPS to indicate that it's a global constant
        % port_a indicates that the cmd is for the axis and roller motors
        if startsWith(curline, VXM.port_a)
            string = compose("%s\r", prntAxnStrArr(2));
            write(twinVXM, string, "uint8");
            response = "";
            while response ~= '^'
                response = read(twinVXM, 1, "uint8");
            end
            flush(twinVXM);
            
        % port_b indicates that the cmd is for the beds
        elseif startsWith(curline, VXM.port_b)

            string = compose("%s\r", prntAxnStrArr(2));
            write(soloVXM, string, "uint8");
            response = "";
            while response ~= '^'
                response = read(soloVXM, 1, "uint8");
            end
            flush(soloVXM);
            
        elseif startsWith(curline, LASER_PORT)

            write(soloVXM, getLaserStatus(), "uint8");
            response = "";
            while response ~= uint8(0x0D)
                response = read(soloVXM, 1, "uint8");
            end
            flush(soloVXM);

        else
            disp("Error");
            return;
             
        end

        disp("Response: %s\n", response);

    end

    flush(twinVXM); flush(soloVXM); flush(laser);
    delete(twinVXM); delete(soloVXM); delete(laser);

    disp("Finished Reading File.");
end
