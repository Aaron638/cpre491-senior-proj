% Move from previous point (x0, y0) to new point (x1, y1)
%   gcode units are in mm. So the point (1, 1), is 1mm in the x and y direction.
% Returns a string

% Format:
% "F, C, S2M 600, I2M 400, R"
%   F = On-Line mode with echo off
%   C = clear all commands from current program
%   S2M 600 = Set Motor 2 Speed 600 steps/second
%   I2M 400 = Index motor 2, move 400 steps positive direction
%   R = run command

function vxmCMD = rollerMove(x0, y0, x1, y1)
    
    % Calculate the distance to travel (mm)
    % "dist_" is used because "dist" is a built in matlab function
    deltaX = x1 - x0;
    deltaY = y1 - y0;
    dist_ = sqrt(deltaX.^2 + deltaY.^2);
    
    % TODO: User should set average speed in mm/s
    avgSpeed = 1;
    % Speed to move in the x or y direction (mm/s)
    speedX = avgSpeed * (deltaX / dist_);
    speedY = avgSpeed * (deltaY / dist_);

    % Convert to integer number of steps (See VXM_STEP_SIZE.m)
    deltaX = int32(deltaX / VXM_STEP_SIZE);
    deltaY = int32(deltaY / VXM_STEP_SIZE);
    speedX = int32(speedX / VXM_STEP_SIZE);
    speedY = int32(speedY / VXM_STEP_SIZE);
    
    % Write the vxm command
    % Only move motor 3 (y-axis)
    if str2double(deltaX) == 0
        vxmCMD = compose("F, C, S3M %d, I3M %d, R,\r\n", speedY, deltaY);
    % Only move motor 2 (x-axis)
    elseif str2double(deltaY) == 0
        vxmCMD = compose("F, C, S2M %d, I2M %d, R,\r\n", speedX, deltaX);
    % Move both motor 2 and 3
    else
        vxmCMD = compose("F, C, S2M %d, S3M %d, (I2M %d, I3M %d), R,\r\n", speedX, speedY, deltaX, deltaY);
    end
end