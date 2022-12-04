% Récupérer la liste des points d'un segment fin
function I = DrawSeg(x1,x2,I,alpha)
    [h,w,~]=size(I);
    % Nombre de points à tracer par segment
    L = floor(alpha*sqrt((x2(1)-x1(1))^2+(x2(2)-x1(1))^2));

    % CoordX à tracer par segment
    %seg1 = zeros(L,2);
    for i=1:L
        %seg1(i,1)=round(x1(1)+i*(x2(1)-x1(1))/(L-1));
        %seg1(i,2)=round(x1(2)+i*(x2(2)-x1(2))/(L-1));
        x=round(x1(1)+i*(x2(1)-x1(1))/(L-1));
        y=round(x1(2)+i*(x2(2)-x1(2))/(L-1));

        estDansImage=x>1&&x<w&&y>1&&y<h;
        %[x,y]
        if (estDansImage)

            I(y,x,1)=244;
            I(y,x,2)=244;
            I(y,x,3)=221;
        end
    end
end