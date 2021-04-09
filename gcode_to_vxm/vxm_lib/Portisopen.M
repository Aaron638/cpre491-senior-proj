function P = PortIsOpen
    PortIsOpen = calllib('VxmDriver', 'IsPortOpen')
end