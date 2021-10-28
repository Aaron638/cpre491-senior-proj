% Compiler subfunction that generates the command to sweep the roller.
% 
% Usage:
%   printerAction = sweepRoller();
% 
% Returns an array of strings with commands to move the roller to furthest points.
% 
function vxmCMD = sweepRoller()
    VXM = VXM_MOTOR_MAP;
    cmd1 = compose("F, C, I%dM  0, R,", VXM.m2);
    cmd2 = compose("F, C, I%dM -0, R,", VXM.m2);
    vxmCMD = [cmd1, cmd2];
end