% Resets the powderbed to absolute zero by moving the motors to it's limits.
% Returns a string

% F = On-Line mode with echo off
% C = clear all commands from current program
% S1M 600 = Set Motor 1 Speed 600 steps/second
% I1M-0 = Move motor 1 CCW (down) until switch limit encountered
% IA1M-0 = Set Zero position for motor 1
% R = run command
function bedCMD = bedZero()
    cmd1 = compose("F, C, I1M-0, IA1M-0, R\r");
    cmd2 = compose("F, C, I2M 0, IA2M 0, R\r");
    bedCMD = [cmd1, cmd2];
end