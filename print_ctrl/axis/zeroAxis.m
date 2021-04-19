% Resets the three-axis roller to absolute zero by moving the motors to it's limits.
% Returns a string

% TODO: Add perimeter. Zeroing the motor should move it some steps away from the edge

% F = On-Line mode with echo off
% C = clear all commands from current program
% S2M 600 = Set Motor 2 Speed 600 steps/second
% S3M 600 = Set Motor 3 Speed 600 steps/second
% (I3M-0, I2M-0,) = Move motor 2 and 3 CCW (-x, -y) until switch limit encountered
% IA2M-0, IA3M-0 = Set Zero position for motor 2 and 3
% R = run command
function rollCMD = zeroAxis()
    rollCMD = 'F, C, S2M600, S3M600, (I2M-0, I3M-0), IA2M-0, IA3M-0  R';
end