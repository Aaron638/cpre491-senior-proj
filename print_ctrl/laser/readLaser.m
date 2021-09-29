% Read bytes from device until we see the response terminator 0x0D

function result = readLaser(device)
    resp = "";
    while resp ~= 0x0D
        resp = [resp, read(device, 1, "uint8")];
    end
end