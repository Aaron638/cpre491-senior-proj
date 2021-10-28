% Read bytes from device until we see the response terminator 0x0D

function resp = readLaser(device)
    temp;
    resp = [];
    while temp ~= uint8(0x0D)
        temp = read(device, 1, "uint8");
        resp = [resp, temp];
    end

    sprintf("%02X ", resp);
    disp(resp);
    flush(soloVXM);

end