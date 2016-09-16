%% Question 2

%% Demo of Linear Contrast Stretching
tic;
%     outputImage = round( ((inputImage - min1)*255)/(max1- min1));
myLinearContrastStretching;
toc;
%% Demo of Histogram Equalisation (HE)
tic;
myHE;
toc;
%% Demo of AHE
tic;
myAHE(100);
toc;
%% Demo of CLAHE
tic;
myCLAHE(0.6, 100);
toc;
