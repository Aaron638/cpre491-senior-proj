function [vertical, point, slope, b] = setPointSlopeForm(point, slope)
    vertical = false;
    point.x = point.x;
    point.y = point.y;
    slope = slope;
    b = point.y - (slope * point.x);
end

