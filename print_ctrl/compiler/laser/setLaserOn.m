% M201: Laser On
% Does targeting laser for now
function laserCMD = setLaserOn()
    laserCMD = [0x1B, 0x02, 0x10, 0x01, 0x0D];
    laserCMD = [laserCMD, sum(laserCMD)];   % CRC byte
    % compose("0x%02X", setLaserOn) To view
end