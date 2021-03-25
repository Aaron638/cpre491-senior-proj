%{ 
This script generates a gcode file for printing a cube (or any rectangular
prism for that matter). You can edit the paramters below to get different
types of cubes.
%}

% -------------------------------------------------------------------------
% Cube parameters
% -------------------------------------------------------------------------

% cube dimensions in mm
length = 13;
width = 13;
height = 3;

% height of layer in range [10,200] microns
layer_height = 10;

% num voxels per side
voxel_length_num = 4;
voxel_width_num = 4;

% margin betwen voxel borders and outer border
voxel_margin = 0.5;

% padding between voxels and their border
voxel_padding = 0.5;

% Auto calculated parameters, do not edit
voxel_border_length = (length - (voxel_margin * (voxel_length_num + 1))) / voxel_length_num;
voxel_border_width  = (width - (voxel_margin * (voxel_width_num + 1))) / voxel_width_num;
voxel_length = (length - ((voxel_margin * (voxel_length_num + 1)) + (voxel_padding * 2 * voxel_length_num))) / voxel_length_num;
voxel_width  = (width - ((voxel_margin * (voxel_width_num + 1)) + (voxel_padding * 2 * voxel_width_num))) / voxel_width_num;
voxel_num = voxel_length_num*voxel_width_num;
voxel_to_draw = 0:voxel_num-1;

%disp(voxel_border_length + " " + voxel_border_width);
%disp(voxel_length + " " + voxel_width);


gcode = "Width: 30 Length: 30\nM200 0.1\n";

% -------------------------------------------------------------------------
% Cube Generation
% -------------------------------------------------------------------------

% draw single layer

% draw outer border
gcode = gcode + "G01 X0.0000 Y0.0000\n";
gcode = gcode + "G01 X" + sprintf('%.4f',length) + " Y0.0000\n";
gcode = gcode + "G01 X" + sprintf('%.4f',length) + " Y" + sprintf('%.4f',width) + "\n";
gcode = gcode + "G01 X0.0000 Y" + sprintf('%.4f',width) + "\n";
gcode = gcode + "G01 X0.0000 Y0.0000\n";

voxels_drawn = zeros(voxel_num-1,2);

for i = 0:voxel_num-1
    
    % This approach only works when num_rows==num_cols :(
    %v = randi(size(voxel_to_draw));
    %v = voxel_to_draw(v);
    %voxel_to_draw(voxel_to_draw == v) = []; % remove voxel we are currently drawing from eligible list
    %row = floor(v/voxel_width_num);
    %col = mod(v,voxel_length_num);
    %disp(v + "," + row + " " + col);
    
    % naiive approach for selecting voxel to draw
    while 1
       row = randi(voxel_length_num)-1;
       col = randi(voxel_width_num)-1;
       if ~(ismember([row,col],voxels_drawn,'rows'))
          break 
       end
    end
    voxels_drawn(i+1,:) = [row,col];
    
    % draw voxel border
    x = voxel_margin + (row * (voxel_border_length + voxel_margin));
    y = voxel_margin + (col * (voxel_border_width + voxel_margin));
        
    gcode = gcode + "G01 X" + sprintf('%.4f',x) + " Y" + sprintf('%.4f',y) + "\n";
    x = x + voxel_border_length;
    gcode = gcode + "G01 X" + sprintf('%.4f',x) + " Y" + sprintf('%.4f',y) + "\n";
    y = y + voxel_border_width;
    gcode = gcode + "G01 X" + sprintf('%.4f',x) + " Y" + sprintf('%.4f',y) + "\n";
    x = x - voxel_border_length;
    gcode = gcode + "G01 X" + sprintf('%.4f',x) + " Y" + sprintf('%.4f',y) + "\n";
    y = y - voxel_border_width;
    gcode = gcode + "G01 X" + sprintf('%.4f',x) + " Y" + sprintf('%.4f',y) + "\n";
        
    % draw voxel
    if mod(row,2)==0 && mod(col,2)==0
        gcode_voxel = gen_voxel(x + voxel_padding, y + voxel_padding, voxel_length, voxel_width, 1, 0, 11);
    else
        gcode_voxel = gen_voxel_90_degrees(x + voxel_padding, y + voxel_padding, voxel_length, voxel_width, 1, 0, 10);
    end
    gcode = gcode + gcode_voxel;
end


% Print gcode in correct format
str = compose(gcode);

fileID = fopen('test.g','w');
fprintf(fileID, '%s', str);
fclose(fileID);