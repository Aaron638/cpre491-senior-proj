% Testing function which opens a com port, then moves the given motor a given distance in steps.

function vxmCMD = freeMove(port, motornum, dist_in_steps)
    device = serialport(port, 9600);
    flush(device);
    string = compose("F, C, I%dM%d, R,\r", motornum, dist_in_steps);
    write(device, string, "uint8");
    response = "";
    while response ~= '^'
        read(device, 1, "uint8");
    end
    flush(device);
    delete(device);
    
end