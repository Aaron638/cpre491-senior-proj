function [gcode] = insert_indent(gcode_file_name, x_start_indent, y_start_indent, z_start_indent, x_size, y_size, z_size, cube_length, cube_width, cube_height)

    %Check for illegal arguments
    if x_start_indent == 0 || y_start_indent == 0 || z_start_indent == 0
        disp("Illegal Argument in inser_indent(), indent cannot start at 0 for any coordinate");
        return;
    end
    if (x_start_indent + x_size) >= cube_width
        disp("Illegal Argument in insert_indent(), width of indent cannot be at or extend pass the bounds of cube");
        return;
    end
    if (y_start_indent + y_size) >= cube_length
        disp("Illegal Argument in insert_indent(), length of indent cannot be at or extend pass the bounds of cube");
        return;
    end
    if(z_start_indent + z_size) >= cube_height
        disp("Illegal Argument in insert_indent(), height of indent cannot be at or extend pass the bounds of cube");
        return;
    end

    file_id = fopen(gcode_file_name);
    line = fgetl(file_id);
    i = 1;
    gcode_array = {};

    while ischar(line)
        C{i} = line;
        i = i + 1;
        line = fgetl(file_id);
    end

    i = 1;
    gcode_array_length = length(gcode_array);
    previous_coords = "";
    previous_x_coord;
    previous_y_coord;

    is_at_indent_layer_flag = 0;

    while i <= gcode_array_length
        if startWith(gcode_array{i}, "G01 Z")
            previous_coords = "";
            z_coord = strsplit(gcode_array{i}, "Z");
            z_coord = zcoord{2};
            if z_coord >= y_start_indent && z_coord <= (z_start_indent + z_size)
                is_at_indent_layer_flag = 1;
            else
                is_at_indent_layer_flag = 0;
            end
        else
            if is_at_indent_layer_flag == 1 && startWith(gcode_array{i}, "G01 X")
                if previous_coords == ""
                    previous_coords = gcode_array{i};
                    previous_coords = strsplit(gcode_array{i});
                    previous_coords(1) = [];
                    previous_x_coord = strip(previous_coords{1}, "left", "X");
                    previous_y_coord = strip(previous_coords{2}, "left", "Y");
                    previous_x_coord = str2double(previous_x_coord);
                    previous_y_coord = str2double(previous_y_coord);

                else
                    coords = strsplit(gcode_array{i});
                    coords(1) = [];
                    x_coord = strip(coords{1}, "left", "X");
                    y_coord = strip(coords{2}, "left", "Y");
                    x_coord = str2double(x_coord);
                    y_coord = str2double(y_coord);

                    %The current line is inside of the indent
                    if previous_x_coord >= x_start_indent && previous_x_coord <= x_size && previous_y_coord >= y_start_indent && previous_y_coord  <= y_size && x_coord >= x_start_indent && x_coord <= x_size && y_coord >= y_start_indent && y_coord  <= y_size
                        gcode_array = {gcode_array{1:i-2} "M202" gcode_array{i-2:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        %gcode_array(i-1) = [];
                        %gcode_array(i-1) = [];
                        previous_coords = "";
                        gcode_array_length = gcode_array_length + 2;
                    
                    %add other scenerios 



                end


            end
        i = i + 1;

        end
        

    end

    
