function [psf, Ghat] = gaussfft(pic, t)
[x,y] = meshgrid(-size(pic,1)/2:size(pic,1)/2-1, -size(pic,2)/2:size(pic,2)/2-1);
G = (1/(2*pi*t)).*exp(-(x.^2 + y.^2)./(2*t));
Ghat = fft2(G);
pichat = fft2(pic);
psf = Ghat'.*pichat;

psf = fftshift(ifft2((psf)));

end
