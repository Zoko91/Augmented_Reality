function res=EstBleu(Color)
    couleurBleue=[116,158,171];
    couleurBleueHSV=rgb2hue(couleurBleue);
    deltaAcceptable=0.35;
    ColorHSV=rgb2hue(Color);
    res= ColorHSV>=couleurBleueHSV*(1-deltaAcceptable)  ...
                     && ColorHSV<=couleurBleueHSV*(1+deltaAcceptable);
end