function [] = ToString(point, slope)
    fprintf("%f,%f,%f,%f\n", point.x,point.y, (point.x+1), (point.y+slope));
end

