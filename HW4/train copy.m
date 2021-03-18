function [threshold, w, sortNum1, sortNum2] = train(labelidc1, labelidc2, num1, num2)
    nNum1 = size(labelidc1', 2);
    nNum2 = size(labelidc2', 2);

    mNum1 = mean(num1,2);
    mNum2 = mean(num2,2);
    Sw = 0; % within class variances
    for k = 1:nNum1
        Sw = Sw + (num1(:,k) - mNum1)*(num1(:,k) - mNum1)';
    end
    for k = 1:nNum2
        Sw =  Sw + (num2(:,k) - mNum2)*(num2(:,k) - mNum2)';
    end
    Sb = (mNum1-mNum2)*(mNum1-mNum2)'; % between class

    [V2, D] = eig(Sb,Sw); % linear disciminant analysis
    [lambda, ind] = max(abs(diag(D)));
    w = V2(:,ind);
    w = w/norm(w,2);

    vNum1 = w' * num1;
    vNum2 = w' * num2;

    if mean(vNum1)>mean(vNum2)
        w = -w;
        vNum1 = -vNum1;
        vNum2 = -vNum2;
    end

    sortNum1 = sort(num1);
    sortNum2 = sort(num2);

    t1 = nNum1;
    t2 = 1;
    while sortNum1(t1) > sortNum2(t2)
        t1 = t1 - 1;
        t2 = t2 + 1;
    end
    threshold = (sortNum1(t1) + sortNum2(t2))/2;
    
end