% M202: Laser Off
% Does targeting laser for now
function laserCMD = setLaserOff()
    laserCMD = [0x1B, 0x02, 0x10, 0x00, 0x0D];
    laserCMD = [laserCMD, sum(laserCMD)];   % CRC byte
     % compose("0x%02X", setLaserOff) To view
end