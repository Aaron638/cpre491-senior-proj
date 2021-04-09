% Executes the instructions in printerActions.txt by sending commands to the controllers.
% Uses the Velmex provided Matlab driver to interface with COM ports.

function startPrint()

    % Read file line by line as a string array
    fileData = readlines("printerActions.txt");
    disp("Reading printerActions.txt");

    LoadDriver
    DriverTerminalShowState(1, 0)   %Show Terminal on Desktop

    for i = 1:size(fileData)

        curLine = fileData(i);
        disp(compose("Line [%d]: ", i) + curLine);

        % Ignore invalid lines
        if strlength(curLine) < 5
            continue;
        end

        cmd = extractAfter(curLine, 5);
        disp(cmd);

        if startsWith(curLine, 'roll')
            PortOpen(2, 9600);   %Open Com2 at 9600 Baud
            PortOpen(3, 9600);   %Open Com3 at 9600 Baud
            PortSendCommands(cmd);

        elseif startsWith(curLine, 'pbed')
            PortOpen(1, 9600);   %Open Com1 at 9600 Baud
            PortSendCommands(cmd);


        elseif startsWith(curLine, 'lasr')
            continue;
        else
            continue;
        
        end

        PortWaitForChar('^', 0);     %Halt program until VXM sends back a "^" indicating that it has completed its program
        PortClose();

    end

    % DriverTerminalShowState(0, 0)   %Hide Terminal
    % ReleaseDriver();
    
end
