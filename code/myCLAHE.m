function [ out ] = myCLAHE(cliplevel, windowsize )


I1 = imread('data\barbara.png');	% given image read into matrix image
channelCount = size(I1 ,3);
for l = 1:channelCount
    % Setup.
    I = I1(:,:,l);
    r = floor((windowsize-1)/2);
    minI = min(min(I));
    maxI = max(max(I));
    step = (maxI - minI) / (256 - 1);


    H = zeros(256,1);

    [height width] = size(I);
    out = zeros(height, width);
    area = 0;

    for j=1:height
        % Find height of addition/subtraction boxes.
        lowj = max(1, j - r);
        highj = min(height, j + r);

        % Find height of addition/subtraction boxes.
        for i=(-r+1):(width+r+1)
            % Find the line that is no longer part of our window.
            subi = i - r - 1;

            % Add new line to window.
            addi = i + r;

            % Remove pixels on the left edge.
            if ( subi >= 1 )
                % Create histogram, don't scale.
                for jj = lowj:highj
                    idx = floor(I(jj, subi) / step) + 1;
                    H(idx) = H(idx) - 1;
                end
                % Modify histogram size (for later scaling).
                area = area - (highj - lowj + 1);
            end

            % Add pixels on the right edge.
            if ( addi <= width )
                % Create histogram, don't scale.
                for jj = lowj:highj
                    idx = floor(I(jj, addi) / step) + 1;
                    H(idx) = H(idx) + 1;
                end
                % Modify histogram size (for later scaling).
                area = area + (highj - lowj + 1);
            end

            if ( i >= 1 && i <= width )
                % Update pixel value.
                idx = floor(I(j, i) / step) + 1;
                val = 0;

                % Crop off the top
                cropped = 0;
                SH = H;

                % New clipping routine.
                cliplevel = area * cliplevel;
                for k=1:256
                    if ( SH(k) > cliplevel )
                        cropped = cropped + (SH(k) - cliplevel);
                        SH(k) = cliplevel;
                    end
                end

                % Spread out the cropped area.  Generate CDF.
                spread = cropped / 256;
                for k=1:(idx-1)
                    val = val + SH(k) + spread;
                end

                % Convert to true CDF value;
                val = (val / area) * (256 - 1);

                out(j, i) = val;
            end
        end

    end
    out1(:,:,l) = out;
end
% Scale to viewable range.
out1 = out1 / 256;


for i=1:channelCount
    subplot(channelCount,2,(2*i) -1);
    imshow (I1(:, :, i)); % phantom is a popular test image
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
    imagesc (out1(:,:,i)); % phantom is a popular test image
    if (channelCount == 1)
        title('CLAHE');
    elseif (i == 1)
        title('CLAHE R');
    elseif (i == 2)
        title('CLAHE G');
    else
        title('CLAHE B');
    end
    daspect ([1 1 1]);
    axis tight;
end

set(gcf,'Position',get(0,'ScreenSize'));%maximize figure
imwrite(out1,'images\barbara_CLAHE_0-6_100.png')
%{
subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(out);
set(gcf,'Position',get(0,'ScreenSize'));%maximize figure
%}
%{
myNumOfColors = 200;
myColorScale = [[0:1/(myNumOfColors - 1):1]',[0:1/(myNumOfColors - 1):1]' , [0:1/(myNumOfColors - 1):1]' ];

subplot(1,2,1);
imagesc ((I)); % phantom is a popular test image
title('Original');
colormap (myColorScale);
colormap (jet);
daspect ([1 1 1]);
axis tight;
colorbar
subplot(1,2,2);
imagesc ((out)); % phantom is a popular test image
title('AHE-applied');
colormap (myColorScale);
colormap (jet);
daspect ([1 1 1]);
axis tight;
colorbar

set(gcf,'Position',get(0,'ScreenSize'));%maximize figure
%}
end
