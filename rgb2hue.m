function [H] = rgb2hue(RGB)
    isColorAnInteger=RGB(1)>2;
    if(isColorAnInteger)
        RGB=double(RGB)/255;
    end
    Cmax = max(RGB);
    Cmin = min(RGB);
    delta = Cmax - Cmin;
    
    R = RGB(1);
    G = RGB(2);
    B = RGB(3);

    if delta==0
        H = 0;
    elseif Cmax == R
        H = 60*(mod((G-B)/delta,6));
    elseif Cmax == G
        H = 60*(((B-R)/delta) + 2);
    elseif Cmax == B
        H = 60*(((R-G)/delta) + 4);
    end
end
