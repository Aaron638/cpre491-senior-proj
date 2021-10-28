% Global which changes the way motors are indexed to be from 1-6, rather than 1-4 and 1-2.
% The user/programmer can access each motor controller: 
%   m1-m4 under PORT_M1234
%   m5-m6 under PORT_M56
% 
% Usage:
%   VXM = VXM_MOTOR_MAP;    % Instantiate the struct as VXM
%   port = VXM.PORT_M1234;  % Use the port for motors 1-4.
% 
%   % Use freemove function to move motor 3, 500 steps:
%   freeMove(VXM.PORT_M1234, VXM.m3, 500);
% 
% Previously to move motor 5, the supply bed, you would index motor 1, port COM11.
% Now you can index VXM.m5, port VXM.PORT_M56.
% 
% The user/programmer can manually change the ports here.
% This may be necessary if the USB-to-Serial cables are unplugged and plugged back in.
% 
function VXM = VXM_MOTOR_MAP()

    % Motor Indexing VXM:
    % Our index = vxm index
    VXM.PORT_M1234 = "COM5";  % VXMs to motors 1-4
    VXM.m1 = 4; % Spotsize (neg up/pos down)
    VXM.m2 = 1; % Roller (neg left/pos right)
    VXM.m3 = 2; % X-axis movement (neg left/pos right)
    VXM.m4 = 3; % Y-axis movement (neg away/pos towards)

    VXM.PORT_M56 = "COM11"; % VXMs to motors 5 & 6
    VXM.m5 = 1; % Supply Bed
    VXM.m6 = 2; % Powder Bed

end