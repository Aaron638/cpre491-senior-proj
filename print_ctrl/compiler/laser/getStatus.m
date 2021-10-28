% M201: Get Status
% Does targeting laser for now
function laserCMD = getStatus(command)
    laserCMD = [0x1B, 0x01, command, 0x0D, 0x2A];
    % compose("0x%02X", getStatus) To view
end