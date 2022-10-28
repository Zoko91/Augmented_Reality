
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
vidFrame = readFrame(vidObj);

hold on
I = imread("metro.jpg");
image(vidFrame);
 
image(I)%,'XData',X(1),'YData',Y(1))
hold off
%%
% Read video frames until available
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
    image(vidFrame, 'Parent', currAxes);
    %currAxes.Visible = 'off';
    pause(1/vidObj.FrameRate);
    %[X,Y] = ginput(4);
end


% Read every 5th video frame from the start of the video
for cnt = 1:5:vidObj.NumFrames
    vidFrame = read(vidObj, cnt);
end
%%
A = imread("lena.bmp");
clear B;
[h, w] = size(A);
%B = zeros(h, w);
c = cos(-20*pi/180); 
s = sin(-20*pi/180);
%H = [1 0 -w/2; 0 1 -h/2; 0 0 1];
%H = [c -s -w/2; s c -h/2; 0 0 1]*H;
%H = [1 0 w/2; 0 1 h/2; 0 0 1]*H;
%H = [1 0 20; 0 1 20; -0.001 0.002 1];
Center =[round(h/2); round(w/2); 1];
for y2 = 1:h
for x2 = 1:w
M2 = [x2; y2; 1];
%M1 = H*3*(M2-Center)+Center;
M1 = H*0.001*(M2);
%M1 = H*M2;
x1 = round(M1(1)/M1(3));
y1 = round(M1(2)/M1(3));
if ( x1 >= 1 && x1 <= w && y1 >= 1 && y1 <= h)
B(y2, x2) = A(y1, x1);
end
end
end

%%
%%
I = imread("metro.jpg");
vidObj = VideoReader('video_projet.mp4');
%vidFrame = readFrame(vidObj);
vidFrame = read(vidObj, 300);
image(vidFrame);

[h1,w1,d1]=size(I);
[h2, w2, d2] = size(vidFrame);
% [X,Y] = ginput(4);



x=[0;w1;w1;0];
y=[0;0;h1;h1];

A=[x(1) y(1) 1 0 0 0 -x(1)*X(1) -y(1)*X(1);
    x(2) y(2) 1 0 0 0 -x(2)*X(2) -y(2)*X(2);
    x(3) y(3) 1 0 0 0 -x(3)*X(3) -y(3)*X(3);
    x(4) y(4) 1 0 0 0 -x(4)*X(4) -y(4)*X(4);
    0 0 0 x(1) y(1) 1 -x(1)*Y(1) -y(1)*Y(1);
    0 0 0 x(2) y(2) 1 -x(2)*Y(2) -y(2)*Y(2);
    0 0 0 x(3) y(3) 1 -x(3)*Y(3) -y(3)*Y(3);
    0 0 0 x(4) y(4) 1 -x(4)*Y(4) -y(4)*Y(4)];  

B=[X(1);X(2);X(3);X(4);Y(1);Y(2);Y(3);Y(4)];
h=A\B;
H=[h(1) h(2) h(3);
   h(4) h(5) h(6);
   h(7) h(8) 1];

% [XMain, YMain] = ginput(4);
% for i=1:4
%      M2 = [XMain(i); YMain(i); 1];
%      M1 = H\M2;
%      XMain(i) = round(M1(1)/M1(3));
%      YMain(i) = round(M1(2)/M1(3));
%  end

% couleurBleueMax = [127, 173, 188];
% couleurBleueMin = [104, 142, 154];
% couleurBleueMin = [91, 125, 130];
couleurBleue=[116,158,171];
couleurBleue=double(couleurBleue)/255;
couleurBleueHSV=rgb2hsv(couleurBleue);
deltaAcceptable=0.35;

for y2 = 1:h2
    for x2 = 1:w2
    M2 = [x2; y2; 1];
    M1 = H\M2;
    x1 = round(M1(1)/M1(3));
    y1 = round(M1(2)/M1(3));
    estDansImage = x1 >= 1 && x1 <= w1 && y1 >= 1 && y1 <= h1;
        if (estDansImage)
            estDansRectangle= x1 >= XMain(2) && y1 >= YMain(1) && y1 <= YMain(3);
%             estBleu = vidFrame(y2,x2,1) <= couleurBleueMax(1)  && vidFrame(y2,x2,1) >= couleurBleueMin(1) ... 
%                 && vidFrame(y2,x2,2) <= couleurBleueMax(2) && vidFrame(y2,x2,2) >= couleurBleueMin(2) ...
%                 && vidFrame(y2,x2,3) <= couleurBleueMax(3) && vidFrame(y2,x2,3) >= couleurBleueMin(3); 

            vidFrameHSV=rgb2hsv([double(vidFrame(y2,x2,1))/255,double(vidFrame(y2,x2,2))/255,double(vidFrame(y2,x2,3))/255]);
            estBleu= vidFrameHSV(1)>=couleurBleueHSV(1)*(1-deltaAcceptable)  ...
                     && vidFrameHSV(1)<=couleurBleueHSV(1)*(1+deltaAcceptable);

            if(estDansRectangle && estBleu==0)
                vidFrame(y2,x2,1) = vidFrame(y2,x2,1);
                vidFrame(y2,x2,2) = vidFrame(y2,x2,2);
                vidFrame(y2,x2,3) = vidFrame(y2,x2,3);
            else
                vidFrame(y2,x2,1) = I(y1,x1,1);
                vidFrame(y2,x2,2) = I(y1,x1,2);
                vidFrame(y2,x2,3) = I(y1,x1,3);
            end
        end
    end
end

image(vidFrame);

% image(B,"XData",X(1),"YData",Y(1));



