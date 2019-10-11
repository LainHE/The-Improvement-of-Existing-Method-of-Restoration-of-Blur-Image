 function [title1,title2,title3,title4,title5,title6,title7,title8,title9,title10,title11,title12,title13] = noOriginalImage()
%%
pathname = ('./forDetect/');filename = ('targetimg');
targetimg = double(rgb2gray(imread ([pathname,filename])));
[timgheight, timgwidth] = size(targetimg);
%%
% Naturalness Image Quality Evaluator (NIQE) 
NIQE = niqe(targetimg);
title1 = ['Naturalness Image Quality Evaluator(NIQE):', num2str(NIQE)];
%%
%Blind/Referenceless Image Spatial Quality Evaluator (BRISQUE) 
BRISQUE = brisque(targetimg);
title2 = ['Blind/Referenceless Image Spatial Quality Evaluator(BRISQUE):', num2str(BRISQUE)];
%%
%Perception based Image Quality Evaluator (PIQE) 
PIQE = piqe(targetimg);
title3 = ['Perception based Image Quality Evaluator(PIQE):', num2str(PIQE)];
%%
%Entropy
Entropy = entropy(targetimg);
title4 = ['Entropy:', num2str(Entropy)];
%%
%NRSS through SSIM
sigma=6;
gausFilter=fspecial('gaussian',[7 7],sigma);%构建高斯滤波器
filtratedimg=imfilter(targetimg,gausFilter,'replicate');%高斯滤波
% (2)利用Sobel算子计算图像targetimg和filtratedimg的梯度图像G和Gr
G = edge(targetimg,'sobel');%Sobel 
Gr= edge(filtratedimg,'sobel'); %Sobel
% (3)将梯度图像划分8x8小块并计算每块的方差，找出其中最大的K=64个
fun = @(x) std2(x)*std2(x)*ones(size(x));%求方差函数
GT = blkproc(G,[4 4],[2,2],fun);%将梯度图像G划分为8x8小块并且块间距离为4，并计算每个块的方差
fun2 = @(x) sum(x)*ones(size(x));%求和函数
GTT = blkproc(GT,[8 8],fun2);%通过求和找出方差最大的64个子块
GrT = blkproc(Gr,[4 4],[2,2],fun);%将梯度图像Gr划分为8x8小块并且块间距离为4，并计算每个块的方差
GrTT = blkproc(GrT,[8 8],fun2);%找出求和找出方差最大的64个子块
% (4)计算图像I的无参考结构清晰度
mssim = ssim_index(GTT,GrTT);%得到64个方差较大块的平均SSIM
nrss = 1-mssim;%利用公式计算得到NRSS
title5 = ['NRSS:', num2str(nrss)];
%%
%Brenner
[ax,ay] = gradient(targetimg);
z2 = ax.^2;
brenner = mean2(z2(z2 > 36));
title6 = ['Brenner:', num2str(brenner)];
%%
%TenenGrad
gx = 1/4 * [-1 0 1;-2 0 2;-1 0 1];
gy = 1/4 * [1 2 1;0 0 0;-1 -2 -1];
gradx = filter2(gx,targetimg,'same');
grady = filter2(gy,targetimg,'same');
tenengrad = 0;
for i = 1:timgheight
    for j = 1:timgwidth
        tenengrad = tenengrad + sqrt((gradx(i,j)*gradx(i,j) + grady(i,j)*grady(i,j)));
    end
end
tenengrad = tenengrad/(timgheight*timgwidth);
title7 = ['TenenGrad:', num2str(tenengrad)];
%%
%SMD
smd = 0;
for i = 1:(timgheight-1)
    for j = 2:timgwidth
        smd = smd +  (abs(targetimg(i,j) - targetimg(i,j-1)) + abs(targetimg(i,j)-targetimg(i+1,j)));
    end
end
smd = smd/(timgheight*timgwidth);
title8 = ['SMD:', num2str(smd)];
%%
%SMD2
smd2 = 0;
for i = 1:(timgheight-1)
    for j = 2:timgwidth
        smd2 = smd2 + abs(targetimg(i,j) - targetimg(i+1,j)) * abs(targetimg(i,j)-targetimg(i,j-1));
    end
end
smd2 = smd2/(timgheight*timgwidth);
title9 = ['SMD2:', num2str(smd2)];
%%
%Reblur
reblured = gradient(imfilter(targetimg, (fspecial('motion',35,48))));
reblur = mean2(targetimg - reblured);
title10 = ['Reblur:', num2str(reblur)];
%Renoise
renoised = gradient(imnoise(targetimg,'gaussian',0, 0.01));
renoise = mean2(targetimg - renoised);
title11 = ['Renoise:', num2str(renoise)];
%%
title12 = 'In general, when the number closer to zero, it means the image similar with original image';
title13 = 'But NRSS would as bigger as better';
return