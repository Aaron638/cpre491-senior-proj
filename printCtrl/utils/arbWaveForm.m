% ARBWAVEFORM
% Note: Use visa instead of visadev
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
