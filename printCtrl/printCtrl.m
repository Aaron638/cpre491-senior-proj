% printCtrl

clear();
disp("At any time, press Ctrl+C to stop the program.");

prompt = sprintf("%s\n", ...
    "Enter one of the following commands:", ...
    "   'setup' to check connected devices.", ...
    "   'slice' to run slicer and generate .gcode", ...
    "   'compile' to compile .gcode into .toml", ...
    "   'test' to run testing functions", ...
    "   'send' to run the command sender");
r = input(prompt, 's');

switch r
case "setup"
    CFG = CONFIG();
    disp("Open /printCtrl/CONFIG.m, and reconfigure ports manually.");
    disp("Listing serial ports:");
    fprintf("%s ", serialportlist);

    fprintf("Attempting Laser TCP connection to %s, port %d:\n", CFG.IP_LASER, CFG.PORT_LASER);
    try
        t = tcpclient(CFG.IP_LASER, CFG.PORT_LASER, "Timeout", 5);
    catch
        disp("Connection timed out after 5 seconds. Check CONFIG.m or ethernet cable?");
        return
    end
    disp("TCP Connection successful.");

    disp("Testing USB connection to function generator.");
    % Matlab 2021:
    % visadevlist
    % Matlab 2020:
    try
        obj = visa(CFG.VISA_VENDOR_FG, CFG.RSRC_FG);
        h = icdevice(CFG.DRIVER_FG, obj);
        connect(h);
        devicereset(h);
        disp(propinfo(h));
        disconnect(h);
        delete(h);
        delete(obj);
    catch
        % TODO: Be more helpful to the user
        disp("Encountered issues with connection to function generator.");
        return
    end
    disp("Successful.");

case 'slice'
    prompt = sprintf("%s\n", ...
        "Enter location to config .json file", ...
        "   Default: './stl_to_gcode/Slicer/config.json'");
    r = input(prompt);
    slicer_ctrl(r);
    % winopen(r);

case 'compile'
    prompt = sprintf("%s\n", ...
        "Enter location to .gcode file", ...
        "   Example: './testFiles/basics.gcode'");
    i = input(prompt);
    prompt = sprintf("%s\n", ...
        "Enter location to save output .toml file", ...
        "   Example: './testFiles/basics.toml'");
    o = input(prompt);
    compile(i,o);
    winopen(o);

case 'test'
    prompt = sprintf("%s\n", ...
        "Enter one of the following commands:", ...
        "   'arbWaveForm' to test function generator.", ...
        "   'freeLaserTCP' to send a laser command", ...
        "   'freeMove' to test an individual motor", ...
        "   'freeVXMCMD' to run a VXM cmd (useful for -0 cmds)", ...
        "   'printerHome' to move the motors to home.");
    r = input(prompt, 's');

    switch r
    case 'arbWaveForm'
        arbWaveForm;

    case 'freeLaserTCP'
        prompt = sprintf("%s\n", ...
        "Enter uint8 array.", ...
        "Examples:", ...
        "   uint8([0x1b, 0x01, 0x01, 0x0d, 0x2a])", ...
        "   setLaserOff():");
        r = input(prompt);
        freeLaserTCP(CFG.IP_LASER, CFG.PORT_LASER, r);

    case 'freeMove'
        p = input("Enter the serial port E.g.('COM5' or CFG.PORT_TWIN): ");
        i = input("Enter the motor index 1-4 E.g.(1 or CFG.XAXIS_VXM): ");
        d = input("Enter the non-negative int dist in steps E.g.(500 or 10/CFG.STEPSIZE): ");
        freeMove(p, i, d);

    case 'freeVXMCMD'
        p = input("Enter the serial port E.g.('COM5' or CFG.PORT_TWIN): ");
        i = input("Enter the cmd string E.g.('F, C, I2M 400, R' or sweepRoller()): ");
        freeVXMCMD(p, i);

    case 'printerHome'
        printerHome();

    otherwise
        disp("Unknown command. Ending program.");
    end

case 'send'
    warning("\n%s", ...
        "Please make sure the interconnect is not plugged in if you are just testing.", ...
        "I highly suggest you at least skim through the .toml file before beginning to send commands.", ... 
        "Stay safe.", ...
        "   ~Aaron");
    prompt = sprintf("%s\n", ...
        "Enter location to .toml file", ...
        "   Example: './testFiles/basics.toml'");
    i = input(prompt);
    sendCMDs(i);

otherwise
    disp("Unknown command. Ending program.");
end
