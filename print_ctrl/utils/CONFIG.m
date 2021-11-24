% TODO: Replace ZERO_P with negative number limit.
%   That way we can just use an int, rather than cast to string.
% TODO: Clean up documentation
% Global constant struct to define the zero position.
% The zero position is the top-right of the print-bed.
% The supply bed is at the lowest elevation that does not have a gap.
% The print bed is at the higest elevation.
% 
% Global which changes the way motors are indexed to be from 1-6, rather than 1-4 and 1-2.
% The user/programmer can access each motor controller: 
%   m1-m4 under PORT_M1234
%   m5-m6 under PORT_M56
% 
% Usage:
%   CFG = CONFIG();    % Instantiate the struct as VXM
%   port = CFG.PORT_TWIN;  % Use the port for motors 1-4.
% 
%   % Use freemove function to move motor 3, 500 steps:
%   freeMove(CFG.PORT_TWIN, CFG.XAXIS_VXM, 500);
% 
% Previously to move motor 5, the supply bed, you would index motor 1, port COM11.
% Now you can index CFG.SUPPLYBED_VXM, port CFG.PORT_SOLO.
% 
% The user/programmer can manually change the ports here.
% This may be necessary if the USB-to-Serial cables are unplugged and plugged back in.
% 
% Global to define the size of a VXM step as 0.0025mm.
% 1mm = 400 steps
% One step is 1/400 of a motor revolution.
%
% Example:
%   800 steps     = (2mm) / (0.0025mm/step)
% Usage:
%   dist_in_steps = dist_in_mm / CFG.STEP_SIZE;

function CFG = CONFIG()
    
% EDIT IF NECESSARY
    % Serial Ports
    CFG.BAUD_VXM = 9600;
    CFG.PORT_TWIN = "COM5";  % VXMs to motors 1-4
    CFG.PORT_SOLO = "COM11"; % VXMs to motors 5 & 6
    % TCP
    CFG.IP_LASER = "169.254.198.107";
    CFG.PORT_LASER = 58176;

% ONLY EDIT IF NECESSARY

    % Motor indexing
    % Twin Port
    CFG.SPOTSIZE_VXM = 4;
    CFG.ROLLER_VXM = 1;
    CFG.XAXIS_VXM = 2;
    CFG.YAXIS_VXM = 3;
    % Solo Port
    CFG.SUPPLYBED_VXM = 1;
    CFG.PRINTBED_VXM = 2;

    % Defined VXM zero position
    CFG.ZERO_X = -1800; % x-axis
    CFG.ZERO_Y = 13000; % y-axis
    CFG.ZERO_S = -1800; % supply bed
    CFG.ZERO_P =-20000; % powder bed

    % Defined VXM step size (mm)
        % 1mm = 400steps
    CFG.STEP_SIZE = 0.0025;

end