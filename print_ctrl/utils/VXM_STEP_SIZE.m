% Global to define the size of a VXM step as 0.0025mm.
% 1mm = 400 steps
% One step is 1/400 of a motor revolution.
%
% Example:
%   800 steps     = (2mm) / (0.0025mm/step)
% Usage:
%   dist_in_steps = dist_in_mm / VXM_STEP_SIZE;
%
% https://www.mathworks.com/matlabcentral/answers/341496-how-to-make-a-constant-global-so-all-packages-files-use-it
%
function steps = VXM_STEP_SIZE()
    
    steps = 0.0025;

end
