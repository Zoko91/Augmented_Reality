function H = GetH(x,y,X,Y)
nombreDePoint=min(length(x),length(X));
A=[];
B=[];
for i=1:nombreDePoint
    vector=[x(i) y(i) 1 0 0 0 -x(i)*X(i) -y(i)*X(i);
0 0 0 x(i) y(i) 1 -x(i)*Y(i) -y(i)*Y(i)];
    A=cat(1,A,vector);

    v2=[X(i);Y(i)];
    B=cat(1,B,v2);
end

h=A\B; 
H=[h(1) h(2) h(3);
   h(4) h(5) h(6);
   h(7) h(8)  1 ];
end