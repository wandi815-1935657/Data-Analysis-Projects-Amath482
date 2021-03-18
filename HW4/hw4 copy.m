%% Set up data
close all; clc; clear;

[images, labels] = mnist_parse('train-images-idx3-ubyte', 'train-labels-idx1-ubyte');
[imagesT, labelsT] = mnist_parse('t10k-images-idx3-ubyte', 't10k-labels-idx1-ubyte');

[n, ~, length] = size(images);
for k = 1:length
    digimages(:,k) = reshape(images(:,:,k), n*n, 1);
end

[nT, ~, lengthT] = size(imagesT);
for k = 1:lengthT
    digimagesT(:,k) = reshape(imagesT(:,:,k), nT*nT, 1);
end

digimages = im2double(digimages);
digimages = digimages - repmat(mean(digimages, 2), 1, length);
[U, S, V] = svd(digimages, 'econ');
lambda = diag(S).^2;
k = 1;
while sum(lambda(1:k))/sum(lambda) < 0.9
    k = k + 1;
end
figure(1)
plot(lambda, 'ko', 'Linewidth', 2)
xlabel('images');ylabel('principal components');
title('Training Data - Principal Components');
set(gca,'Fontsize',16)
print('HW4PCA.png', '-dpng');


%% Building singular value spectrum
ff = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';
x = linspace(0,2,784);
t = linspace(0,10,60000);
[T, X] = meshgrid(t,x);

figure(2)
subplot(2, 1, 1)
surf(X,T,ff)
shading interp
title('Singular Value Spectrum');
xlabel('X');ylabel('Y');zlabel('Z');
set(gca,'Fontsize',16);
subplot(2, 1, 2)
surf(X, T, digimages)
shading interp
title('Original Data Spectrum');
xlabel('X');ylabel('Y');zlabel('Z');
set(gca,'Fontsize',16);
print('HW4Spectrum.png', '-dpng');

% Make projections onto three selected V-modes (columns)
projection = U(:, [1, 2, 3])' * digimages;
projection_zero = projection(:, find(labels == 0));
projection_one = projection(:, find(labels == 1));
projection_two = projection(:, find(labels == 2));
projection_three = projection(:, find(labels == 3));
projection_four = projection(:, find(labels == 4));
projection_five = projection(:, find(labels == 5));
projection_six = projection(:, find(labels == 6));
projection_seven = projection(:, find(labels == 7));
projection_eight = projection(:, find(labels == 8));
projection_nine = projection(:, find(labels == 9));
figure(3)
plot3(projection_zero(1, :), projection_zero(2, :), projection_zero(3, :), 'o'); hold on
plot3(projection_one(1, :), projection_one(2, :), projection_one(3, :), 'o'); hold on
plot3(projection_two(1, :), projection_two(2, :), projection_two(3, :), 'o'); hold on
plot3(projection_three(1, :), projection_three(2, :), projection_three(3, :), 'o'); hold on
plot3(projection_four(1, :), projection_four(2, :), projection_four(3, :), 'o'); hold on
plot3(projection_five(1, :), projection_five(2, :), projection_five(3, :), 'o'); hold on
plot3(projection_six(1, :), projection_six(2, :), projection_six(3, :), 'o'); hold on
plot3(projection_seven(1, :), projection_seven(2, :), projection_seven(3, :), 'o'); hold on
plot3(projection_eight(1, :), projection_eight(2, :), projection_eight(3, :), 'o'); hold on
plot3(projection_nine(1, :), projection_nine(2, :), projection_nine(3, :), 'o'); hold on
legend('0','1','2','3','4','5','6','7','8','9')
xlabel('Mode 1'); ylabel('Mode 2'); zlabel('Mode 3');
title('Projections onto the first three modes');
set(gca,'Fontsize',16);
print('HW4Projections.png', '-dpng');

%% LDA for two digits
feature = 13;
images = S * V';
zerosidc = find(labels == 0);
ninesidc = find(labels == 9);
zeros = images(1:feature, zerosidc);
nines = images(1:feature, ninesidc);

