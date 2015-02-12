%
% Tone Mapping Operator, by Reinhard 02 paper.
% "Photographic Tone Reproduction for Digital Images"
%
% input:
%   img: 3 channel HDR img
%   type_: 'global'(default) or 'local'.
%   alpha_: scalar constant to specify a high key or low key. (0.18)
%   delta: scalar constant to prevent log(0). (1e-6)
%   white_: scalar constant, the smallest luminance to be mapped to 1. (1.5)
%   phi: (local) scalar constant. (4)
%   epsilon: (local) scalar constant to tell the terminating threshold. (1e-4)
%
% output:
%   tone-mapped image (LDR or SDR)
%

function imgOut = Reinhard(img, alpha_, delta, white_, phi, epsilon)

alpha_ = 0.18;
delta = 1e-6;
white_ = 1.5;
phi = 4;
epsilon = 1e-4;

imgOut = zeros(size(img));

Lw = 0.2126 * img(:,:,1) + 0.7152 * img(:,:,2) + 0.0722 * img(:,:,3);

LwMean = exp(mean(mean(log(delta + Lw))));
Lm = (alpha_ / LwMean) * Lw;
Ld = (Lm .* (1 + Lm / (white_ * white_))) ./ (1 + Lm);

for channel = 1:3
	Cw = img(:,:,channel) ./ Lw;
	imgOut(:,:,channel) = Cw .* Ld;
end

end




