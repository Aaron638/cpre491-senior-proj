% Compiler subfunction which moves motors 1-4 to the defined home position in ZERO_POS.m
% Similar to Tary's printerHome, but uses global constants to prevent hard-coding the values.
% 
% Usage:
%   printerAction = homeBeds();
% 
% Returns a single string with the command.
% 
function homecmd = homeAxisRoller()

    CFG = CONFIG();
    % Motor speed is 5400, 90% of max speed

    % Zero Motors
    %   Spotsize (I1M-0)
    homecmd = [compose("F, C, S%d M5400, I%d M0, R,", CFG.SPOTSIZE_VXM, CFG.SPOTSIZE_VXM)];
    %   Roller (I4M0)
    homecmd = [homecmd, compose("F, C, S%d M5400, I%d M-0, R,", CFG.ROLLER_VXM, CFG.ROLLER_VXM)];
    %   X and Y axis (I2M0, I3M-0)
    homecmd = [homecmd, compose("F, C, S%d M5400, S%d M5400, I%d M0, I%d M-0, R,", CFG.XAXIS_VXM, CFG.YAXIS_VXM, CFG.XAXIS_VXM, CFG.YAXIS_VXM)];

    % Adjust Axis motors to our defined zero position (-1800, 13000) Top right
    homecmd = [homecmd, compose("F, C, I2 M%d, I3 M%d, R,", CFG.ZERO_X, CFG.ZERO_Y)];

end
