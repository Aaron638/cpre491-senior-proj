function P = PortWaitForCharWithMotorPosition(CharToWaitFor, MotorNumber, ReportToWindowHwnd, TimeOutTime)
    PortWaitForCharWithMotorPosition = calllib('VxmDriver', 'WaitForCharWithMotorPosition', CharToWaitFor, MotorNumber, ReportToWindowHwnd, TimeOutTime)
end