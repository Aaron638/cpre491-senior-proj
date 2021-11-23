% Writes action as a toml file
function writeAction(filename)
    device = "'Laser'";
    port = string(25565);
    actions = ["'F, C, S4 M5400, I4 M0, R'", "'F, C, S1 M5400, I1 M-0, R'", "'F, C, S2 M5400, S3 M 5400, I2 M0, I3 M-0, R'","'F, C, I2 M-1800, I3 M13000, R'","'F, C, S1M 3000, S2M 3000, I1M -1800, I2M -0, R'"];
    gcode = "'M201'";

    fid = fopen(filename, 'wt');
    fprintf(fid, "[[printerAction]]\n");
    fprintf(fid, "device = %s\n", device);
    fprintf(fid, "port = %s\n", port);
    fprintf(fid, "actions = [\n");
    fprintf(fid, "\t%s,\n", actions);
    fprintf(fid, "]\n");
    fprintf(fid, "gcode = %s\n", gcode);
    fclose(fid);
end