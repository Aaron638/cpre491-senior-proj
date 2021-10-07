% Utility Function to move the axis and bed motors to the defined zero or home position.
% Commands are hard coded for general use without the compiler.
% 
function printerHome()

% Zero Axis
device = serialport("COM5", 9600);
flush(device)
string = compose("F, C, S1M5400, S2M5400, S3M5400, S4M5400, I1M-0, I2M0, I3M-0, I4M0, R,\r");
write(device, string, "uint8");
response = "";
while response ~= '^'
    response = read(device, 1, "uint8");
end

% Adjust Axis
string = compose("F, C, I2M-1800, I3M13000, R,\r");
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
string = compose("F, C, S1M3000, S2M3000, I1M0, I2M-0, R,\r");
write(device, string, "uint8");
response = "";
while response ~= '^'
    response = read(device, 1, "uint8");
end

% Adjust Beds
string = compose("F, C, I1M-1800, R,\r");
write(device, string, "uint8");
response = "";
while response ~= '^'
    response = read(device, 1, "uint8");
end
flush(device)
delete(device)

end

