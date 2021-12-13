% Compiler subfunction that generates the command to sweep the roller.
% 
% Usage:
%   printerAction = sweepRoller();
% 
% Returns an array of strings with commands to move the roller to furthest points.
% 
function vxmCMD = sweepRoller()
    CFG = CONFIG();
    cmd1 = compose("F, C, S%d M5400 I%d M0, R,", CFG.ROLLER_VXM, CFG.ROLLER_VXM);
    cmd2 = compose("F, C, S%d M5400 I%d M-0, R,", CFG.ROLLER_VXM, CFG.ROLLER_VXM);
    vxmCMD = [cmd1, cmd2];
end