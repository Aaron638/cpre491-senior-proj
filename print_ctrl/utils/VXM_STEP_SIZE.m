% Defines the size of a VXM step as 0.0025mm
% 1mm = 400 steps
%
% Documentation says:
% One step is 1/400 of a motor revolution.
% But the distance per step depends on the screw model used.
% Testing seems to indicate that 1 step = 0.0002500 inches = 0.00635mm
%
% Example:
% 800 steps = (2mm) / (0.00635mm/step)
% dist_in_steps = dist_in_mm / VXM_STEP_SIZE
%
% https://www.mathworks.com/matlabcentral/answers/341496-how-to-make-a-constant-global-so-all-packages-files-use-it


function steps = VXM_STEP_SIZE()

    % 1 step = 0.00635mm
    steps = 0.00635;

end
