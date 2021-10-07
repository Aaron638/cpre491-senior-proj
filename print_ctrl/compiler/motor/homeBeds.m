function homecmd = homeBeds()
    % Compiler version of Tary's printerHome function for motors 5 and 6.
    % Uses global constants rather than hard coding values in the string

    VXM = VXM_MOTOR_VXM;
    zero = ZERO_POS;
    % Motor speed is 3000, 50% of max speed

    % Zero Beds to our defined zero position
    homecmd = compose("F, C, S%dM 3000, S%dM 3000, ", VXM.m5, VXM.m6);
    homecmd = homecmd + compose("I%dM %d, I%dM -%d, R,", VXM.m5, zero.s, VXM.m6, zero.p);

end
