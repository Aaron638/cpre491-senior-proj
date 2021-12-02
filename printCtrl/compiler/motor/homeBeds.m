% Compiler subfunction which moves the beds to the defined home position in ZERO_POS.m
% Similar to Tary's printerHome, but uses global constants to prevent hard-coding the values.
% 
% Usage:
%   printerAction = homeBeds();
% 
% Returns a single string with the command.
% 
function homecmd = homeBeds()

    CFG = CONFIG();
    % Motor speed is 3000, 50% of max speed
    
    speed = sprintf("F, C, S%d M3000, S%d M3000, ", CFG.SUPPLYBED_VXM, CFG.PRINTBED_VXM);
    % Sbed to lower limit switch, pbed to highest limit switch
    zerocmd = speed + sprintf("I%d M%s, I%d M%s, R,", CFG.SUPPLYBED_VXM, "0", CFG.PRINTBED_VXM, "-0");
    % Zero Beds to our defined zero position
    homecmd = speed + sprintf("I%d M%d, I%d M%d, R,", CFG.SUPPLYBED_VXM, CFG.ZERO_S, CFG.PRINTBED_VXM, CFG.ZERO_P);
    homecmd = [zerocmd, homecmd];
end
