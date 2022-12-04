function newImage=Add3D(ancienneImage,X,Y,Seg)

alpha=2;
whiteSquareOffset=(double(2)/8)*0.2;
x=[0 1 1 0 0.125 0.5+whiteSquareOffset]*sqrt(2);
y=[0 0 1 1 0.6 0.5-whiteSquareOffset];
z=[0 0 0 0 0.2 0.3];
P=GetP(x,y,z,X,Y);
newImage=ancienneImage;
for i=1:2:length(Seg)-1
    premierVecteur = [Seg(i,1);Seg(i,2);Seg(i,3);1];
    deuxiemeVecteur= [Seg(i+1,1);Seg(i+1,2);Seg(i+1,3);1];

    vecteurDepart = P*premierVecteur;
    vecteurDepartx = round(vecteurDepart(1)/vecteurDepart(3));
    vecteurDeparty = round(vecteurDepart(2)/vecteurDepart(3));

    vecteurArrive = P*deuxiemeVecteur;
    vecteurArrivex = round(vecteurArrive(1)/vecteurArrive(3));
    vecteurArrivey = round(vecteurArrive(2)/vecteurArrive(3));

    X1=[vecteurDepartx vecteurDeparty];
    X2=[vecteurArrivex vecteurArrivey];
    
    newImage=DrawLineFat(X1,X2,newImage,alpha);
end