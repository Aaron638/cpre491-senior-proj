% Resets the powderbed to absolute zero by moving the motors to it's limits.
% F = On-Line mode with echo off
% C = clear all commands from current program
% S2M 600 = Set Motor 2 Speed 600 steps/second
% S3M 600 = Set Motor 3 Speed 600 steps/second
% (I3M0, I2M0,) = Index motor 2 and 3 simultaneously
% IA2M-0, IA3M-0 = Set Zero position for motor 2 and 3
% R = run command
function bedCMD = bedZero()
    bedCMD = 'F, C, S1M600, (I2M0, I3M0), IA2M-0, IA3M-0  R';
end