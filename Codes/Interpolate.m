function y = Interpolate(x1, x2, y1, y2, x)
    y = ((y2 - y1)*(x - x1)/(x2 - x1)) + y1;
end
