% Move from previous point (x0, y0) to new point (x1, y1)

% "F, PM-1, S2M{0}, S3M{1}, (I3M{2},I2M{3},)R"

function vxmCMD = vxmMove(x0, y0, x1, y1)
    
    deltaX = x1 - x0;
    deltaY = y1 - y0;
    dist = sqrt(deltaX.^2 + deltaY.^2);
    
    % Apparently averageSpeed is set by user
    % One example shows that it's 25 * 400?
    avgSpeed = 25 * 400;

    speedX = abs(avgSpeed * (deltaX / dist));
    speedY = abs(avgSpeed * (deltaY / dist));
    
    % Write the vxm command
    vxmCMD = "";
    % Only move motor 3 (y-axis)
    if deltaX == 0
        vxmCMD = strcat("F, PM-1, S3M", speedY, "I3M", deltaY, ", R");
    % Only move motor 2 (x-axis)
    elseif deltaY == 0
        vxmCMD = strcat("F, PM-1, S2M", speedX, "I2M", deltaX, ", R");
    % Move both motor 2 and 3
    else
        vxmCMD = strcat("F, PM-1, S2M", speedX, "S3M", speedY, "(I2M", deltaX, "I3M", deltaY, ",) R");
    end
end