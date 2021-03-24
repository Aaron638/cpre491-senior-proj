% Move the bed to be at a certain Z-elevation
% Return a cell string (a str array that actually works) of commands
% which are sent through the COM Port which controls the VXM motors:

% Redefining command convention with spacing for readability (spaces are ignored by vxm motors):
% M200 {z}: Layer Change
% "F, PM-1, S1M 2000, I1M- {0}, R"
% "F, PM-1, S2M 2000, I2M {0}, R"
% "F, PM-1, S1M 6000, I1M 0, R"
% "F, PM-1, S1M 6000, I1M- 0, R"

function vxmCMD = vxmLayer(z)

    % Convert z to Steps (See VXM_STEP_SIZE.m)
    stepsMoved = z / VXM_STEP_SIZE;
    % Convert to string, format as integer
    stepsMoved = compose("%d", stepsMoved);

    % Write the vxm command's 4 lines
    % Move the left bed up by stepsMoved
    L1 = strcat('F, PM-1, S1M 2000, I1M- ', stepsMoved, ', R');
    % Move the right bed down by stepsMoved
    L2 = strcat('F, PM-1, S2M 2000, I2M ', stepsMoved, ', R');
    % Can't find documentation on this:
    L3 = 'F, PM-1, S1M6000, I1M 0, R';
    L4 = 'F, PM-1, S1M6000, I1M- 0, R';

    % Place 4 strings into a cell string
    vxmCMD = {L1, L2, L3, L4};
end