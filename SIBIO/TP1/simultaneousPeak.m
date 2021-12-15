function rPeak = simultaneousPeak(rPeak1, rPeak2, prec)

nbPeak1 = length(rPeak1);
rPeak = [];
for indPeak = 1:nbPeak1
    if min(abs(rPeak1(indPeak) - rPeak2)) < prec
        rPeak = [rPeak ; rPeak1(indPeak)];
    end
end
