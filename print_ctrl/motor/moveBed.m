% Move the bed to be at a certain Z-elevation, where z is the elvation in mm.
% Returns a string
%
% "F, C, I1M {stepsMoved}, R"
%   F = On-Line mode with echo off
%   C = clear all commands from current program
%   I1M{stepsMoved} = Move motor a certain number of steps
%   R = run command
% Uses the default speed of 2000 steps/s

function bedCMD = moveBed(z)

    map = VXM_MOTOR_MAP;

    % Convert z to integer number of Steps (See VXM_STEP_SIZE.m)
    stepsMoved = int32(z / VXM_STEP_SIZE);

    % Convert to string (placing strings into array concats)
    cmd1 = compose("F, C, I%dM  %d, R,\r", map.m5, stepsMoved);
    cmd2 = compose("F, C, I%dM -%d, R,\r", map.m6, stepsMoved);
    bedCMD = [cmd1, cmd2];
end