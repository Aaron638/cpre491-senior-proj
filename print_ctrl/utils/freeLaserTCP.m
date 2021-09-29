function freeLaserTCP(ip, port, command)
   
    t = tcpclient(ip, port);
    write(t, command, "uint8");

    resp = readLaser(device);
    disp(resp);

    disp("Num bytes available:" + t.numBytesAvailable);

    % Display it again in hex
    for r in resp
        formatted = compose("%X ", r);
        disp(formatted);
    end

    %TODO Verify CRC by adding bytes 1-6

    delete(device);
end