function  myLinearContrastStretching()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
f = imread('data\canyon.png');
f1 = im2double(f); % Cast to double.
channelCount = size(f1 ,3);
%f3 = zeros(size(f1,1) ,size(f1, 2), size(f1, 3));
for i = 1:channelCount
    fmatrix = f1(:,:,i);
    min1 = min(min(fmatrix));
    max1 = max(max(fmatrix));
    f2 = round( ((fmatrix - min1)*255)/(max1- min1));
    f3(:,:,i) = uint8(255 * mat2gray(f2));
end
%{
subplot(1,2,1);
imshow(f);
subplot(1,2,2);
imshow(f1);
set(gcf,'Position',get(0,'ScreenSize'));%maximize figure
%}


myNumOfColors = 200;
myColorScale = [[0:1/(myNumOfColors - 1):1]',[0:1/(myNumOfColors - 1):1]' , [0:1/(myNumOfColors - 1):1]' ];

for i=1:channelCount
    subplot(channelCount,2,(2*i) -1);
    imagesc (f(:, :, i)); % phantom is a popular test image
    if (channelCount == 1)
        title('Original');
    elseif (i == 1)
        title('Original R');
    elseif (i == 2)
        title('Original G');
    else
        title('Original B');
    end
    colormap (myColorScale);
    colormap (jet);
    daspect ([1 1 1]);
    axis tight;
    colorbar
    subplot(channelCount,2,2*i);
    imagesc (f3(:,:,i)); % phantom is a popular test image
    if (channelCount == 1)
        title('Contrast-streched');
    elseif (i == 1)
        title('Contrast-streched R');
    elseif (i == 2)
        title('Contrast-streched G');
    else
        title('Contrast-streched B');
    end
    colormap (myColorScale);
    colormap (jet);
    daspect ([1 1 1]);
    axis tight;
    colorbar
end

set(gcf,'Position',get(0,'ScreenSize'));%maximize figure
imwrite(f3,'images\canyon_LinearContrastStretching.png')
end
