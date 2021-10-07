% UNTESTED
% Compiler subfunction which moves the beds to the defined home position in ZERO_POS.m
% Similar to Tary's printerHome, but uses global constants to prevent hard-coding the values.
% 
% Usage:
%   printerAction = homeBeds();
% 
% Returns a single string with the command.
% 
function homecmd = homeBeds()

    VXM = VXM_MOTOR_MAP;
    zero = ZERO_POS;
    % Motor speed is 3000, 50% of max speed

    % Zero Beds to our defined zero position
    homecmd = compose("F, C, S%dM 3000, S%dM 3000, ", VXM.m5, VXM.m6);
    homecmd = homecmd + compose("I%dM %d, I%dM -%d, R,", VXM.m5, zero.s, VXM.m6, zero.p);

end
