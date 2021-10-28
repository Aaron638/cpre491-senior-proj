% UNTESTED
% 
function response = freeLaserTCP(ip, port, cmdArray)
    t = tcpclient(ip, port);
    %command = [0x1b, 0x01, 0x01, 0x0d, 0x2a];
    %command = setLaserOff();
    command = cmdArray;
    
    write(t, command, "uint8");
    resp = read(t);
    while isempty(resp)
        resp = read(t);
    end
    response = compose("%02X", resp);
    
    clear t;
    
end