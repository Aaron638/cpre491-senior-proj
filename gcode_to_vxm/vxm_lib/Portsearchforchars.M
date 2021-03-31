function P = PortSearchForChars(CharsToFind)
    PortSearchForChars = calllib('VxmDriver', 'SearchForChars', CharsToFind)
end