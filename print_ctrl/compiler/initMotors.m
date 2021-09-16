% TESTING REQUIRED
% Initializes the serial port connections to the vxm motors.
% Checks if the serial port is a VXM motor, and if it's in the mtr/slv
% or solo configuration.
% 
% Returns a motormap
% Array of objects with a motor index number, and a port number.

function motormap = initMotors()
    port_a = "";
    port_b = "";

    % Motor Indexing Map:
    % MANUALLY CHANGE IF NECESSARY
    m1.index = 4; % Spotsize
    m2.index = 1; % Roller
    m3.index = 2; % X-axis movement (left/right)
    m4.index = 3; % Y-axis movement (forward/back)
    m5.index = 1; % Supply Bed
    m6.index = 2; % Powder Bed

    disp(serialportlist);

    for portname = serialportlist
        disp("Testing port: " + portname);
        try
            device = serialport(portname, 9600);
        catch err
            disp(err.message);
            continue;
        end
        
        % If the device is a vxm motor controller, this command should
        % get the position of motor 1 and 2.
        message = compose("F, X, Y, R\r");
        try
            write(device, message, "uint8");
            response = readline(device);
            disp(response);
        catch err
            disp(err.message);
        end
        
        if (device.NumBytesAvailable == 0)
            disp(portname + " is probably not a vxm motor controller");
            flush(device);
            delete(device);
            continue;
        else if (port_a == "")
            port_a = portname;
        else
            port_b = portname;
        end

        disp(portname + " is a vxm motor controller.")
        flush(device);
        delete(device);
    end
    disp("Finished scanning ports.");

    if (port_a == "" | port_b == "")
        disp("One or both vxm motor controller ports were not found.");
        return;
    end

    % Try to get the position of motor 3 and 4
    message = compose("F, Z, W, R\r");
    try
        device = serialport(port_a, 9600);
        write(device, message, "uint8");
        response = readline(device);
        disp(response);
    catch err
        disp(err.message);
    end
    
    % If port_a does not return the position of motor 3 and 4, then
    % port_b is in the mtr/slv configuration.
    if (device.NumBytesAvailable == 0)
        disp(port_a + " is in the solo configuration.");
        disp(port_b + " is in the mtr/slv configuration.");
        m1.port = port_b;
        m2.port = port_b;
        m3.port = port_b;
        m4.port = port_b;
        m5.port = port_a;
        m6.port = port_a;
    else
        disp(port_b + " is in the solo configuration.");
        disp(port_a + " is in the mtr/slv configuration.");
        m1.port = port_a;
        m2.port = port_a;
        m3.port = port_a;
        m4.port = port_a;
        m5.port = port_b;
        m6.port = port_b;
    end
    
    motormap = [m1, m2, m3, m4, m5, m6];
end