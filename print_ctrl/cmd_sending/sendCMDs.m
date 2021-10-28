% Executes the instructions in printerActions.txt by sending commands to the motor controllers and the laser.
% 
function sendCMDs()

    VXM = VXM_MOTOR_MAP;
    LASER_IP = "169.254.198.107";

    twinVXM = serialport(VXM.PORT_M1234, 9600);
    soloVXM = serialport(VXM.PORT_M56, 9600);
    laser   = tcpclient(LASER_IP, LASER_PORT);
    
    prntAxnStrArr = [];
    command = "";

    % Read file line by line as a string array
    fileData = readlines("printerActions.txt");
    disp("Reading printerActions.txt");

    for i = 2:size(fileData)

        curLine = fileData(i);
        disp(compose("Line [%d]: ", i) + curLine);
        prntAxnStrArr = split(curLine, '|');
        disp(compose("Sending: %s\n", prntAxnStrArr(2)));
        response = "";

        % Axis and Roller
        if startsWith(curLine, VXM.PORT_M1234)
            command = compose("%s\r", prntAxnStrArr(2));
            write(twinVXM, command, "uint8");
            while response ~= '^'
                response = read(twinVXM, 1, "uint8");
            end
            flush(twinVXM);
            
        % Print Beds
        elseif startsWith(curLine, VXM.PORT_M56)

            command = compose("%s\r", prntAxnStrArr(2));
            write(soloVXM, command, "uint8");
            while response ~= '^'
                response = read(soloVXM, 1, "uint8");
            end
            flush(soloVXM);
            
        % Laser
        elseif startsWith(curLine, string(LASER_PORT))

            command = prntAxnStrArr(2);
            if strcmp(command, "LASER_ON")
                write(laser, setLaserOn(), "uint8");
                response = compose("%02X", read(laser));
            elseif strcmp(command, "LASER_OFF")
                write(laser, setLaserOff(), "uint8");
                response = compose("%02X", read(laser));
            else
                error('Invalid Laser Command', command);
            end
            
            response = strjoin(response, ', ');

        else
            disp("Empty Line");
            continue;
        end

        disp(compose("Response: %s\n", response));

    end

    flush(twinVXM); flush(soloVXM); %flush(laser);
    delete(twinVXM); delete(soloVXM); %delete(laser);

    disp("Finished Reading File.");
end
