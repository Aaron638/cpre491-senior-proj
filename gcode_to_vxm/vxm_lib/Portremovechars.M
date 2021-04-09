function P = PortRemoveChars(StringToRemove)
    PortRemoveChars = calllib('VxmDriver', 'RemoveFromPort', StringToRemove)
end