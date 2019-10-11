
function [result,theta,len] = guess()

pathname = ('./forDetect/');filename = ('targetimg');
img = imread([pathname,filename]);
if size(img,3)==3
    img = rgb2gray(img);
end

theta = EstAngle(img);
for i=1:size(theta,2)
    len(i) = EstLen(img,theta(i));
end

for i = 1:10
   psf = fspecial('motion',len(1),theta(i));
   eval(['lucy',num2str(i),' = deconvlucy(img,psf);']);
   eval(['X = lucy',num2str(i)],';');
   filename = ['.\forDetect\lucy',num2str(i),'.jpg'];
   imwrite(X,filename);
end
for i = 1:10
    eval(['c',num2str(i),'=fNRSS(lucy',num2str(i),');']);
    eval(['c(i,:) = c', num2str(i),';']);
end
for i = 1:11
    eval(['n',num2str(i),'= c(:,i);']);
    for k = 1:10
        eval(['n',num2str(i),'(k,2)=',num2str(k),';']);
    end
end

for i = 1:11
    eval(['m',num2str(i),' = sortrows(n',num2str(i),',1);']);
    eval(['ans',num2str(i),'=m',num2str(i),'(1,2)',';']);
end
    m5 = sortrows(n5,1,'descend');
    ans5 = m5(1,2);


for i = 1:10
    eval(['res(i,:) = ans', num2str(i),';']);
end

m = tabulate(res(:));
n = sortrows(m,2,'descend');
result = n(1,1);