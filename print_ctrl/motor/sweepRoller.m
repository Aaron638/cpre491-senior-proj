% ri is the motor index of the roller. Usually motor 2?
function vxmCMD = sweepRoller(ri)
    cmd1 = compose("F, C, I%dM  0, R,\r", ri);
    cmd2 = compose("F, C, I%dM -0, R,\r", ri);
    vxmCMD = {cmd1, cmd2};
end