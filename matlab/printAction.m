% Methods to send commands to the vxm motors
% For now, we're excluding units
classdef printAction

    methods (Static)

        % Move from previous point (x0, y0) to new point (x1, y1)
        % Returns the VXM command string array:
        % "F, PM-1, S2M{0}, S3M{1}, (I3M{2},I2M{3},)R"
        function vxmCMD = move(x0, y0, x1, y1)
            
            deltaX = x1 - x0;
            deltaY = y1 - y0;
            dist = sqrt(deltaX.^2 + deltaY.^2);
            
            % Apparently averageSpeed is set by user
            % One example shows that it's 25 * 400?
            avgSpeed = 25 * 400;

            speedX = abs(avgSpeed * (deltaX / dist));
            speedY = abs(avgSpeed * (deltaY / dist));
            
            % Write the vxm command
            vxmCMD = '';
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

        % Move the bed to be at a certain Z-elevation
        % M200 Z: Layer Change
        % "F, PM-1, S1M2000, I1M-{0}, R"
        % "F, PM-1, S2M2000, I2M{0}, R"
        % "F, PM-1, S1M6000, I1M0, R"
        % "F, PM-1, S1M6000, I1M-0, R"
        function vxmCMD = layerChange(z)

            % They took the z elevation multiplied by 5 * 400
            % 400 is the BED_CONVERSION_FACTOR, whatever that is
            stepsMoved = z * 5 * 400

            % Write the vxm command
            vxmCMD = ''
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

        % M201: Laser On
        function vxmCMD = laserOn()
            vxmCMD = "";
        end

        % M202: Laser Off
        function vxmCMD = laserOff()
            vxmCMD = "";
        end
    end
end