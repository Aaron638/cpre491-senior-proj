function response = executeLaser(pa, tcpDevice)
    if pa.device ~= 'Laser'
        error("ERROR: Trying to execute a command meant for %s device", pa.device);
    end

    % TODO: Check that they aren't already uint8
    strArr = pa.actions;
    byteArr = uint8(hex2dec(strArr));

    write(tcpDevice, byteArr, "uint8");
    response = compose("%02X", read(tcpDevice));
    
end