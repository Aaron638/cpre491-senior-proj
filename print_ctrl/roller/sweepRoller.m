function vxmCMD = sweepRoller()
    cmd1 = compose("F, C, I2M  0, R,\r");
    cmd2 = compose("F, C, I2M -0, R,\r");
    vxmCMD = {cmd1, cmd2};
end