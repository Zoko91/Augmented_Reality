%%
% Début du projet 
% Traitement du signal
% Groupe 1: Thomas Chimbault, Joseph Beasse
% Groupe 2: Paul Chaumont, Tristan Gonçalves


clear
close all

% Définition des constantes
n = 6;
sigmaG = 2;
sigmaC1 = 3;
sigmaC2 = 5;
fenetreW = 37;

% Lecture de la vidéo
vidObj = VideoReader("video_projet.mp4");
vidObj.CurrentTime =0;
currAxes = axes;

% Lecture 1ère frame pour récupérer les n points
vidFrame = readFrame(vidObj);
imshow(vidFrame);

% Récupération des n coins
coordonnesGInput = ginput(n);
coordInit = Initialisation(coordonnesGInput,n);
 
% Récupération des coordonnées des coins
coord = RecupCoins(vidObj,sigmaG,sigmaC1,sigmaC2,n,coordInit);

% Points que l'on envoie au groupe II
x = coord(1:vidObj.NumFrames,1:2:end);
y = coord(1:vidObj.NumFrames,2:2:end);

% Fin algo
%



% Fonctions

function D = Harris(sigmaG,sigmaC1,sigmaC2,image)
    
    % Initialisation
    
    [X1,Y1] = meshgrid(ceil(-sigmaC1*3:sigmaC1*3),ceil(-sigmaC1*3:sigmaC1*3));
    [X2,Y2] = meshgrid(ceil(-sigmaC2*3:sigmaC2*3),ceil(-sigmaC2*3:sigmaC2*3));
    [XG,YG] = meshgrid(ceil(-sigmaG*3:sigmaG*3),ceil(-sigmaG*3:sigmaG*3));

    % POUR D1

    % Calcul de la Gausienne verticale et horizontale
    Gx=-XG.*exp(-(XG.^2+YG.^2)/(2*sigmaG^2))/(2*pi*sigmaG^4);
    Gy=-YG.*exp(-(XG.^2+YG.^2)/(2*sigmaG^2))/(2*pi*sigmaG^4);

    G1= exp(-(X1.^2+Y1.^2)/(2*pi*sigmaC1^2))/(2*pi*sigmaC1^2);

    % Normalisation gausiennes
    Gx= Gx/(sum(sum(-XG.*Gx)));
    Gy= Gy/(sum(sum(-YG.*Gy)));
    G1 = G1/(sum(sum(G1)));

    % Calcul du gradient Ix, et Iy en tout point
    Ix=conv2(image,Gx,'same');
    Iy=conv2(image,Gy,'same');
    % Calcul de l'ensemble des covariances 
    Cxx1 =conv2((Ix.*Ix),G1,'same');
    Cyy1=conv2((Iy.*Iy),G1,'same');
    Cxy1=conv2((Ix.*Iy),G1,'same');
    
    % POUR D2

    % Calcul de la Gausienne verticale et horizontale
    G2= exp(-(X2.^2+Y2.^2)/(2*pi*sigmaC2^2))/(2*pi*sigmaC2^2);

    % Normalisation gausiennes
    G2 = G2/(sum(sum(G2)));

    % Calcul de l'ensemble des covariances 
    Cxx2=conv2((Ix.*Ix),G2,'same');
    Cyy2=conv2((Iy.*Iy),G2,'same');
    Cxy2=conv2((Ix.*Iy),G2,'same');


    % Calcul de détecteur de Harris
    D1 = Cxx1.*Cyy1 -Cxy1.*Cxy1 - 0.05.*(Cxx1+Cyy1).^2;
    D2 = Cxx2.*Cyy2 -Cxy2.*Cxy2 - 0.05.*(Cxx2+Cyy2).^2;
    D = min(D1*norm(D2),norm(D1)*D2);
    


end

function coordMax = coordMaxCalcul(coordonnes,thImage)

    maxi = -1e-30;
    for c = coordonnes(1):coordonnes(1)+37
        for d = coordonnes(2):coordonnes(2)+37
         
            if thImage(d,c)>maxi
                maxi = max(maxi,thImage(d,c));
                coordMax = [c d];
            end
        end
    end
end

function maxList = CreateList (coordonnes,thImage,n)
        maxList = zeros(1,2*n);
        % Initialise une liste de maximum vide
    for l = 1:n
        % Parcours les 6 points
        coords = coordMaxCalcul(coordonnes((2*l-1):(2*l)),thImage);
        % Appelle la fonction coordmaxcalcul sur les 4 points de la liste
        maxList(2*l-1) = coords(1);
        maxList(2*l) = coords(2);
    end
end

function coordInit = Initialisation(coordonnesGInput,n)
    coordInit = zeros(1,2*n);
    for i = 1:n
    coordInit(2*i-1) = coordonnesGInput(i,1);
    coordInit(2*i) = coordonnesGInput(i,2);
    end
end

function coord = RecupCoins(vidObj,sigmaG,sigmaC1,sigmaC2,n,coordInit)
    coord = zeros(vidObj.NumFrames,2*n);
    for i = 1:vidObj.NumFrames
        i
        % Extraction de la frame
        vidFrame = read(vidObj,i);

        % Passage en luminance  de l'image extraite en rgb/pixel
        newImage = 0.299*vidFrame(:,:,1) + 0.587*vidFrame(:,:,2)+0.114*vidFrame(:,:,3);

        % Application du détecteur de Harris multiEchelle
        thImage = Harris(sigmaG,sigmaC1,sigmaC2,newImage);

        if i == 1
        % Fenetrage
            coordInit = coordInit - 19 ;
            coordInit = uint16(coordInit);
            coinsCord = CreateList(coordInit,thImage,n);
            coord(i, :) = coinsCord;
    
        elseif i == 2
            % Deuxième itération
            coordSecondInit = coord(i-1, :)-19;
            coordSecondInit = CreateList(coordSecondInit,thImage,n);
            coord(i, :) = coordSecondInit;
        else
            % Toutes les autres itérations
            coordInitNext = zeros(8);
            for p = 1:n
                coordInitNext(2*p-1) = uint16(coord(i-1,2*p-1)+(coord(i-1,2*p-1)-coord(i-2,2*p-1))/2);
                coordInitNext(2*p) = uint16(coord(i-1,2*p)+(coord(i-1,2*p)-coord(i-2,2*p))/2);
            end
            coordInitNext = coordInitNext-19;
            coordInitNext = CreateList(coordInitNext,thImage,n);
            coord(i, :) = coordInitNext;
        end
    end
end