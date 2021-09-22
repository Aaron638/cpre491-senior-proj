function [gcode_array] = insert_defect(gcode_file_name, x_start_defect, y_start_defect, z_start_defect, x_size, y_size, z_size, cube_length, cube_width, cube_height)
    %This function is used to make sure the laser does not activate when encountering a defect during the printing process
    %Inputs:
    %gcode_file_name (string) - name of gcode file that is generated 
    %x_start_defect (float) - x coordinate origin of the defect, if you are looking at the top side of the defect, it is the point at the bottom left on the bottom face  
    %y_start_defect (float) - y coordinate origin of the defect, if you are looking at the top side of the defect, it is the point at the bottom left on the bottom face  
    %z_start_defect (float) - z coordinate origin of the defect, if you are looking at the top side of the defect, it is the point at the bottom left on the bottom face  
    %x_size (float) - the dimension size of the defect in the x direction, the width of the defect
    %y_size (float) - the dimension size of the defect in the y direction, the length of the defect
    %z_size (float) - the dimension size of the defect in the z direction, the height of the defect
    %Next inputs are only used for defensive coding purposes...
    %cube_length (float) - the length of the cube being printed
    %cube_width (float) - the width of the cube being printed
    %cube_height (float) - the height of the cube being printed
    %Output:
    %gcode_array (array) - array represents the gcode file after modifying it for encountering the defect


    %Check for illegal arguments
    if x_start_defect == 0 || y_start_defect == 0 || z_start_defect == 0
        disp("Illegal Argument in insert_defect(), indent cannot start at 0 for any coordinate");
        return;
    end
    if (x_start_defect + x_size) >= cube_width
        disp("Illegal Argument in insert_defect(), width of indent cannot be at or extend pass the bounds of cube");
        return;
    end
    if (y_start_defect + y_size) >= cube_length
        disp("Illegal Argument in insert_defect(), length of indent cannot be at or extend pass the bounds of cube");
        return;
    end
    if(z_start_defect + z_size) >= cube_height
        disp("Illegal Argument in insert_defect(), height of indent cannot be at or extend pass the bounds of cube");
        return;
    end

    %Open gcode file and write each line of the file to an array
    file_id = fopen(gcode_file_name);
    line = fgetl(file_id);
    i = 1;
    gcode_array = {};

    while ischar(line)
        gcode_array{i} = line;
        i = i + 1;
        line = fgetl(file_id);
    end
    i = 1;
    gcode_array_length = length(gcode_array);
    previous_coords = ""; %Used to keep track of the previous coordinate point since we care about previous and current point since two points make a line
    previous_x_coord = "";
    previous_y_coord = "";

    is_at_defect_layer_flag = 0; %Used to signal if the current height in the gcode is at a height that the defect is at

    %Loop through the array and modify it depending on if a defect layer is encountered
    while i <= gcode_array_length
        %Used to see if we are currently at a defect layer
        if startsWith(gcode_array{i}, "G01 Z")
            previous_coords = ""; %Set previous coordinate point to null since we are at a new layer
            z_coord = strsplit(gcode_array{i}, "Z");
            z_coord = z_coord{2};
            z_coord = str2double(z_coord);
            if z_coord >= z_start_defect && z_coord <= (z_start_defect + z_size)
                is_at_defect_layer_flag = 1;
            else
                is_at_defect_layer_flag = 0;
            end
        else
            if is_at_defect_layer_flag == 1 && startsWith(gcode_array{i}, "G01 X") %We are at a defect layer and we are encountering a coordinate point
                if previous_coords == "" %Check if this is the first coordinate point we are encountering since entering this defect layer
                    previous_coords = gcode_array{i};
                    previous_coords = strsplit(gcode_array{i});
                    previous_coords(1) = [];
                    previous_x_coord = strip(previous_coords{1}, "left", "X");
                    previous_y_coord = strip(previous_coords{2}, "left", "Y");
                    previous_x_coord = str2double(previous_x_coord);
                    previous_y_coord = str2double(previous_y_coord);

                else %This is at least the second coordinate point being encountered since entering a defect layer
                    coords = strsplit(gcode_array{i});
                    coords(1) = [];
                    x_coord = strip(coords{1}, "left", "X");
                    y_coord = strip(coords{2}, "left", "Y");
                    x_coord = str2double(x_coord);
                    y_coord = str2double(y_coord);

                    %The current line is inside of the defect
                    if previous_x_coord >= x_start_defect && previous_x_coord <= (x_start_defect + x_size) && previous_y_coord >= y_start_defect && previous_y_coord  <= (y_start_defect + y_size) && x_coord >= x_start_defect && x_coord <= (x_start_defect + x_size) && y_coord >= y_start_defect && y_coord  <= (y_start_defect + y_size)
                        previous_coords = gcode_array{i};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;
                        gcode_array = {gcode_array{1:i-2} "M202" gcode_array{i-2:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        i = i + 2;
                        gcode_array_length = gcode_array_length + 2;

                    %The current line starts outside the defect and goes rightward and stops somewhere inside the defect
                    elseif previous_x_coord < x_start_defect && previous_y_coord >= y_start_defect && previous_y_coord <= (y_start_defect + y_size) && x_coord >= x_start_defect && x_coord <= (x_start_defect + x_size) && y_coord >= y_start_defect && y_coord <= ( y_start_defect + y_size)
                        previous_coords = gcode_array{i};
                        formatSpec = "G01 X%.4f Y%.4f\n";
                        border_coord = sprintf(formatSpec, x_start_defect, previous_y_coord);
                        gcode_array = {gcode_array{1:i-2} "M201" gcode_array{i-1:end}};
                        gcode_array = {gcode_array{1:i} border_coord gcode_array{i+1:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;
                        i = i + 3;
                        gcode_array_length = gcode_array_length + 3;

                    %The current line starts outside the defect and goes leftward and stops somewhere inside the defect
                    elseif previous_x_coord > (x_start_defect + x_size) && previous_y_coord >= y_start_defect && previous_y_coord <= (y_start_defect + y_size) && x_coord >= x_start_defect && x_coord <= (x_start_defect + x_size) && y_coord >= y_start_defect && y_coord <= ( y_start_defect + y_size)
                        previous_coords = gcode_array{i};
                        formatSpec = "G01 X%.4f Y%.4f\n";
                        border_coord = sprintf(formatSpec, (x_start_defect + x_size), previous_y_coord);
                        gcode_array = {gcode_array{1:i-2} "M201" gcode_array{i-1:end}};
                        gcode_array = {gcode_array{1:i} border_coord gcode_array{i+1:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;
                        i = i + 3;
                        gcode_array_length = gcode_array_length + 3;

                    %The current line starts outside of the defect and goes rightward through the defect and stops somewhere outside the defect
                    elseif previous_x_coord < x_start_defect && previous_y_coord >= y_start_defect && previous_y_coord <= (y_start_defect + y_size) && x_coord > (x_start_defect + x_size) && y_coord >= y_start_defect && y_coord <= (y_start_defect + y_size)
                        previous_coords = gcode_array{i};
                        formatSpec = "G01 X%.4f Y%.4f\n";
                        left_border_coord = sprintf(formatSpec, x_start_defect, previous_y_coord);
                        right_border_coord = sprintf(formatSpec, (x_start_defect + x_size), previous_y_coord);
                        gcode_array = {gcode_array{1:i-2} "M201" gcode_array{i-1:end}};
                        gcode_array = {gcode_array{1:i} left_border_coord gcode_array{i+1:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        gcode_array = {gcode_array{1:i+2} right_border_coord gcode_array{i+3:end}};
                        gcode_array = {gcode_array{1:i+3} "M201" gcode_array{i+4:end}};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;    
                        i = i + 5;
                        gcode_array_length = gcode_array_length + 5;

                    %The current line starts outside of the defect and goes leftward through the defect and stops somewhere outside the defect
                    elseif previous_x_coord > (x_start_defect + x_size) && previous_y_coord >= y_start_defect && previous_y_coord <= (y_start_defect + y_size) && x_coord < (x_start_defect + x_size) && y_coord >= y_start_defect && y_coord <= (y_start_defect + y_size)
                        previous_coords = gcode_array{i};
                        formatSpec = "G01 X%.4f Y%.4f\n";
                        right_border_coord = sprintf(formatSpec, (x_start_defect + x_size), previous_y_coord);
                        left_border_coord = sprintf(formatSpec, x_start_defect, previous_y_coord);
                        gcode_array = {gcode_array{1:i-2} "M201" gcode_array{i-1:end}};
                        gcode_array = {gcode_array{1:i} right_border_coord gcode_array{i+1:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        gcode_array = {gcode_array{1:i+2} left_border_coord gcode_array{i+3:end}};
                        gcode_array = {gcode_array{1:i+3} "M201" gcode_array{i+4:end}};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;   
                        i = i + 5;
                        gcode_array_length = gcode_array_length + 5;

                    %The current line starts outside the defect and goes downwards and stops somewhere inside the defect
                    elseif previous_x_coord >= x_start_defect && previous_x_coord <= (x_start_defect + x_size) && previous_y_coord > (y_start_defect + y_size) && x_coord >= x_start_defect && x_coord <= (x_start_defect + x_size) && y_coord >= y_start_defect && y_coord <= (y_start_defect + y_size)
                        previous_coords = gcode_array{i};
                        formatSpec = "G01 X%.4f Y%.4f\n";
                        border_coord = sprintf(formatSpec, previous_x_coord, (y_start_defect + y_size));
                        gcode_array = {gcode_array{1:i-2} "M201" gcode_array{i-1:end}};
                        gcode_array = {gcode_array{1:i} border_coord gcode_array{i+1:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;
                        i = i + 3;
                        gcode_array_length = gcode_array_length + 3;

                    %The current line starts outside the defect and goes upwards and stops somewhere inside the defect
                    elseif previous_x_coord >= x_start_defect && previous_x_coord <= (x_start_defect + x_size) && previous_y_coord < y_start_defect && x_coord >= x_start_defect && x_coord <= (x_start_defect + x_size) && y_coord >= y_start_defect && y_coord <= (y_start_defect + y_size)
                        previous_coords = gcode_array{i};
                        formatSpec = "G01 X%.4f Y%.4f\n";
                        border_coord = sprintf(formatSpec, previous_x_coord, y_start_defect);
                        gcode_array = {gcode_array{1:i-2} "M201" gcode_array{i-1:end}};
                        gcode_array = {gcode_array{1:i} border_coord gcode_array{i+1:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;
                        i = i + 3;
                        gcode_array_length = gcode_array_length + 3;

                    %The current line goes downwards and stops somewhere on the other side of the defect
                    elseif previous_x_coord >= x_start_defect && previous_x_coord <= (x_start_defect + x_size) && previous_y_coord > (y_start_defect + y_size) && x_coord >= x_start_defect && x_coord <= (x_start_defect + x_size) && y_coord < y_start_defect
                        previous_coords = gcode_array{i};
                        formatSpec = "G01 X%.4f Y%.4f\n";
                        upper_border_coord = sprintf(formatSpec, previous_x_coord, (y_start_defect + y_size));
                        lower_border_coord = sprintf(formatSpec, previous_x_coord, y_start_defect);
                        gcode_array = {gcode_array{1:i-2} "M201" gcode_array{i-1:end}};
                        gcode_array = {gcode_array{1:i} upper_border_coord gcode_array{i+1:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        gcode_array = {gcode_array{1:i+2} lower_border_coord gcode_array{i+3:end}};
                        gcode_array = {gcode_array{1:i+3} "M201" gcode_array{i+4:end}};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;      
                        i = i + 5;
                        gcode_array_length = gcode_array_length + 5;

                    %The current line goes upwards and stops somewhere on the other side of the defect
                    elseif previous_x_coord >= x_start_defect && previous_x_coord <= (x_start_defect + x_size) && previous_y_coord < y_start_defect && x_coord >= x_start_defect && x_coord <= (x_start_defect + x_size) && y_coord > (y_start_defect + y_size)
                        previous_coords = gcode_array{i};
                        formatSpec = "G01 X%.4f Y%.4f\n";
                        lower_border_coord = sprintf(formatSpec, previous_x_coord, y_start_defect);
                        upper_border_coord = sprintf(formatSpec, previous_x_coord, (y_start_defect + y_size));
                        gcode_array = {gcode_array{1:i-2} "M201" gcode_array{i-1:end}};
                        gcode_array = {gcode_array{1:i} lower_border_coord gcode_array{i+1:end}};
                        gcode_array = {gcode_array{1:i+1} "M202" gcode_array{i+2:end}};
                        gcode_array = {gcode_array{1:i+2} upper_border_coord gcode_array{i+3:end}};
                        gcode_array = {gcode_array{1:i+3} "M201" gcode_array{i+4:end}};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;       
                        i = i + 5;
                        gcode_array_length = gcode_array_length + 5;
                        
                    else
                        previous_coords = gcode_array{i};
                        previous_x_coord = x_coord;
                        previous_y_coord = y_coord;
                    end
                end

            end
        end

        i = i + 1;

    end
        gcode_array_lengh
        gcode_str = ""; %Used to convert the gcode_array back into a string
        %Convert gcode_array to string
        for file_line = 1:length(gcode_array)
            gcode_str = gcode_str + file_line;
        end

        %Write new gcode string to a file
        str = compose(gcode_str);
        file_id = fopen('defect.gcode', 'w');
        fprintf(file_id, '%s', str);
        fclose(file_id);

end