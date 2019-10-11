 function c = fNRSS(lucy)

% targetimg = double(rgb2gray(imread ('BN.png')));
targetimg = double(lucy);
[timgheight, timgwidth] = size(targetimg);

a1 = abs(niqe(targetimg));

a2 = abs(brisque(targetimg));

a3 = abs(piqe(targetimg));

a4 = abs(entropy(targetimg));

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
a5 = abs(1-mssim);%利用公式计算得到NRSS

[ax,ay] = gradient(targetimg);
z2 = ax.^2;
a6 = abs(mean2(z2(z2 > 36)));

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
a7 = abs(tenengrad/(timgheight*timgwidth));

smd = 0;
for i = 1:(timgheight-1)
    for j = 2:timgwidth
        smd = smd +  (abs(targetimg(i,j) - targetimg(i,j-1)) + abs(targetimg(i,j)-targetimg(i+1,j)));
    end
end
a8 = abs(smd/(timgheight*timgwidth));

smd2 = 0;
for i = 1:(timgheight-1)
    for j = 2:timgwidth
        smd2 = smd2 + abs(targetimg(i,j) - targetimg(i+1,j)) * abs(targetimg(i,j)-targetimg(i,j-1));
    end
end
a9 = abs(smd2/(timgheight*timgwidth));
% reblured = imfilter(targetimg,(fspecial('motion',35,48)));
reblured = gradient(imfilter(targetimg,(fspecial('motion',35,48))));
a10 = abs(mean2(targetimg - reblured));
% renoised = imnoise(targetimg,'gaussian',0, 0.01);
renoised = gradient(imnoise(targetimg,'gaussian',0, 0.01));
a11 = abs(mean2(targetimg - renoised));


for i = 1:11
    eval(['c(1,i) = a', num2str(i),';']);
end
