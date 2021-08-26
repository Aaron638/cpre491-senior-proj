% TODO: CURRENTLY DOES NOT WORK.
% Initializes the serial port connections to the vxm motors.
% Checks if the serial port is a VXM motor, and if it's in the mtr/slv
% or solo configuration.

% I could not find a more "proper" way to check if a port is valid, so
% instead we use readline() to wait for a response. If we don't
% get a response, then we assume the port is not valid.

function initSerial()

    % TODO: Replace motorMap with a struct.
    % motorMap = [1, "spot", "COM";
    %             2, "roll", "COM";
    %             3, "x"   , "COM";
    %             4, "y"   , "COM";
    %             5, "sbed", "COM";
    %             6, "pbed", "COM"];

    disp(serialportlist);

    for portname = serialportlist
        disp("Testing device: " + portname);
        try
            device = serialport(portname, 9600);
        catch err
            disp(err.message);
            continue;
        end
        
        % If the device is a vxm motor controller, this command should
        % relay the position of motor 1 and 2.
        message = compose("F, X, Y, R\r");
        disp(message);
        response = "";
        try
            write(device, message, "uint8");
            response = readline(device);
        catch err
            disp(err.message);
        end
        
        if (response == "")
            disp(portname + "is probably not a vxm motor controller");
            continue;
        end
        
        % If we get a response, then we have to test the motor's
        % configuration: mtr/slv or solo
        disp(response);
        message = compose("F, Z, W, R\r");
        try
            write(device, message, "uint8");
            response = string(readline(device));
        catch err
            disp(err.message);
        end
        
        if (response == "")
            disp(portname + " is in the solo configuration.");
            continue;
        else
            disp(portname + " is in the mtr/slv configuration.");
        end
        
    end
    disp("End of loop");
    
end