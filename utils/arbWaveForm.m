%{ 
ARBWAVEFORM
Utility script that turns on the function generator output for 5 seconds, then turns it back off.
Used for confirming that the function generator works.
Make sure the laser interconnect is unplugged if the chamber is still open.

The version of Matlab running on the machine at ASC2 uses **Matlab2020b** with the **Instrument Control Toolbox**.

Matlab2021b deprecated the `visa` command, and replaced it with `visadev`. 
If you plan on updating the machine past 2020b, please review this: 
[https://www.mathworks.com/help/instrument/transition-your-code-to-visadev-interface.html]

%}
% Note: Use visa instead of visadev for Matlab2020b
% visausb = visadev("USB0::0x0957::0x0407::MY44034072::0::INSTR");
obj = visa('keysight', 'USB::0x0957::0x0407::MY44034072::0::INSTR');
h = icdevice('agilent_33220a.mdd', obj);
connect(h);
devicereset(h);

% TURN ON OUTPUT
set(h, 'Output', 'on');

pause(5);

set(h, 'Output', 'off');

disconnect(h);
delete(h);
delete(obj);
