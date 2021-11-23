% Compiler subfunction that generates the command to sweep the roller.
% 
% Usage:
%   printerAction = sweepRoller();
% 
% Returns an array of strings with commands to move the roller to furthest points.
% 
function vxmCMD = sweepRoller()
    CFG = CONFIG();
    cmd1 = compose("F, C, I%d M0, R,", CFG.VXM_ROLLER);
    cmd2 = compose("F, C, I%d M-0, R,", CFG.VXM_ROLLER);
    vxmCMD = [cmd1, cmd2];
end