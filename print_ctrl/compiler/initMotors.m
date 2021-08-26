% TODO: CURRENTLY DOES NOT WORK.
% Initializes the serial port connections to the vxm motors.
% Checks if the serial port is a VXM motor, and if it's in the mtr/slv
% or solo configuration.

% I could not find a more "proper" way to check if a port is valid, so
% instead we use readline() to wait for a response. If we don't
% get a response, then we assume the port is not valid.

function motormap = initMotors()
    port_a = "";
    port_b = "";

    % Motor Map:
    m1.name = "spot"; % Spotsize
    m2.name = "roll"; % Roller
    m3.name = "xmov"; % X-axis movement (left/right)
    m4.name = "ymov"; % Y-axis movement (forward/back)
    m5.name = "sbed"; % Supply Bed
    m6.name = "pbed"; % Powder Bed

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