close all; clear; clc;

skiReader = VideoReader('ski_drop.mov');
numFrames = get(skiReader, 'NumFrames');
duration = get(skiReader, 'duration');
dt = duration/numFrames;

video = read(skiReader);
video = imresize(video, 0.1);
for k = 1:numFrames
    video_resized = im2double(rgb2gray(video(:,:,:,k)));
    skiVid(:, k) = reshape(video_resized, [], 1);
end

X1 = skiVid(:, 1:end - 1);
X2 = skiVid(:, 2:end);
[U, S, V] = svd(X1, 'econ');
sigma = diag(S);

k = 1;
while sum(sigma(1:k))/sum(sigma) < 0.9
    k = k + 1;
end

rank = k;

figure(1)
plot(sigma/sum(sigma), 'ko', 'Linewidth', 2, 'Markersize', 10);
title('Energy Captured by Singular Values');
xlabel('Singular Values'); ylabel('Energy');
set(gca,'Fontsize',16);

S_tilda = U(:, 1:rank)' * X2 * V(:, 1:rank)/S(1:rank, 1:rank);
[eV, D] = eig(S_tilda);
mu = diag(D);
omega = log(mu)/dt;
Phi = U(:, 1:rank) * eV;

t = 0:dt:duration;
y0 = Phi\X1(:, 1);

modes = zeros(length(y0),length(t)-2);
for iter = 1:length(t)-2
    modes(:,iter) = y0.*exp(omega*t(iter));
end
Xdmd = Phi*modes;

Xsparse = X1 - abs(Xdmd);
R = Xsparse.*(Xsparse < 0);
Xdmd_reconstructed = R + abs(Xdmd);
Xsparse_reconstructed = Xsparse - R;
Xreconstructed = Xsparse_reconstructed + Xdmd_reconstructed;

[row, col] = size(video_resized);
vid1 = reshape(X1, [row, col, numFrames-1]);
vid2 = reshape(Xdmd, [row, col, numFrames-1]);
vid3 = reshape(Xsparse, [row, col, numFrames-1]);
vid4 = reshape(Xreconstructed, [row, col, numFrames-1]);
vid5 = reshape(Xdmd_reconstructed, [row, col, numFrames-1]);
vid6 = reshape(Xsparse_reconstructed, [row, col, numFrames-1]);


figure(2)
subplot(2, 3, 1)
imshow(vid1(:,:,300))
title('Original Video');
subplot(2, 3, 2)
imshow(vid2(:,:,300))
title('Background Video (Low Rank without R)');
subplot(2, 3, 3)
imshow(vid3(:,:,300))
title('Foreground Video (Sparse with R)');
subplot(2, 3, 4)
imshow(vid4(:,:,300))
title('Reconstructed Video');
subplot(2, 3, 5)
imshow(vid5(:,:,300))
title('Background Video (Low Rank with R)');
subplot(2, 3, 6)
imshow(vid6(:,:,300))
title('Foreground Video (Sparse without R)');
sgtitle('Ski-drop Video');

