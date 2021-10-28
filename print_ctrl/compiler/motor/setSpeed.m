% UNTESTED
% NEEDS REFACTORING
% TODO: Restrict maximum and minimum input for speed.
% (As of right now shouldn't work bc all compiler functions include the 'C' command to clear program contents)
% 
% Compiler subfunction which generates the command to set the speed of given motor(s) in steps/s
% 
% Usage:
%   printerAction = setSpeed(VXM.m1, 400); % Set the sped of motor 1 to 400 steps/s
%   printerAction = setSpeed([VXM.m1, VXM.m2, VXM.m3], 700); % Set the speed of motors 1-3 to 700 steps/s
% 
% Returns a single string with the command to set the speed for a given motor(s).
% 
function vxmCMD = setSpeed(motorindex, speed)
    vxmCMD = "";
    for i = 1 : length(motorindex)
        vxmCMD = vxmCMD + compose("S%d M%d,", motorindex, speed);
    end
end