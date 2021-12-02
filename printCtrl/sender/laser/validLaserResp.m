% Validates the laser response.
% UNFINISHED: 
%   Parse the response to see what it means.
%   Use bitmapping to map response bits to different meanings.

function validLaserResp(respByteArr)
    numCmdDataBytes = length(respByteArr(2:end-2));
    crc = sum(respByteArr(1:end-1));

    if respByteArr(1) ~= uint8(0x1B)
        error("ERROR: Response start byte is %0X, should be 0x1B.", respByteArr(1));

    elseif respByteArr(2) ~= uint8(numCmdDataBytes)
        error("ERROR: Response start byte is %0X, should be 0x1B.", respByteArr(1));

    elseif respByteArr(3) == uint8(0x0)
        laserError(respByteArr(4));
    
    elseif respByteArr(end-1) ~= uint8(0x0D)
        error("ERROR: Response end byte is %0X, should be 0x0D.", respByteArr(end-1));

    elseif respByteArr(end) ~= uint8(crc)
        error("ERROR: CRC byte is %0X, should be the sum of all the previous bytes %0X.", respByteArr(end), uint8(crc));
    end
end

% This function is here for readability.
function laserError(errcode)
    switch errcode
    case 0x00
        error("ERROR: Command not supported");
    case 0x01
        error("ERROR: CRC error");
    case 0x02
        error("ERROR: No Start byte");
    case 0x03
        error("ERROR: No Stop byte");
    case 0x04
        error("ERROR: Incorrect No Data Bytes");
    case 0x05
        error("ERROR: Overrun error");
    case 0x06
        error("ERROR: Parity error");
    case 0x07
        error("ERROR: Framing error");
    case 0x08
        error("ERROR: Rx buffer overflow");
    case 0x09
        error("ERROR: Command time out");
    otherwise
        error("ERROR: Unknown error");
    end
end