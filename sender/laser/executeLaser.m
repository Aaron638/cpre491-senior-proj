% Sends a TCP packet with the byte array to the Laser.
% UNFINISHED: May want to check that they aren't already uint8
% 
function executeLaser(pa, tcpDevice)
    if pa.device ~= "Laser"
        error("ERROR: Trying to execute a command meant for %s device", pa.device);
    end

    strArr = pa.actions;
    %byteArr = uint8(hex2dec(strArr));

    write(tcpDevice, strArr, "uint8");
    % response = compose("%02X", read(tcpDevice));
    
end