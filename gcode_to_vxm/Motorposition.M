function M = MotorPosition(MotorNumber)
    MotorPosition = calllib('VxmDriver', 'GetMotorPosition', MotorNumber)
end