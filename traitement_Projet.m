%%
% Début du projet 
% Traitement du signal
% Groupe 1: Thomas Chimbault, Joseph Beasse
% Groupe 2: Paul Chaumont, Tristan Gonçalves

%%

% Lecture de la vidéo
vidObj = VideoReader("video_projet.mp4");
vidObj.CurrentTime =0;
currAxes = axes;
vidFrame = readFrame(vidObj);

% Affichage première frame
figure, imshow(vidFrame);
currAxes.Visible = 'off';

% Récupération des coins
[ginputX,ginputY]=ginput(4);


% Définition des constantes
sigmaG = 2;
sigmaC1 = 3;
sigmaC2 = 5;

% Passage en niveau de gris de l'image extraite en rgb/pixel
newImage = rgb2gray(vidFrame);

% Application du détecteur de Harris multiEchelle
thImage = Harris(sigmaG,sigmaC1,sigmaC2,newImage);

% Affichage du résultat
figure, imshow(thImage,[-1e5 1e5])
colormap(flipud(gray(256)))








% Fonctions

function D = Harris(sigmaG,sigmaC1,sigmaC2,image)
    
    % Initialisation

    [X,Y] = meshgrid(-6:6);

    % POUR D1

    % Calcul de la Gausienne verticale et horizontale
    Gx=-X.*exp(-(X.^2+Y.^2)/(2*pi*sigmaG^4));
    Gy=-Y.*exp(-(X.^2+Y.^2)/(2*pi*sigmaG^4));
    G1= exp(-(X.^2+Y.^2)/(2*pi*sigmaC1^2));

    % Normalisation gausiennes
    Gx= Gx/(sum(sum(-X.*Gx)));
    Gy= Gy/(sum(sum(-Y.*Gy)));
    G1 = G1/(sum(sum(G1)));

    % Calcul du gradient Ix, et Iy en tout point
    Ix=conv2(image,Gx,'same');
    Iy=conv2(image,Gy,'same');
    % Calcul de l'ensemble des covariances 
    Cxx1 =conv2((Ix.*Ix),G1);
    Cyy1=conv2((Iy.*Iy),G1);
    Cxy1=conv2((Ix.*Iy),G1);
    
    % POUR D2

    % Calcul de la Gausienne verticale et horizontale
    G2= exp(-(X.^2+Y.^2)/(2*pi*sigmaC2^2));

    % Normalisation gausiennes
    G2 = G2/(sum(sum(G2)));

    % Calcul de l'ensemble des covariances 
    Cxx2=conv2((Ix.*Ix),G2);
    Cyy2=conv2((Iy.*Iy),G2);
    Cxy2=conv2((Ix.*Iy),G2);


    % Calcul de détecteur de Harris
    D1 = Cxx1.*Cyy1 -Cxy1.*Cxy1 - 0.05.*(Cxx1+Cyy1).^2;
    D2 = Cxx2.*Cyy2 -Cxy2.*Cxy2 - 0.05.*(Cxx2+Cyy2).^2;
    D = min(D1*norm(D2),norm(D1)*D2);
    


end

