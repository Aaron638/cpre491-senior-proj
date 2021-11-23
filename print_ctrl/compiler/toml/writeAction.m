% Writes action as a toml file
% Usage:
% % Laser Example
%   fid = fopen(filename, "w");
%   writeAction(fid, "Laser", CFG.PORT_LASER, setLaserOn(), "M201");
%   fclose(fid);
% % Motor Example
%   fid = fopen(filename, "w");
%   writeAction(fid, "Laser", CFG.PORT_TWIN, [moveBeds(...), sweepRoller(...)], "G01 X0.100");
%   fclose(fid);
% 
function writeAction(fid, device, port, cmds, gcode)

    fprintf(fid, "[[printerAction]]\n");
    fprintf(fid, "device = '%s'\n", device);
    
    if device == "Motor"
        % "COMx" serial port for motor comms
        fprintf(fid, "port = '%s'\n", port);
        fprintf(fid, "actions = [\n");
        % String array for VXM motor cmds
        fprintf(fid, "\t'%s',\n", cmds);
    elseif device == "Laser"
        % numerical port for TCP Laser comms
        fprintf(fid, "port = %d\n", port);
        fprintf(fid, "actions = [\n");
        % Hex Byte array for Laser commands
        fprintf(fid, "\t0x%02X,\n", cmds);
    elseif device == "FuncGen"
        % TODO:
        fprintf(fid, "\t,Function Generator\n");
    end
    fprintf(fid, "]\n");

    fprintf(fid, "gcode = '%s'\n\n", gcode);

end