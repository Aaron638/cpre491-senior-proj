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

    % Zero Beds to our defined zero position
    homecmd = compose("F, C, S%dM 3000, S%dM 3000, ", CFG.VXM_SUPPLYBED, CFG.VXM_PRINTBED);
    homecmd = homecmd + compose("I%dM %d, I%dM -%d, R,", CFG.VXM_SUPPLYBED, CFG.ZERO_S, CFG.VXM_PRINTBED, CFG.ZERO_P);

end
