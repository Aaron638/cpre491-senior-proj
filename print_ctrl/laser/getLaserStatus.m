% Generates a command to get the status of the laser
% This could just be hard coded to return [1B, 01, 01, 0D, 2A]
% but I wanted an example function that others can use as a template.
% Note that matlab will automatically convert hex values to integers
% 
function cmd = getLaserStatus()
    
    cmd = [0x1B, 0x01, 0x01, 0x0D];
    crc = sum(cmd);
    cmd = [cmd, crc];

end