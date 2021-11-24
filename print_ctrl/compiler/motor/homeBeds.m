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
    homecmd = compose("F, C, S%dM 3000, S%dM 3000, ", CFG.SUPPLYBED_VXM, CFG.PRINTBED_VXM);
    homecmd = homecmd + compose("I%dM %d, I%dM -%d, R,", CFG.SUPPLYBED_VXM, CFG.ZERO_S, CFG.PRINTBED_VXM, CFG.ZERO_P);

end
