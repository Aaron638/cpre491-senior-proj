% Set's the laser spotsize given it's radius.
% First moves the laser as far down as possible to zero it.
% Then moves the laser at the proper elevation.
% https://www.lasercalculator.com/laser-spot-size-calculator/
% https://www.mathworks.com/help/symbolic/units-list.html
%
% spot_diameter should be in scientific notation in milimeters
% 
% This program uses matlab symunits to ensure proper unit conversions
% 
% Returns a string array
function vxmCMD = setSpotsize(spot_radius_um)

    % Move the laser to it's lowest point.
    cmd1 = compose("F, C, I1M -0, R,\r");
    u = symunit;
    
    theta = 0;                              % TODO: find laser angle
    wo = spot_radius_um * u.um;             % Convert spot diameter to um
    D = 14 * u.mm;                          % Beam diameter at lens = 14mm
    wl = 1070 * u.nm;                       % Wavelength = 1070nm
    offset = 0 * u.cm;                      % TODO: figure out offset
    
    height = ((wo * vpa(pi) * D * cosd(theta))/ (2 * wl)) - offset;
    height = unitConvert(simplify(height), u.mm);   % Convert to mm
    height = int32(separateUnits(height) / VXM_STEP_SIZE); % Convert to steps

    % TODO: Calculate maximum possible height, and check if invalid
    if height > 9000
        disp("WARNING: Calculated height is over 9000 steps");
        disp("PAUSED. Press any key to continue.")
        pause;
    end

    cmd2 = compose("F, C, I1M %d, R,\r", height);
    vxmCMD = [cmd1, cmd2];
end