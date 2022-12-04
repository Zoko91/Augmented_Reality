function P = GetP(x,y,z,X,Y)
nombreDePoint=length(x);
A=[];
B=[];
for i=1:nombreDePoint
    vector=[
        x(i) y(i) z(i) 1 0 0 0 0 -x(i)*X(i) -y(i)*X(i) -z(i)*X(i);
        0 0 0 0 x(i) y(i) z(i) 1 -x(i)*Y(i) -y(i)*Y(i) -z(i)*X(i)];
    A=cat(1,A,vector);

    v2=[X(i);Y(i)];
    B=cat(1,B,v2);
end

p=A\B; 
P=[p(1) p(2) p(3) p(4);
   p(5) p(6) p(7) p(8);
   p(9) p(10) p(11) 1];
end