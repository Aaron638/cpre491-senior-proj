function P = PortWaitForChar(CharToWaitFor, TimeOutTime)
    PortWaitForChar = calllib('VxmDriver', 'WaitForChar', CharToWaitFor, TimeOutTime)
end