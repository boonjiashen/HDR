%
% Tone Mapping Operator, by Reinhard 02 paper.
% "Photographic Tone Reproduction for Digital Images"
%
% input:
%   img: 3 channel HDR img
%   alpha_: scalar constant to specify a high key or low key. (0.18)
%   delta: scalar constant to prevent log(0). (1e-6)
%   white_: scalar constant, the smallest luminance to be mapped to 1. (1.5)
% output:
%   tone-mapped image (LDR or SDR)

% unused input:
%   phi: (local) scalar constant. (4)
%   type_: 'global'(default) or 'local'.
%   epsilon: (local) scalar constant to tell the terminating threshold. (1e-4)
%
%

function imgOut = Reinhard(img, alpha, delta, white)

imgOut = zeros(size(img));

Lw = 0.27 * img(:,:,1) + 0.67 * img(:,:,2) + 0.06 * img(:,:,3); %Moving back to paper specified value
%The previous value was used by someone in his phd thesis

LwMean = exp(mean(mean(log(delta + Lw))));
Lm = (alpha / LwMean) * Lw;


[x,y] = size(Lm);
Ldo = zeros(x,y);
for i = 1:x
    for j = 1:y
        Ldo(i,j) = (Lm(i,j) * (1 + Lm(i,j) / (white * white))) / (1 + Lm(i,j));
    end
end

for channel = 1:3
	Cw = img(:,:,channel)./ Lw;
	imgOut(:,:,channel) = Cw .* Ldo;

end

end




