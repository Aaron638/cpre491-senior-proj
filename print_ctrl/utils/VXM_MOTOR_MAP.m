% The purpose of this global constant struct is to abstract away the confusing indexing.
% The user/programmer can access each motor controller: 
%   m1-m4 under port_a
%   m5-m6 under port_b
% 
% To use, place near the start of your function like so
%   map = VXM_MOTOR_MAP

function map = VXM_MOTOR_MAP() 

    map.port_a = "COM5";  % Maps to motors 1-4
    map.port_b = "COM11"; % Maps to motors 5 and 6

    % Motor Indexing Map:
    % MANUALLY CHANGE IF NECESSARY
    map.m1 = 1; % Spotsize
    map.m2 = 4; % Roller
    map.m3 = 2; % X-axis movement (left/right)
    map.m4 = 3; % Y-axis movement (forward/back)

    map.m5 = 1; % Supply Bed
    map.m6 = 2; % Powder Bed

end