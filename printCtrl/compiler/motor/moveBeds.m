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

    CFG = CONFIG();

    % Convert z to integer number of Steps (See CFG.STEP_SIZE.m)
    stepsMoved = int32(z / CFG.STEP_SIZE);

    % Convert to string 
    bedCMD = [compose("F, C, I%d M%d, I%d M-%d, R,", CFG.SUPPLYBED_VXM, stepsMoved, CFG.PRINTBED_VXM, stepsMoved)];
end