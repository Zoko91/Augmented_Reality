function [XMain,YMain]=SelectCadreMain(imageFeuille,X,Y)
[h1,w1,~]=size(imageFeuille);
x=[0;w1;w1;0];
y=[0;0;h1;h1];

H=GetH(x,y,X,Y);

[XMain, YMain] = ginput(4);
for i=1:4
     M2 = [XMain(i); YMain(i); 1];
     M1 = H\M2;
     XMain(i) = round(M1(1)/M1(3));
     YMain(i) = round(M1(2)/M1(3));
 end
end
