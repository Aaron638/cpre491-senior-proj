% Move the bed to be at a certain Z-elevation
% Return a string array of commands to send through 
% the COM Port which controls the VXM motors:

% M200 Z: Layer Change
% "F, PM-1, S1M2000, I1M-{0}, R"
% "F, PM-1, S2M2000, I2M{0}, R"
% "F, PM-1, S1M6000, I1M0, R"
% "F, PM-1, S1M6000, I1M-0, R"

function vxmCMD = layerChange(z)

    % They took the z elevation multiplied by 5 * 400
    % 400 is the BED_CONVERSION_FACTOR, whatever that is
    stepsMoved = z * 5 * 400;

    % Write the vxm command's 4 lines
    % Move the left bed up by stepsMoved
    L1 = strcat("F, PM-1, S1M2000, I1M-", stepsMoved, ", R");
    % Move the right bed down by stepsMoved
    L2 = strcat("F, PM-1, S2M2000, I2M", stepsMoved, ", R");
    % Can't find documentation on this:
    L3 = "F, PM-1, S1M6000, I1M0, R";
    L4 = "F, PM-1, S1M6000, I1M-0, R";

    % Concatenate the 4 strings vertically
    vxmCMD = [L1; L2; L3; L4];
end