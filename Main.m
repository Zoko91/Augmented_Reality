
%% VideoReader 
% Construct a multimedia reader object associated with file
% 'video_projet.mp4'.
vidObj = VideoReader('video_projet.mp4');

% Specify that reading should start at 0.5 seconds from the
% beginning.
vidObj.CurrentTime = 0.5;

% Create an axes
currAxes = axes;

%imshow(vidFrame)
%vidFrame = readFrame(vidObj);
%image(vidFrame)
%%
% Read video frames until available
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
    image(vidFrame)%, 'Parent', currAxes);
    %currAxes.Visible = 'off';
    pause(1/vidObj.FrameRate);
    %[X,Y] = ginput(4);
end


% Read every 5th video frame from the start of the video
for cnt = 1:5:vidObj.NumFrames
    vidFrame = read(vidObj, cnt);
end

%%

load('cordonnees.mat');


%%
load('cordonnees.mat', 'coord');
XEntier = coord(1:324,1:2:end);
YEntier = coord(1:324,2:2:end);

% Création de l'objet VideoWriter et ouverture
v = VideoWriter("videoTP");
open(v);

lune = imread("lune.jpeg");
vidObj = VideoReader('video_projet.mp4');
frameIndex=100;
vidFrameForHand = read(vidObj, frameIndex);
image(vidFrameForHand);
vidObj.CurrentTime = 0;

firstX = XEntier(frameIndex,1:6);
firstY = YEntier(frameIndex,1:6);

if (~exist('XMain','var')||~exist('YMain','var'))
    [XMain, YMain] = SelectCadreMain(lune,firstX,firstY);
end

model = stlread("soucoupe5.stl");
Seg=ConvertModelToSeg([0.5 0.5 0]+(model.Points)/30,model.ConnectivityList);

for i=1:324
    X = XEntier(i,1:6);
    Y = YEntier(i,1:6);  
    vidFrame = read(vidObj, i);

    %imageWithPaperSheetChanged=ChangeFeuilleBlanche(vidFrame,lune,X,Y,XMain,YMain);
    vidFrame=Add3D(ChangeFeuilleBlanche(vidFrame,lune,X,Y,XMain,YMain),X,Y,Seg);
    writeVideo(v, vidFrame);
    i
end

% Fermeture de l'objet VideoWriter une fois la vidéo créée
close(v);

%%
IDepart=imread("lune.jpg");
IArrivee=DrawLine(IDepart,20,20,600,600);
image(IArrivee);
%%
%code pour 1 frame (celle d'indice 50 là)

%height=0.5;
%Seg=[0.5 0.5 height;1 1 0;
%    0.5 0.5 height;0 1 0;
%    0.5 0.5 height;1 0 0;
%    0.5 0.5 height;0 0 0;
%    ]; 

model = stlread("soucoupe5.stl");
Seg=ConvertModelToSeg([0.5 0.5 0]+(model.Points)/30,model.ConnectivityList);

lune = imread("lune.jpeg");
vidObj = VideoReader('video_projet.mp4');

frame = 200;

vidFrame = read(vidObj, frame);
X = XEntier(frame,1:6);
Y = YEntier(frame,1:6);  


image(vidFrame);
if (~exist('X','var')||~exist('Y','var'))
    [X,Y] = ginput(6);
end
if (~exist('XMain','var')||~exist('YMain','var'))
    [XMain, YMain] = SelectCadreMain(lune,X,Y);
end

imageWithPaperSheetChanged=ChangeFeuilleBlanche(vidFrame,lune,X,Y,XMain,YMain);
finalImage=Add3D(imageWithPaperSheetChanged,X,Y,Seg);
image(finalImage);

% image(B,"XData",X(1),"YData",Y(1));



