function freeLaserTCP(ip, port, command)
    t = tcpclient(ip, port);

    write(t, command, "uint8");
    while true
        read(t, 1, "uint8");
        disp("%0X ", resp);

        if resp == uint8(0x0D)
            read(t, 1, "uint8");
            disp("%0X ", resp);
            break;
        end
    end

    delete(t);
    
end