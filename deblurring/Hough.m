function [h] = Hough(image)
%Function to perform Hough Transform on an image
%Inputs:  image
%Returns: h
%
%image:  It is the input image.
%h:      It is the accumulator array
%
%Example:
%       h = Hough(image);
%       This call takes image as input and returns accumulator array

siz = size(image);
rl = ceil(sqrt(siz(1)^2+siz(2)^2));

h = zeros(rl,360);
theta = 360;

%Building up the accumulator array
for x = 1:siz(1)
    for y = 1:siz(2)
        if image(x,y)==1
            for theta = 1:360
                r = round(x*cos(theta*pi/180) + y*sin(theta*pi/180));
                if r<1
                    r = 1;
                    h(r,theta) = h(r,theta);
                else
                    h(r,theta) = h(r,theta) + 1;
                end
            end
        end
    end
end