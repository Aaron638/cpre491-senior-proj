% Move the bed to be at a certain Z-elevation
% Return a string of commands

% M200 {z}: Layer Change
% "F, PM-1, S1M 2000, I1M -{z}, R"
% "F, PM-1, S2M 2000, I2M  {z}, R"
% "F, PM-1, S1M 6000, I1M   0 , R"
% "F, PM-1, S1M 6000, I1M  -0 , R"

function vxmCMD = bedMove(z)

    vxmCMD = "";
    % Convert z to Steps (See VXM_STEP_SIZE.m)
    stepsMoved = z / VXM_STEP_SIZE;

    % Convert to int
    stepsMoved = int32(stepsMoved);

    % Convert to string
    stepsMoved = compose("%d", stepsMoved);

    % Write the vxm command's 4 lines
    % Move the left bed up by stepsMoved
    vxmCMD = vxmCMD + "F, PM-1, S1M 2000, I1M -" + stepsMoved + ", R,\r\n";
    % Move the right bed down by stepsMoved
    vxmCMD = vxmCMD + "F, PM-1, S2M 2000, I2M " + stepsMoved + ", R,\r\n";
    % ???
    vxmCMD = vxmCMD + "F, PM-1, S1M 6000, I1M   0, R,\r\n";
    vxmCMD = vxmCMD + "F, PM-1, S1M 6000, I1M  -0, R,\r\n";

end