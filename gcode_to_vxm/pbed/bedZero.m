% Resets the powderbed to absolute zero by moving the motors to it's limits.
% F = On-Line mode with echo off
% C = clear all commands from current program
% S1M 600 = Set Motor 1 Speed 600 steps/second
% I1M0 = Index motor 1
% IA1M-0 = Set Zero position for motor 1
% R = run command
function bedCMD = bedZero()
    bedCMD = 'F, C, S1M600, I1M0, IA1M-0, R';
end