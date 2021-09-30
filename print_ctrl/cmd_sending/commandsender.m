% Executes the instructions in printerActions.txt by sending commands to the controllers.

function startPrint()

    % Read file line by line as a string array
    fileData = readlines("printerActions.txt");
    disp("Reading printerActions.txt");

    for i = 1:size(fileData)

        curLine = fileData(i);
        disp(compose("Line [%d]: ", i) + curLine);


    end
    
end
