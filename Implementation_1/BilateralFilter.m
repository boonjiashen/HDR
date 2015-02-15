function BFO = BilateralFilter(InputMatrix, filtersize, sigma_d, sigma_r)


[Row, Col] = size(InputMatrix);
BFO = zeros(size(InputMatrix));

for r = 1: Row
    for c = 1: Col
        FRowStart = r - filtersize;
        FColStart = c - filtersize;
        FRowEnd = r + filtersize;
        FColEnd = c + filtersize;
        if(FRowStart < 1)
            FRowStart = 1;
        end
        if(FRowEnd > Row)
            FRowEnd = Row;
        end
        if(FColStart < 1)
            FColStart = 1;
        end
        if(FColEnd > Col)
            FColEnd = Col;
        end
        TotalRows = FRowEnd - FRowStart + 1;
        TotalCols = FColEnd - FColStart + 1;
        
        Filter = zeros(TotalRows, TotalCols);
        for FilterHeight = FRowStart: FRowEnd
            for FilterWidth = FColStart: FColEnd
                Filter(FilterHeight - FRowStart + 1, FilterWidth - FColStart + 1) = exp((-(r - FilterHeight)^2 - (c - FilterWidth)^2) / (2*sigma_d^2)) ...,
                    * exp((-(InputMatrix(FilterHeight, FilterWidth) - InputMatrix(r, c))^2) / (2*sigma_r^2));
            end
        end
        
        Filter = Filter / sum(sum(Filter));
        BFO(r, c) = sum(sum(Filter .* InputMatrix(FRowStart: FRowEnd, FColStart: FColEnd)));
    end
end

end