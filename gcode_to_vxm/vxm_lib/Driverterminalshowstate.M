long function D = DriverTerminalShowState(double StateToShow, ParentHwnd)
    switch StateToShow
        case 0
        calllib('VxmDriver', 'HideTerminalSimple')
        case 1
        calllib('VxmDriver', 'ShowTerminalSimple', ParentHwnd)
    end            
end