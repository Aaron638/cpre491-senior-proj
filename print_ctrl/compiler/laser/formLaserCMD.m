% Temporarily deprecated
% function cmd = formLaserCMD()

%     startByte = uint8(0x1B);
%     stopByte = uint8(0x0D);

    % filetext = fileread("./print_ctrl/compiler/laser/laserCMDs.json");
    % cmdDict = jsondecode(filetext);

    % idx = 0;
    % Command ID to uint8:
    % cmdID = uint8(hex2dec(cmdDict(idx).id));

    % inParamSize = cmdDict(idx).inParamSize;
    % outParamSize = cmdDict(idx).outParamSize; 

    % Does cmdDict(2) have the id 0x01? == true
    % strcmp(cmdDict(2).id, "0x01");

    %%%
    % {"0x00": "Command Not Supported"},
    % {"0x01": "CRC Error"},
    % {"0x02": "No Start Byte"},
    % {"0x03": "No Stop Byte"},
    % {"0x04": "Incorrect No Data Bytes"},
    % {"0x05": "Overrun Error"},
    % {"0x06": "Parity Error"},
    % {"0x07": "Framing Error"},
    % {"0x08": "Rx Buffer Overflow"},
    % {"0x09": "Command Time Out"},
    % {"0x0F": "Unknown Error"}
    %%%

% end