function P = PortSendCommands(CommandToSend)
    PortSendCommands = calllib('VxmDriver', 'DriverSendToPort', CommandToSend)
end