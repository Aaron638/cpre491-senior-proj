% The purpose of this global constant struct is to abstract away the confusing indexing.
% The user/programmer can access each motor controller: 
%   m1-m4 under port_a
%   m5-m6 under port_b
% 
% To use, place near the start of your function like so
%   VXM = VXM_MOTOR_VXM

function VXM = VXM_MOTOR_VXM()

    % Motor Indexing VXM:
    % Our index = vxm index
    % MANUALLY CHANGE IF NEEDED
    VXM.port_a = "COM5";  % VXMs to motors 1-4
    VXM.m1 = 1; % Spotsize
    VXM.m2 = 4; % Roller
    VXM.m3 = 2; % X-axis movement (left/right)
    VXM.m4 = 3; % Y-axis movement (forward/back)

    VXM.port_b = "COM11"; % VXMs to motors 5 & 6
    VXM.m5 = 1; % Supply Bed
    VXM.m6 = 2; % Powder Bed

end