% Utility function that extracts numbers from a string using regex.
% https://www.mathworks.com/matlabcentral/answers/44049-extract-numbers-from-mixed-string
% 
function numArray = getNumsFromStr(str)
    str1 = regexprep(str,'[,;=]', ' ');
    str2 = regexprep(regexprep(str1,'[^- 0-9.eE(,)/]',''), ' \D* ',' ');
    str3 = regexprep(str2, {'\.\s','\E\s','\e\s','\s\E','\s\e'},' ');
    numArray = str2num(str3);
end