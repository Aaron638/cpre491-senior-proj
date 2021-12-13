function executeMotor(pa, serialDevice)
    if pa.device ~= 'Motor'
        error("ERROR: Trying to execute a command meant for %s device", pa.device);
    end

    for i = 1:length(pa.actions)
        response = "";
        % Append carriage return "\r" if missing
        if ~endsWith(pa.actions(i), char(15))
            pa.actions(i) = sprintf("%s\r", pa.actions(i));
        end
        write(serialDevice, pa.actions(i), "uint8");
        while response ~= '^'
            response = read(serialDevice, 1, "uint8");
        end
        flush(serialDevice);
    end
end