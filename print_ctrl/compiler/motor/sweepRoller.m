function vxmCMD = sweepRoller()
    map = VXM_MOTOR_MAP;
    cmd1 = compose("F, C, I%dM  0, R,", map.m2);
    cmd2 = compose("F, C, I%dM -0, R,", map.m2);
    vxmCMD = [cmd1, cmd2];
end