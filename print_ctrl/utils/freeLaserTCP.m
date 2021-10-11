% UNTESTED
% 
function freeLaserTCP(ip, port)
    t = tcpclient(ip, port);
    %command = [0x1b, 0x01, 0x01, 0x0d, 0x2a];
    command = setLaserOff();
    
    write(t, command, "uint8");
    %while true
    resp = read(t);
    while isempty(resp)
        resp = read(t);
    end
    disp(compose("%02x", resp));
    
    clear t;
    
end