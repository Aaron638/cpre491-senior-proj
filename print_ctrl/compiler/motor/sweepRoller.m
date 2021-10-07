function vxmCMD = sweepRoller()
    VXM = VXM_MOTOR_VXM;
    cmd1 = compose("F, C, I%dM  0, R,", VXM.m2);
    cmd2 = compose("F, C, I%dM -0, R,", VXM.m2);
    vxmCMD = [cmd1, cmd2];
end