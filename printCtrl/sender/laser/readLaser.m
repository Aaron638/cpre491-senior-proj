% Read bytes from device until we see the response terminator 0x0D
function resp = readLaser(device)
    temp = uint8(0x00);
    resp = zeros(1, 120, "uint8"); % Max resp size is 116, see CMD 0x0C
    i = 0;
    while temp ~= uint8(0x0D)
        resp(i) = read(device, 1, "uint8");
        temp = resp(i);
        i = i + 1;
        if temp == uint8(0x0D)
            % Read the CRC byte before exiting loop
            resp(i) = read(device, 1, "uint8");
        end
    end
    % Trim extraneous zeroes
    resp = nonzeros(resp);
end