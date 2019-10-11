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
gausFilter=fspecial('gaussian',[7 7],sigma);%������˹�˲���
filtratedimg=imfilter(targetimg,gausFilter,'replicate');%��˹�˲�
% (2)����Sobel���Ӽ���ͼ��targetimg��filtratedimg���ݶ�ͼ��G��Gr
G = edge(targetimg,'sobel');%Sobel 
Gr= edge(filtratedimg,'sobel'); %Sobel
% (3)���ݶ�ͼ�񻮷�8x8С�鲢����ÿ��ķ���ҳ���������K=64��
fun = @(x) std2(x)*std2(x)*ones(size(x));%�󷽲��
GT = blkproc(G,[4 4],[2,2],fun);%���ݶ�ͼ��G����Ϊ8x8С�鲢�ҿ�����Ϊ4��������ÿ����ķ���
fun2 = @(x) sum(x)*ones(size(x));%��ͺ���
GTT = blkproc(GT,[8 8],fun2);%ͨ������ҳ���������64���ӿ�
GrT = blkproc(Gr,[4 4],[2,2],fun);%���ݶ�ͼ��Gr����Ϊ8x8С�鲢�ҿ�����Ϊ4��������ÿ����ķ���
GrTT = blkproc(GrT,[8 8],fun2);%�ҳ�����ҳ���������64���ӿ�
% (4)����ͼ��I���޲ο��ṹ������
mssim = ssim_index(GTT,GrTT);%�õ�64������ϴ���ƽ��SSIM
nrss = 1-mssim;%���ù�ʽ����õ�NRSS
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