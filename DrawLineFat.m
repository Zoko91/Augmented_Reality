% Tracé d'un segment épais -> plusieurs segments fins
function I = DrawLineFat(X1,X2,I,alpha)

    dx = X2(1) - X1(1);
    dy = X2(2) - X1(2);
    val = sqrt(dx*dx+dy*dy);

    nX = -dy/val;
    nY = dx/val;


    for j=-1:1
        x1 = [(X1(1) + j*nX),(X1(2) + j*nY)];
        x2 = [(X2(1) + j*nX),(X2(2) + j*nY)];

        I = DrawSeg(x1, x2,I,alpha);
    end
end