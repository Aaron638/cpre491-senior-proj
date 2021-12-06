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
%   "F, C, I2 M400, R"
%     F = On-Line mode with echo off
%     C = clear all commands from current program
%     I2 M400 = Index motor 2, move 400 steps positive direction
%     R = run command

function vxmCMD = moveAxis(x0, y0, x1, y1)

    CFG = CONFIG();
    
    % Calculate the distance to travel (mm)
    deltaX = x1 - x0;
    deltaY = y1 - y0;

    % Convert to integer number of steps (See CFG.STEP_SIZE.m)
    deltaX = int32(deltaX / CFG.STEP_SIZE);
    deltaY = int32(deltaY / CFG.STEP_SIZE);
    
    % Write the vxm command
    % Only move y-axis motor
    if (deltaX == 0 && deltaY ~= 0)
        vxmCMD = [compose("F, C, I%d M%d, R,", CFG.YAXIS_VXM, deltaY)];
    % Only move x-axis motor
    elseif (deltaX ~= 0 & deltaY == 0)
        vxmCMD = [compose("F, C, I%d M%d, R,", CFG.XAXIS_VXM, deltaX)];
    % Move both motors
    else
        vxmCMD = [compose("F, C, (I%d M%d, I%d M%d), R,", CFG.XAXIS_VXM, deltaX, CFG.YAXIS_VXM, deltaY)];
    end
end