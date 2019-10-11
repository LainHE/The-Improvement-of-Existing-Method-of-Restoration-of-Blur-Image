function [title1,title2,title3,title4,title5,title6,title7,title8,title9] = haveOriginalImage()
%%
pathname = ('./forDetect/');filename = ('originalimg');
originalimg = double(rgb2gray(imread ([pathname,filename])));
filename = ('targetimg');
targetimg = double(rgb2gray(imread ([pathname,filename])));
[oimgheight, oimgwidth] = size(originalimg);
%%
%Average absolute difference

md = originalimg - targetimg;
mdsize = size(md);
summation = 0;
for i = 1:mdsize(1)
    for j = 1:mdsize(2)
        summation = summation + abs(md(i,j));
    end
end
absdiff = summation/(mdsize(1)*mdsize(2));
title1 = ['Average absolute Difference:', num2str(absdiff)];
% disp (title)
%%
%Signal to Noise Ratio (SNR)

md = (originalimg - targetimg).^2;
mdsize = size(md);
summation = 0;
sumsq=0;
for i = 1:mdsize(1)
    for j = 1:mdsize(2)
        summation = summation + md(i,j);
        sumsq = sumsq + (originalimg(i,j)^2);
    end
end
snr = sumsq/summation;
snr = 10 * log10(snr);
title2 = ['Signal to Noise Ratio:', num2str(snr)];
% disp (title)
%%
%Peak Signal to Noise Ratio (PSNR)

md = (originalimg - targetimg).^2;
mdsize = size(md);
summation = 0;
for  i = 1:mdsize(1)
    for j = 1:mdsize(2)
        summation = summation + abs(md(i,j));
    end
end
psnr = size(originalimg, 1) * size(originalimg, 2) * max(max(originalimg.^2))/summation;
psnr = 10 * log10(psnr);
title3 = ['Peak Signal to Noise Ratio (PSNR):', num2str(psnr)];
% disp (title)
%%
%Image Fidelity

md = (originalimg - targetimg).^2;
mdsize = size(md);
summation = 0;
sumsq = 0;
for  i = 1:mdsize(1)
    for j = 1:mdsize(2)
        summation = summation + abs(md(i,j));
        sumsq = sumsq + (originalimg(i,j)^2);
    end
end
imfid = (1-summation)/sumsq;
title4 = ['Image Fidelity:', num2str(imfid)];
% disp (title)
%%
%Mean Square Error

diff = originalimg - targetimg;
diff1 = diff.^2;
mse = mean(mean(diff1));
title5 = ['Mean Square Error:', num2str(mse)];
% disp (title)
%%
%Entropy

diffentropy = entropy(targetimg) - entropy(originalimg);
title6 = ['Entropy:', num2str(diffentropy)];
% disp (title)
%%
%Structural Similarity Index (SSIM)

K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = 255;

f = max(1,round(min(oimgheight,oimgwidth)/256));

lpf = ones(f,f);
lpf = lpf/sum(lpf(:));
originalimg = imfilter(originalimg,lpf,'symmetric','same');
targetimg = imfilter(targetimg,lpf,'symmetric','same');

originalimg = originalimg(1:f:end,1:f:end);
targetimg = targetimg(1:f:end,1:f:end);

C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;

mu1   = filter2(window, originalimg, 'valid');
mu2   = filter2(window, targetimg, 'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = filter2(window, originalimg.*originalimg, 'valid') - mu1_sq;
sigma2_sq = filter2(window, targetimg.*targetimg, 'valid') - mu2_sq;
sigma12 = filter2(window, originalimg.*targetimg, 'valid') - mu1_mu2;

ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));

ssim = mean2(ssim_map);
title7 = ['Structural Similarity Index (SSIM):', num2str(ssim)];
% disp (title)
%%
title8 = 'In general, when the number closer to zero, it means the image similar with original image';
title9 = 'But PSNR and SSIM would as bigger as better';
return