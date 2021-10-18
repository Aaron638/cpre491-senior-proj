% Executes the instructions in printerActions.txt by sending commands to the motor controllers and the laser.
% 
function sendCMDs()

    VXM = VXM_MOTOR_MAP;

    twinVXM = serialport(VXM.PORT_M1234, 9600);
    soloVXM = serialport(VXM.PORT_M56, 9600);
    %laser   = serialport(LASER_PORT, 9600); DEPRECATED. Make function for
    %TCP
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
%                 write(soloVXM, setLaserOn(), "uint8");
                response = freeLaserTCP("169.254.198.108", LASER_PORT, setLaserOn());
            elseif strcmp(command, "LASER_OFF")
%                 write(soloVXM, setLaserOff(), "uint8");
                response = freeLaserTCP("169.254.198.108", LASER_PORT, setLaserOff());
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
