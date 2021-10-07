% UNTESTED
% 
function freeLaserSerial(port, baud, command)
    device = serialport(port, baud);
    flush(device);

    write(device, command, "uint8");
    while true
        read(device, 1, "uint8");
        disp("%0X ", resp);

        if resp == uint8(0x0D)
            read(device, 1, "uint8");
            disp("%0X ", resp);
            break;
        end
    end
    
end