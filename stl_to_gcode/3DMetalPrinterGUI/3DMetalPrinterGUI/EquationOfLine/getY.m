function [y] = getY(x, vertical, slope, b)
if (vertical == true)
    y = 0;
else
    y = (slope * x) + b;
end
  
end

