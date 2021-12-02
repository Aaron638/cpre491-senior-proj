function executeMotor(pa, serialDevice)
    if pa.device ~= 'Motor'
        error("ERROR: Trying to execute a command meant for %s device", pa.device);
    end

    for cmd = pa.actions
        response = '';
        % Append carriage return "\r" if missing
        if ~endsWith(cmd, char(15))
            sprintf("%s\r", cmd);
        end
        write(serialDevice, cmd, "uint8");
        while response ~= char('^')
            response = read(serialDevice, 1, "uint8");
        end
        flush(serialDevice);
    end
end