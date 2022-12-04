function Seg=ConvertModelToSeg(points,connectivityList)
    [n,~]=size(connectivityList);
    Seg=[];
    for i=1:n
        firstPointid=connectivityList(i,1);
        secondPointid=connectivityList(i,2);
        thirdPointid=connectivityList(i,3);
        Seg=[Seg;...
            points(firstPointid,:);points(secondPointid,:);...
            points(secondPointid,:);points(thirdPointid,:);...
            points(thirdPointid,:);points(firstPointid,:)];
    end
end