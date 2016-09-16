function myHE()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
image1 = imread('data\canyon.png');	% given image read into matrix image
channelCount = size(image1 ,3);
for l = 1:channelCount
    image = image1(:,:,l);
    frequency = zeros(256, 1);		% frequency  for each value
    probability = zeros(256 ,1);	% probability of each value
    cdf = zeros(256 ,1);			% cdf
    cumFreq = zeros(256,1);
    hmImage = uint8(zeros (size(image ,1),size(image ,2))); 	% intializatiing histogram equalized image

    numPixels = size(image ,1)* size(image , 2);

    rowCount = size(image ,1);
    columnCount = size(image ,2);

    % probability calculation for each value

    for i = 1:rowCount
        for j = 1:columnCount
            v = image(i,j);
            frequency(v + 1) = frequency ( v + 1) + 1;
            probability(v + 1) = probability ( v + 1) + 1/numPixels;
        end
    end

    % cum probability at start
    sum = 0;
    % cumulative distribution of probability calculation 
    % cdfStep to get 
    for i = 1: 256
        sum = sum + frequency(i);
        cumFreq(i) = sum ;
        cdf(i) = cumFreq(i) /numPixels ;  
        cdfStep(i) = round(cdf(i) *255);
    end

    % map
    for i = 1:rowCount
        for j = 1:columnCount
            hmImage(i,j) = cdfStep(image(i,j) +1);
        end
    end

    hmImage1(:, :, l) = hmImage;
end


for i=1:channelCount
    subplot(channelCount,2,(2*i) -1);
    imshow (image1(:, :, i)); % phantom is a popular test image
    if (channelCount == 1)
        title('Original');
    elseif (i == 1)
        title('Original R');
    elseif (i == 2)
        title('Original G');
    else
        title('Original B');
    end
    daspect ([1 1 1]);
    axis tight;
    
    subplot(channelCount,2,2*i);
    imagesc (hmImage1(:,:,i)); % phantom is a popular test image
    if (channelCount == 1)
        title('Histogram Equalised');
    elseif (i == 1)
        title('Histogram Equalised R');
    elseif (i == 2)
        title('Histogram Equalised G');
    else
        title('Histogram Equalised B');
    end
    daspect ([1 1 1]);
    axis tight;
end

set(gcf,'Position',get(0,'ScreenSize'));%maximize figure
imwrite(hmImage1,'images\canyon_HE.png')
%{
myNumOfColors = 200;
myColorScale = [[0:1/(myNumOfColors - 1):1]',[0:1/(myNumOfColors - 1):1]' , [0:1/(myNumOfColors - 1):1]' ];

subplot(1,2,1);
imagesc ((image)); % phantom is a popular test image
title('Original');
colormap (myColorScale);
colormap (jet);
daspect ([1 1 1]);
axis tight;
colorbar
subplot(1,2,2);
imagesc ((hmImage)); % phantom is a popular test image
title('Histogram-equalized');
colormap (myColorScale);
colormap (jet);
daspect ([1 1 1]);
axis tight;
colorbar
set(gcf,'Position',get(0,'ScreenSize'));%maximize figure
%}
end


