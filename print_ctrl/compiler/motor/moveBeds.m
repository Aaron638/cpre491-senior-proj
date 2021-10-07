% TODO: Prevent out of bounds movement.
%
% Compiler subfunction that increments the supply bed and decrements the print bed by an elevation 'z'.
% 'z' is usually the height of a print layer.
% 
% Usage:
%   printerAction = moveBeds(400);
% 
% Returns a single string with the command
% 
% VXM Command breakdown:
%   "F, C, I1M {stepsMoved}, R"
%       F = On-Line mode with echo off
%       C = clear all commands from current program
%       I1M{stepsMoved} = Move motor a certain number of steps
%       R = run command
%
function bedCMD = moveBeds(z)

    VXM = VXM_MOTOR_MAP;

    % Convert z to integer number of Steps (See VXM_STEP_SIZE.m)
    stepsMoved = int32(z / VXM_STEP_SIZE);

    % Convert to string 
    bedCMD = compose("F, C, I%dM  %d, I%dM -%d, R,", VXM.m5, stepsMoved, VXM.m6, stepsMoved);
end