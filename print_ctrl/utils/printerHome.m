% Utility Function to move the axis and bed motors to the defined zero or home position.
% Commands are hard coded for general use without the compiler.
% 
function printerHome()

% Zero Axis
device = serialport("COM5", 9600);
flush(device)
string = compose("F, C, S1 M5400, S2 M5400, S3 M5400, S4 M5400, I1 M-0, I2 M0, I3 M-0, I4 M0, R,\r");
write(device, string, "uint8");
response = "";
while response ~= '^'
    response = read(device, 1, "uint8");
end

% Adjust Axis
string = compose("F, C, I2 M-1800, I3 M13000, R,\r");
write(device, string, "uint8");
response = "";
while response ~= '^'
    response = read(device, 1, "uint8");
end

flush(device)
delete(device)

% Zero Beds
device = serialport("COM11", 9600);
flush(device)
string = compose("F, C, S1 M3000, S2M 3000, I1 M0, I2 M-0, R,\r");
write(device, string, "uint8");
response = "";
while response ~= '^'
    response = read(device, 1, "uint8");
end

% Adjust Beds
string = compose("F, C, I1 M-1800, R,\r");
write(device, string, "uint8");
response = "";
while response ~= '^'
    response = read(device, 1, "uint8");
end
flush(device)
delete(device)

end

