% Move from previous point (x0, y0) to new point (x1, y1)
%   gcode units are in mm. So the point (1, 1), is 1mm in the x and y direction.
% Returns a string array

% Format: (see docs for details)
% "F, PM-1, S2M {speedX}, S3M {speedY}, (I2M {deltaX}, I3M {deltaY}), R"

function vxmCMD = vxmMove(x0, y0, x1, y1)
    
    % Calculate the distance to travel (mm)
    % "dist_" is used because "dist" is a built in matlab function
    deltaX = x1 - x0;
    deltaY = y1 - y0;
    dist_ = sqrt(deltaX.^2 + deltaY.^2);
    
    % TODO: User should set average speed
    avgSpeed = 1;
    % Speed to move in the x or y direction (mm/s)
    speedX = abs(avgSpeed * (deltaX / dist_));
    speedY = abs(avgSpeed * (deltaY / dist_));

    % Convert to Steps (See VXM_STEP_SIZE.m)
    deltaX = deltaX / VXM_STEP_SIZE;
    deltaY = deltaY / VXM_STEP_SIZE;
    speedX = speedX / VXM_STEP_SIZE;
    speedY = speedY / VXM_STEP_SIZE;

    % Convert to int
    deltaX = int32(deltaX);
    deltaY = int32(deltaY);
    speedX = int32(speedX);
    speedY = int32(speedY);

    % Convert to String
    deltaX = compose("%d", deltaX);
    deltaY = compose("%d", deltaY);
    speedX = compose("%d", speedX);
    speedY = compose("%d", speedY);
    
    % Write the vxm command
    % Only move motor 3 (y-axis)
    if str2double(deltaX) == 0
        vxmCMD = "F, PM-1, S3M " + speedY + " I3M " + deltaY + ", R,\n";
    % Only move motor 2 (x-axis)
    elseif str2double(deltaY) == 0
        vxmCMD = "F, PM-1, S2M " + speedX + " I2M " + deltaX + ", R,\n";
    % Move both motor 2 and 3
    else
        vxmCMD = "F, PM-1, S2M " + speedX + ", S3M " + speedY + ", (I2M " + deltaX + ", I3M " + deltaY + "), R,\n";
    end
end