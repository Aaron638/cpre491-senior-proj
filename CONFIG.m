%{ 
    CONFIG
    "Global constants" to be edited by the user to set ports, addresses, step size, and other variables.
    Developers should use this rather than explicitly stating port numbers and motor indexes.

    Example usage in Matlab code:
      CFG = CONFIG();    % Instantiate the struct as CFG

    Previously to move the supply bed motor, you would index motor 1, port COM11.
    This can be troublesome because COM ports tend to change when plugging in USB-Serial cables in different ports.
      % Use freemove function to move supplybed 500 steps:
      freeMove("COM11", 1, 500);

    CONFIG gives these explicit names, so you can index CFG.SUPPLYBED_VXM, port CFG.PORT_SOLO instead.
      % Use freemove function to move supplybed 500 steps:
      freeMove(CFG.PORT_SOLO, CFG.SUPPLYBED_VXM, 500);

    STEP_SIZE defines the size of one step.
    As of the time of writing this, the size of one VXM step is 0.0025mm.
    1mm = 400 steps
    Example usage:
      dist_in_mm = 2;
      dist_in_steps = dist_in_mm / CFG.STEP_SIZE;
    800 steps = (2mm) / (0.0025mm/step)

    ZERO_X, ZERO_Y, ZERO_S, ZERO_P define absolute positions for the origin for usage in homeAxisRoller() and homeBeds().
    From the perspective of the user looking into the chamber:
    We place the origin at the bottom left of the print bed.

    X-axis: left(-) and right(+) movement.
    Y-axis: forward/away(-) and backward/towards(+) movement.
    supply bed Z-axis: up(-) and down(+) movement.
    print bed Z-axis: up(-) and down(+) movement.

    ZERO_X - 1800 steps from the right limit switch. (x mm from the left border of print bed)
    ZERO_Y - 13000 steps from the limit switch closest to the user. (y mm from the bottom border of print bed)
    ZERO_S - 1800 steps above the limit switch position (any lower and powder could leak out) 
    ZERO_P - Upper limit switch. (20cm up, but should stop at limit switch.)
%}  
function CFG = CONFIG()

% Users can edit:
    % Serial Ports for VXM motors
    CFG.BAUD_VXM = 9600;
    CFG.PORT_TWIN = "COM5";  % VXMs to motors 1-4
    CFG.PORT_SOLO = "COM11"; % VXMs to motors 5 & 6
    % TCP for Laser
    CFG.IP_LASER = "169.254.198.107";
    CFG.PORT_LASER = 58176;
    % VISA-USB for function generator
    % TODO: Update Matlab and use visadev() instead of visa.
    CFG.VISA_VENDOR_FG = "keysight";
    CFG.RSRC_FG = "USB::0x0957::0x0407::MY44034072::0::INSTR";
    % I think it's supposed to be a driver file, but not 100%
    CFG.DRIVER_FG = "agilent_33220a.mdd";

% Only developers should edit:
    % Motor indexing
    % Twin Port
    CFG.SPOTSIZE_VXM = 4;
    CFG.ROLLER_VXM = 1;
    CFG.XAXIS_VXM = 2;
    CFG.YAXIS_VXM = 3;
    % Solo Port
    CFG.SUPPLYBED_VXM = 1;
    CFG.PRINTBED_VXM = 2;

    % Defined VXM zero position in steps
    CFG.ZERO_X = -11000;
    CFG.ZERO_Y = 50000;
    CFG.ZERO_S = -1800;
    CFG.ZERO_P =-50000;

    % Defined VXM step size (mm)
        % 1mm = 400steps
    CFG.STEP_SIZE = 0.0025;

end