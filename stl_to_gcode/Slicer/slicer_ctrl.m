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
    defect_x_origin = data.defect_x_origin;
    defect_y_origin = data.defect_y_origin;
    defect_z_origin = data.defect_z_origin;
    defect_width = data.defect_width;
    defect_length = data.defect_length;
    defect_height = data.defect_height;

    gen_cube(length, width, height, layer_height, voxels_per_length, voxels_per_width, voxel_margin, voxel_padding);

    if defect_x_origin ~= -1 && defect_y_origin ~= -1 && defect_z_origin ~= -1 && defect_width ~= -1 && defect_length ~= -1 && defect_height ~= -1         
        insert_defect('test.gcode', defect_x_origin, defect_y_origin, defect_z_origin, defect_width, defect_length, defect_height, length, width, height);
    end

end