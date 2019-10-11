function len = EstLen(ifbl, THETA)
%Function to estimate blur length
%Inputs:  ifbl, THETA, expertstatus
%Returns: LEN
%
%ifbl:  It is the input image.
%THETA: It is the blur angle returned from angle estimation.
%LEN:   It is the blur length. The length is the number
%       of pixels by which the image is blurred.
%
%Example:
%       LEN = EstLen(image, THETA, expertstatus);
%       This call takes image as input and returns the blur length.

%No of steps in the algorithm
steps = 8;

%Preprocessing
%Performing Median Filter before restoring the blurred image
ifbl = medfilt2(abs(ifbl));

%We have to convert the image to Cepstrum domain
%This is how we represent Cepstrum Domain
%Cep(g(x,y)) = invFT{log(FT(g(x,y)))}

%Converting to fourier domain
fin = fft2(ifbl);

%Performing log transform
lgfin = abs(log(1 + abs(fin)));

%Performing inverse fourier transform to get the image in Cepstrum domain
cin = ifft2(lgfin);

%Rotating the image
cinrot = imrotate(cin, -THETA);

%Taking average of all the columns
for i=1:size(cinrot, 2)
    avg(i) = 0;
    for j=1:size(cinrot, 1)
        avg(i) = avg(i) + cinrot(j, i);
    end
    avg(i) = avg(i)/size(cinrot, 1);
end
avgr = real(avg);

%Calculating the blur length using first negative value
index = 0;
for i = 1:round(size(avg,2)),
    if real(avg(i))<0,
        index = i;
        break;
    end
end

%If Zero Crossing found then return it as the blur length
if index~=0,
    len = index;
else
    %If Zero Crossing not found then find the lowest peak
    %Calculating the blur length using Lowest Peak
    index = 1;
    startval = avg(index);
    for i = 1 : round(size(avg, 2)/2),
        if startval>avg(i),
            startval = avg(i);
            index = i;
        end
    end

    len = index;
end