numzeros = size(zerosidc', 2);
numnines = size(ninesidc', 2);

mzeros = mean(zeros,2);
mnines = mean(nines,2);
Sw = 0; % within class variances
for k = 1:numzeros
    Sw = Sw + (zeros(:,k) - mzeros)*(zeros(:,k) - mzeros)';
end
for k = 1:numnines
    Sw =  Sw + (nines(:,k) - mnines)*(nines(:,k) - mnines)';
end
Sb = (mzeros-mnines)*(mzeros-mnines)'; % between class

[V2, D] = eig(Sb,Sw); % linear disciminant analysis
[lambda, ind] = max(abs(diag(D)));
w = V2(:,ind);
w = w/norm(w,2);

vzeros = w' * zeros;
vnines = w' * nines;

if mean(vzeros)>mean(vnines)
    w = -w;
    vzeros = -vzeros;
    vnines = -vnines;
end

figure(4)
plot(vzeros,0,'ob','Linewidth',2)
hold on
plot(vnines,ones(numnines),'dr','Linewidth',2)
xlabel('Sorted Projections'); ylabel('Specified Value');
title('Digit 0 & 9 Projections');
set(gca,'Fontsize',16);
print('HW4TwoDigitProjections.png', '-dpng');

sortzeros = sort(zeros);
sortnines = sort(nines);

t1 = numzeros;
t2 = 1;
while sortzeros(t1) > sortnines(t2)
    t1 = t1 - 1;
    t2 = t2 + 1;
end
threshold = (sortzeros(t1) + sortnines(t2))/2;

figure(5)
subplot(1,2,1)
histogram(sortzeros,30); hold on
plot([threshold threshold], [0 12000], 'r')
xlabel('Projection'); ylabel('Frequency');
title('Zeros')
set(gca,'Xlim',[-10 10],'Ylim',[0 12000],'Fontsize',16)
subplot(1,2,2)
histogram(sortnines,30); hold on
plot([threshold threshold], [0 10000],'r')
xlabel('Projection'); ylabel('Frequency');
title('Nines')
set(gca,'Xlim',[-10 10],'Ylim',[0 10000],'Fontsize',16)
print('HW4TwoDigitHistograms.png', '-dpng');

TestNum = size(digimagesT,2);
digimagesT = im2double(digimagesT);
TestMat = U(:,1:feature)'*digimagesT; % PCA projection
pval = w'*TestMat;

zerosidcT = find(labelsT == 0);
ninesidcT = find(labelsT == 9);

ResVec = (pval(ninesidcT) > threshold);
errNines = abs(sum(ResVec) - size(ninesidcT',2));

ResVec = (pval(zerosidcT) < threshold);
errZeros = abs(sum(ResVec) - size(zerosidcT',2));

sucRate = 1 - (errNines + errZeros)/(size(ninesidcT',2) + size(zerosidcT',2));

% Pairs that are the most & least difficult to separate
min = 1;
max = 0;
index = 0;
for k = 0:8
    for j = (k+1):9
        index = index + 1;
        labelidc1 = find(labels == k);
        labelidc2 = find(labels == j);
        num1 = images(1:feature, labelidc1);
        num2 = images(1:feature, labelidc2);
        [threshold, w, sortNum1, sortNum2] = train(labelidc1, labelidc2, num1, num2);
        TestNum = size(digimagesT,2);
        digimagesT = im2double(digimagesT);
        TestMat = U(:,1:feature)'*digimagesT; % PCA projection
        pval = w'*TestMat;
        labelsidcT1 = find(labelsT == k);
        labelsidcT2 = find(labelsT == j);
        sucrate = test(labelsidcT1, labelsidcT2, threshold, pval);
        rate(1,index) = sucrate;
        if sucrate < min
            min = sucrate;
            minNum1 = k;
            minNum2 = j;
        end
        if sucrate > max
            max = sucrate;
            maxNum1 = k;
            maxNum2 = j;
        end
    end
end

%% LDA for three digits
feature = 13;
images = S * V';
zerosidc = find(labels == 0);
onesidc = find(labels == 1);
twosidc = find(labels == 2);

zeros = images(1:feature, zerosidc);
ones = images(1:feature, onesidc);
twos = images(1:feature, twosidc);

numzeros = size(zerosidc', 2);
numones = size(onesidc', 2);
numtwos = size(twosidc', 2);

mzeros = mean(zeros,2);
mones = mean(ones,2);
mtwos = mean(twos,2);
mn = (mzeros + mones + mtwos)/3;

Sw = 0; % within class variances
for k = 1:numzeros
    Sw = Sw + (zeros(:,k) - mzeros)*(zeros(:,k) - mzeros)';
end
for k = 1:numones
    Sw =  Sw + (ones(:,k) - mones)*(ones(:,k) - mones)';
end
for k = 1:numtwos
    Sw =  Sw + (twos(:,k) - mtwos)*(twos(:,k) - mtwos)';
end
Sb = (mzeros-mn)*(mzeros-mn)' + (mones-mn)*(mones-mn)' + (mtwos-mn)*(mtwos-mn)'; % between class

[V2, D] = eig(Sb,Sw); % linear disciminant analysis
[~, indice] = max(abs(diag(D)));
w = V2(:,indice);
w = w/norm(w,2);

vzeros = w' * zeros;
vones = w' * ones;
vtwos = w' * twos;

% setup threshold
if mean(vzeros) > mean(vones) 
    w = -w;
    vzeros = -vzeros;
    vones = -vones;
end
if mean(vones) > mean(vtwos) 
    w = -w;
    vones = -vones;
    vtwos = -vtwos;
end

szeros = sort(vzeros);
sones = sort(vones);
stwos = sort(vtwos);
t1 = numzeros;
t2 = 1;
while szeros(t1) > sones(t2)
    t1 = t1 - 1;
    t2 = t2 + 1;
end
threshold1 = (szeros(t1) + sones(t2))/2;

t1 = numzeros;
t3 = 1;
while szeros(t1) > stwos(t3)
    t1 = t1 - 1;
    t3 = t3 + 1;
end
threshold2 = (szeros(t1) + stwos(t3))/2;

t2 = numones;
t3 = 1;
while sones(t2) > stwos(t3)
    t2 = t2 - 1;
    t3 = t3 + 1;
end
threshold3 = (sones(t2) + stwos(t3))/2;

threshold = (threshold1 + threshold2 + threshold3)/3;

figure(6)
subplot(1,3,1)
histogram(szeros,30); hold on
plot([threshold threshold], [0 700], 'r')
title('Zeros')
xlabel('Projection'); ylabel('Frequency');
set(gca,'Xlim',[-8 5],'Ylim',[0 700],'Fontsize',16)
subplot(1,3,2)
histogram(sones,30); hold on
plot([threshold threshold], [0 1200],'r')
title('Ones')
xlabel('Projection'); ylabel('Frequency');
set(gca,'Xlim',[-5 5],'Ylim',[0 1200],'Fontsize',16)
subplot(1,3,3)
histogram(stwos,30); hold on
plot([threshold threshold], [0 700],'r')
title('Twos')
xlabel('Projection'); ylabel('Frequency');
set(gca,'Xlim',[-5 5],'Ylim',[0 700],'Fontsize',16)
print('HW4ThreeDigitHistograms.png', '-dpng');


%% classification tree on fisheriris data

tree=fitctree(digimages',labels,'MaxNumSplits',10,'CrossVal','on');
view(tree.Trained{1},'Mode','graph');
classError = kfoldLoss(tree, 'Mode', 'individual');


%% SVM classifier with training data, labels and test set

success = 0;
Mdl = fitcecoc(digimages',labels);
test_labels = predict(Mdl,digimagesT');
for j = 1:length(test_labels)
    if (test_labels(j) - labelsT(j)) == 0
        success = success + 1;
    end
end
svmrate = success/length(test_labels);