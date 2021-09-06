% Move from previous point (x0, y0) to new point (x1, y1)
%   gcode units are in mm. So the point (1, 1), is 1mm in the x and y direction.
%   xi and yi indicate which motor to index.
% Returns a string
%
% Formatted Example:
% "F, C, I2M 400, R"
%   F = On-Line mode with echo off
%   C = clear all commands from current program
%   I2M 400 = Index motor 2, move 400 steps positive direction
%   R = run command

function vxmCMD = moveAxis(x0, y0, x1, y1, xi, yi)
    
    % Calculate the distance to travel (mm)
    deltaX = x1 - x0;
    deltaY = y1 - y0;

    % Convert to integer number of steps (See VXM_STEP_SIZE.m)
    deltaX = int32(deltaX / VXM_STEP_SIZE);
    deltaY = int32(deltaY / VXM_STEP_SIZE);
    
    % Write the vxm command
    % Only move motor number yi (y-axis)
    if deltaX == 0
        vxmCMD = [compose("F, C, I%dM %d, R,", yi, deltaY)];
    % Only move motor number xi (x-axis)
    elseif deltaY == 0
        vxmCMD = [compose("F, C, I%dM %d, R,", xi, deltaX)];
    % Move both motor xi and yi (usually 2 and 3?)
    else
        vxmCMD = [compose("F, C, (I%dM %d, I%dM %d), R,", xi, yi, deltaX, deltaY)];
    end
end