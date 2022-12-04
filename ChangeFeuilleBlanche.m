function newImage=ChangeFeuilleBlanche(ancienneImage,imageFeuille,X,Y,XMain,YMain)
[h1,w1,~]=size(imageFeuille);
[h2, w2, ~] = size(ancienneImage);

x=[0;w1;w1;0];
y=[0;0;h1;h1];

H=GetH(X,Y,x,y);

newImage=ancienneImage;
for y2 = 1:h2
    for x2 = 1:w2
    M2 = [x2; y2; 1];
    M1 = H*M2;
    x1 = round(M1(1)/M1(3));
    y1 = round(M1(2)/M1(3));

    estDansImage = x1 >= 1 && x1 <= w1 && y1 >= 1 && y1 <= h1;
    estDansRectangle = x1 >= XMain(2) && y1 >= YMain(1) && y1 <= YMain(3);
    estBleu=EstBleu([ancienneImage(y2,x2,1),ancienneImage(y2,x2,2),ancienneImage(y2,x2,3)]);
    canWeEditPoint=estDansImage&&(estBleu||~estDansRectangle);

    if (canWeEditPoint)
        newImage(y2,x2,1) = imageFeuille(y1,x1,1);
        newImage(y2,x2,2) = imageFeuille(y1,x1,2);
        newImage(y2,x2,3) = imageFeuille(y1,x1,3);
    end
    end
end
end