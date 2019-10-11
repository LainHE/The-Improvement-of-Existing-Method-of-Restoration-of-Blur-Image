function mssim = ssim_index(GTT, GrTT)

K = [0.01 0.03];
window = fspecial('gaussian', 11, 1.5);
L = 255;

C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
mu1   = filter2(window, GrTT, 'valid');
mu2   = filter2(window, GTT, 'valid');
% mu1_sq = mu1.*mu1;
% mu2_sq = mu2.*mu2;
% mu1_mu2 = mu1.*mu2;
% sigma1_sq = filter2(window, GrTT.*GrTT, 'valid') - mu1_sq;
% sigma2_sq = filter2(window, GTT.*GTT, 'valid') - mu2_sq;
% sigma12 = filter2(window, GrTT.*GTT, 'valid') - mu1_mu2;
% 
% ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));

mu1_mu2 = mu1.*mu2;
sigma12 = filter2(window, GrTT.*GTT, 'valid'); 
GrTT2 = GrTT.^2; GTT2 = GTT.^2; G2 = GrTT2 + GTT2;
Gu2 = filter2(window, G2, 'valid');
mu12 = 2*mu1_mu2+C1;

ssim_map = ((2*sigma12+(C1+C2))-(mu12)).*(mu12)./(Gu2-(mu2-mu1).^2+(mu12)+(C1+C2)).*((mu2-mu1).^2+(mu12));

mssim = mean2(ssim_map);
return