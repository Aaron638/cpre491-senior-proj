function homecmd = homeAxisRoller()
    % Compiler version of Tary's printerHome function for motors 1-4.
    % Uses global constants rather than hard coding values

    VXM = VXM_MOTOR_VXM;
    zero = ZERO_POS;

    % Motor speed is 5400, 90% of max speed

    % Zero Motors
    %   Spotsize (I1M-0)
    homecmd = [compose("F, C, S%dM 5400, I%dM -0, R,", VXM.m1, VXM.m1)];
    %   Roller (I4M0)
    homecmd = [homecmd, compose("F, C, S%dM 5400, I%dM 0, R,", VXM.m2, VXM.m2)];
    %   X and Y axis (I2M0, I3M-0)
    homecmd = [homecmd, compose("F, C, S%dM 5400, S%dM 5400, I%dM 0, I%dM -0, R,", VXM.m3, VXM.m4, VXM.m3, VXM.m4)];

    % Adjust Axis motors to our defined zero position (-1800, 13000) Top right
    homecmd = [homecmd, compose("F, C, I2M %d, I3M %d, R,", zero.x, zero.y)];

end
