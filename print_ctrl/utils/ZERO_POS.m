% Global constant struct to define the zero position

function zero = ZERO_POS()
    zero.x = -1800; % x-axis
    zero.y = 13000; % y-axis
    zero.s = -1800; % supply bed
    zero.p =    -0; % powder bed
    % Note that -0 will be converted to zero by matlab
    % Make sure to include the negative sign in the string
    % Or else it will move to the positive zero position
end