function sucrate = test(labelsidcT1, labelsidcT2, threshold, pval)
    ResVec = (pval(labelsidcT2) > threshold);
    errNum2 = abs(sum(ResVec) - size(labelsidcT2',2));

    ResVec = (pval(labelsidcT1) < threshold);
    errNum1 = abs(sum(ResVec) - size(labelsidcT1',2));

    sucrate = 1 - (errNum2 + errNum1)/(size(labelsidcT2',2) + size(labelsidcT1',2));
end