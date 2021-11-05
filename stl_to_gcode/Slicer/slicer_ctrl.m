function slicer_ctrl(config_file)

    fid = fopen(config_file); % Opening the file
    raw = fread(fid,inf); % Reading the contents
    str = char(raw');
    fclose(fid); 
    data = jsondecode(str);

    length = data.length;
    width = data.width;
    height = data.height;
    layer_height = data.layer_height;
    voxels_per_length = data.voxels_per_length;
    voxels_per_width = data.voxels_per_width;
    voxel_margin = data.voxel_margin;
    voxel_padding = data.voxel_padding;
    gen_cube(length, width, height, layer_height, voxels_per_length, voxels_per_width, voxel_margin, voxel_padding);

    for n_defects=1:size(data.defects,1)

        n_array = data.defects(n_defects,1);
        defect_x_origin = n_array.defect_x_origin;
        defect_y_origin =  n_array.defect_y_origin;
        defect_z_origin =  n_array.defect_z_origin;
        defect_width =  n_array.defect_width;
        defect_length =  n_array.defect_length;
        defect_height =  n_array.defect_height;
   
        if defect_x_origin ~= -1 && defect_y_origin ~= -1 && defect_z_origin ~= -1 && defect_width ~= -1 && defect_length ~= -1 && defect_height ~= -1 
            insert_defect('test.gcode', defect_x_origin, defect_y_origin, defect_z_origin, defect_width, defect_length, defect_height, length, width, height);
        end


     end

end