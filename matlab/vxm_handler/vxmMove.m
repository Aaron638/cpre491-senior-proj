% Move from previous point (x0, y0) to new point (x1, y1)
% Returns a cell string (a string array that actually works)



% The previous group was insane and did not regulate their formatting whatsoever
% Redefining command convention with spacing for readability (spaces are ignored by vxm motors):
% BEFORE:
% "F,PM-1,S2M{speedX},S3M{speedY},(I3M{deltaY},I2M{deltaX},)R"

% AFTER
% "F, PM-1, S2M {speedX}, S3M {speedY}, (I2M {deltaX}, I3M {deltaY}), R"

function vxmCMD = vxmMove(x0, y0, x1, y1)
    
    deltaX = x1 - x0;
    deltaY = y1 - y0;
    dist = sqrt(deltaX.^2 + deltaY.^2);
    
    % Apparently averageSpeed is set by user
    % One example shows that it's 25 * 400????
    % Need to look at vxm-2 manual
    avgSpeed = 25 * 400;

    speedX = abs(avgSpeed * (deltaX / dist));
    speedY = abs(avgSpeed * (deltaY / dist));

    % Formatting the strings
    % We force them to be ints, not sure if this is dangerous
    deltaX = compose("%d", deltaX);
    deltaY = compose("%d", deltaY);
    speedX = compose("%d", speedX);
    speedY = compose("%d", speedY);
    
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