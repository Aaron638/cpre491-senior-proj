% Testing function which opens a com port, then moves the given motor a given distance in steps.

function vxmCMD = laserMove(port)
    device = serialport(port, 2400);
    flush(device);
    %string = compose(command_no);
    %write(device, command_no, "uint8");
    
    write(device, 0x1B, "uint8");
    write(device, 0x01, "uint8");
    write(device, 0x02, "uint8");
    write(device, 0x0D, "uint8");
    write(device, 0x2B, "uint8");
    
    response = "";
    temp = 0;
    while response ~= '0D';
        %temp = readline(device);
        %response = compose("%s%c\n", response, temp);
        %disp(sprintf("%x", temp));
        
        response = read(device, 1, "uint8");
        disp(sprintf("%x ", response));
        
    end
    
    flush(device);
    delete(device);
    
end