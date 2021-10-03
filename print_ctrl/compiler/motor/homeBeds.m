function homecmd = homeBeds()
    % Compiler version of Tary's printerHome function for motors 5 and 6.
    % Uses global constants rather than hard coding values in the string

    map = VXM_MOTOR_MAP;
    zero = ZERO_POS;
    % Motor speed is 3000, 50% of max speed

    % Zero Beds to our defined zero position
    homecmd = compose("F, C, S%dM 3000, S%dM 3000, ", map.m5, map.m6);
    homecmd = homecmd + compose("I%dM %d, I%dM -%d, R,", map.m5, zero.s, map.m6, zero.p);

end
