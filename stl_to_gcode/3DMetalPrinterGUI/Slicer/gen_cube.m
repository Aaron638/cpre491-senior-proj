%{ 
This script generates a gcode file for printing a cube (or any rectangular
prism for that matter). You can edit the paramters below to get different
types of cubes.
%}

% -------------------------------------------------------------------------
% Cube parameters
% -------------------------------------------------------------------------

% cube dimensions in [unit]
length = 13;
width = 13;
height = 3;

% height of layer in range [10,200] microns
layer_height = 10;

% num voxels per side
voxel_length_density = 3;
voxel_width_density = 3;

% margin betwen voxel borders and outer border
voxel_margin = 0.5;

% padding between voxels and their border
voxel_padding = .5;

% Auto calculated parameters, do not edit
voxel_border_length = (length - (voxel_margin * (voxel_length_density + 1))) / voxel_length_density;
voxel_border_width  = (width - (voxel_margin * (voxel_width_density + 1))) / voxel_width_density;
voxel_length = (length - ((voxel_margin * (voxel_length_density + 1)) + (voxel_padding * 2 * voxel_length_density))) / voxel_length_density;
voxel_width  = (width - ((voxel_margin * (voxel_width_density + 1)) + (voxel_padding * 2 * voxel_width_density))) / voxel_width_density;

gcode = "";

% -------------------------------------------------------------------------
% Cube Generation
% -------------------------------------------------------------------------

% draw single layer

% draw outer border
gcode = gcode + "G01 X0 Y0\n";
gcode = gcode + "G01 X" + length + " Y0\n";
gcode = gcode + "G01 X" + length + " Y" + width + "\n";
gcode = gcode + "G01 X0 Y" + width + "\n";
gcode = gcode + "G01 X0 Y0\n";

for i = 0:voxel_length_density-1
    for j = 0:voxel_width_density-1
        % draw voxel border
        x = voxel_margin + (i * (voxel_border_length + voxel_margin));
        y = voxel_margin + (j * (voxel_border_width + voxel_margin));
        
        gcode = gcode + "G01 X" + x + " Y" + y + "\n";
        x = x + voxel_border_length;
        gcode = gcode + "G01 X" + x + " Y" + y + "\n";
        y = y + voxel_border_width;
        gcode = gcode + "G01 X" + x + " Y" + y + "\n";
        x = x - voxel_border_length;
        gcode = gcode + "G01 X" + x + " Y" + y + "\n";
        y = y - voxel_border_width;
        gcode = gcode + "G01 X" + x + " Y" + y + "\n";
        
        % draw voxel
        gcode_voxel = gen_voxel(x + voxel_padding, y + voxel_padding, voxel_length, voxel_width, 0, 0);
        gcode = gcode + gcode_voxel;
        
    end
end


% Print gcode in correct format
str = compose(gcode);

fileID = fopen('test.g','w');
fprintf(fileID, '%s', str);
fclose(fileID);