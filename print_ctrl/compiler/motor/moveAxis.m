% TODO: Prevent out of bounds movement.
% 
% Compiler subfunction to move from previous point (x0, y0) to new point (x1, y1).
%   g-code units are in mm. The point (1, 1), is 1mm in the x and y direction.
% 
% Usage:
%   printerAction = moveAxis(2, 3, 8, 9); % Move from (2,3) to (8,9).
% 
% Returns a single string with the command.
%
% VXM Command breakdown:
%   "F, C, I2M 400, R"
%     F = On-Line mode with echo off
%     C = clear all commands from current program
%     I2M 400 = Index motor 2, move 400 steps positive direction
%     R = run command

function vxmCMD = moveAxis(x0, y0, x1, y1)

    VXM = VXM_MOTOR_MAP;
    
    % Calculate the distance to travel (mm)
    deltaX = x1 - x0;
    deltaY = y1 - y0;

    % Convert to integer number of steps (See VXM_STEP_SIZE.m)
    deltaX = int32(deltaX / VXM_STEP_SIZE);
    deltaY = int32(deltaY / VXM_STEP_SIZE);
    
    % Write the vxm command
    % Only move motor number yi (y-axis)
    if deltaX == 0
        vxmCMD = [compose("F, C, I%dM %d, R,", VXM.m4, deltaY)];
    % Only move motor number xi (x-axis)
    elseif deltaY == 0
        vxmCMD = [compose("F, C, I%dM %d, R,", VXM.m3, deltaX)];
    % Move both motor xi and yi (usually 2 and 3?)
    else
        vxmCMD = [compose("F, C, (I%dM %d, I%dM %d), R,", VXM.m3, VXM.m4, deltaX, deltaY)];
    end
end