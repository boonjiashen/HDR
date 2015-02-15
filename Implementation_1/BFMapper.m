function Output8 = BFMapper(InputImage)

R_Image = InputImage(:, :, 1);
G_Image = InputImage(:, :, 2);
B_Image = InputImage(:, :, 3);
I = 1/61*(R_Image*20+G_Image*40+B_Image);
r = R_Image ./ I;
g = G_Image ./ I;
b = B_Image ./ I;
IntensityLog = log(I);

IntensityLogBase = BilateralFilter(IntensityLog, 10, 8, 0.2);
IntensityLogDetail = IntensityLog - IntensityLogBase;
CompressionFactor = log(40) / (max(max(IntensityLogBase)) - min(min(IntensityLogBase)));
IntensitylogOutput = IntensityLogBase * CompressionFactor - max(max(IntensityLogBase)) * CompressionFactor + IntensityLogDetail;
IntensityOutput = exp(IntensitylogOutput);
R_Output = r .* IntensityOutput;
G_Output = g .* IntensityOutput;
B_Output = b .* IntensityOutput;
Output(:, :, 1) = R_Output * 255;
Output(:, :, 2) = G_Output * 255;
Output(:, :, 3) = B_Output * 255;
Output8 = uint8(Output);
end