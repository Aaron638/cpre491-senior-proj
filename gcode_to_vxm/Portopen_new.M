function P = PortOpen(PortNumber, BaudRate)
    PortOpen = calllib('VxmDriver', 'OpenPort', PortNumber, BaudRate)
end