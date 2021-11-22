function res = getLaserError(response)

    respArr = split(response);
    % respArr(1)

    % TOODO:
    % Rename to checkResponse
    % CRC check the prev bits by summing them
    % if theres an error, return the error
    err;

    switch err
    case 0x00
        res = "Command not supported";
    case 0x01
        res = "CRC error";
    case 0x02
        res = "No Start byte";
    case 0x03
        res = "No Stop byte";
    case 0x04
        res = "Incorrect No Data Bytes";
    case 0x05
        res = "Overrun error";
    case 0x06
        res = "Parity error";
    case 0x07
        res = "Framing error";
    case 0x08
        res = "Rx buffer overflow";
    case 0x09
        res = "Command time out";
    otherwise
        res = "Unknown Error";
    end
    
end