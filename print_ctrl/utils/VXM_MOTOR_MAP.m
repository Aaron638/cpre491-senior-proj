function map = VXM_MOTOR_MAP() 

    map.port_a = "COM5"; % Maps to motors 1-4
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