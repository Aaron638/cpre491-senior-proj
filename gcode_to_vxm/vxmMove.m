% Move from previous point (x0, y0) to new point (x1, y1)
%   gcode units are in mm. So the point (1, 1), is 1mm in the x and y direction.
% Returns a cell string (a string array that actually works)

% The previous group was insane and did not regulate their formatting whatsoever
% Redefining command convention with spacing for readability (spaces are ignored by vxm motors):
% BEFORE:
% "F,PM-1,S2M{speedX},S3M{speedY},(I3M{deltaY},I2M{deltaX},)R"

% AFTER
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
    % Convert to String
    % Speeds and distances must be integer
    deltaX = compose("%d", deltaX / VXM_STEP_SIZE);
    deltaY = compose("%d", deltaY / VXM_STEP_SIZE);
    speedX = compose("%d", speedX / VXM_STEP_SIZE);
    speedY = compose("%d", speedY / VXM_STEP_SIZE);
    
    % Write the vxm command
    % Only move motor 3 (y-axis)
    if str2double(deltaX) == 0
        vxmCMD = {strcat('F, PM-1, S3M ', speedY, ' I3M ', deltaY, ', R')};
    % Only move motor 2 (x-axis)
    elseif str2double(deltaY) == 0
        vxmCMD = {strcat('F, PM-1, S2M ', speedX, ' I2M ', deltaX, ', R')};
    % Move both motor 2 and 3
    else
        vxmCMD = {strcat('F, PM-1, S2M ', speedX, ' S3M ', speedY, ', (I2M ', deltaX, ' I3M ', deltaY, '), R')};
    end
end