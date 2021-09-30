function freeLaserSerial(port, baud, command)
    device = serialport(port, baud);
    flush(device);

    write(device, command, "uint8");
    
    resp = readLaser(device);
    disp(resp);

    % Display it again in hex
    % for r in resp
    %     formatted = compose("%X ", r);
    %     disp(formatted);
    % end
    
    % flush(device);
    % delete(device);
end