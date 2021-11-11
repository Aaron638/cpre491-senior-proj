    % TODO: Replace ZERO_P with negative number limit.
    %   That way we can just use an int, rather than cast to string.
    % TODO: Add documentation

function CFG = CONFIG()
    
% EDIT IF PORTS CHANGED
    % Serial Ports
    CFG.PORT_TWIN = "COM5";  % VXMs to motors 1-4
    CFG.PORT_SOLO = "COM11"; % VXMs to motors 5 & 6
    % TCP Port
    CFG.PORT_LASER = 58176;

% ONLY EDIT IF NECESSARY

    % Motor indexing map
    CFG.VXM_SPOTSIZE = 4;
    CFG.VXM_ROLLER = 1;
    CFG.VXM_XAXIS = 2;
    CFG.VXM_YAXIS = 3;

    CFG.VXM_SUPPLYBED = 1;
    CFG.VXM_PRINTBED = 2;

    % Defined zero position

    CFG.ZERO_X = -1800; % x-axis
    CFG.ZERO_Y = 13000; % y-axis
    CFG.ZERO_S = -1800; % supply bed
    CFG.ZERO_P =    -0; % powder bed

end