close all; clc; clear;
load('cam1_1.mat'), load('cam1_2.mat'), load('cam1_3.mat'), load('cam1_4.mat'), 
load('cam2_1.mat'), load('cam2_2.mat'), load('cam2_3.mat'), load('cam2_4.mat'), 
load('cam3_1.mat'), load('cam3_2.mat'), load('cam3_3.mat'), load('cam3_4.mat')

[U1, lambda1, positions1, numFrames1] = pcanalysis(vidFrames1_1, vidFrames2_1, vidFrames3_1);
[U2, lambda2, positions2, numFrames2] = pcanalysis(vidFrames1_2, vidFrames2_2, vidFrames3_2);
[U3, lambda3, positions3, numFrames3] = pcanalysis(vidFrames1_3, vidFrames2_3, vidFrames3_3);
[U4, lambda4, positions4, numFrames4] = pcanalysis(vidFrames1_4, vidFrames2_4, vidFrames3_4);

% plot principal components
figure(1)
subplot(2, 2, 1)
plot(1:6, lambda1, 'ko', 'MarkerSize', 10, 'Linewidth', 2)
xlabel('Measurements'); ylabel('Principal Components');
title('Ideal Case - Principal Components');
set(gca,'xlim', [1 6], 'Fontsize',12)
subplot(2, 2, 2)
plot(1:numFrames1, positions1(2, :), 1:numFrames1, positions1(1,:));
legend('Z', 'planeXY')
xlabel('Time (# of frames)'); ylabel('Displacements (pixels)');
title('Ideal Case - Original Displacement Data');
set(gca,'Fontsize',12)
subplot(2, 2, 3)
plot(1:6, lambda1/sum(lambda1), 'ko', 'MarkerSize', 10, 'Linewidth', 2)
xlabel('Measurements'); ylabel('Energy Captured');
title('Ideal Case - Energy Distibution');
set(gca,'xlim', [1 6],'Fontsize',12)
subplot(2, 2, 4)
projections1 = U1' * positions1;
plot(1:numFrames1, projections1(1, :), 1:numFrames1, projections1(2, :));
legend('PC1', 'PC2');
xlabel('Time (# of frames)'); ylabel('Displacements (pixels)');
title('Ideal Case - Displacement After Projection');
set(gca,'Fontsize',12)
print('HW3IdealCase.png', '-dpng');

figure(2)
subplot(2, 2, 1)
plot(1:6, lambda2, 'ko', 'MarkerSize', 10, 'Linewidth', 2)
xlabel('Measurements'); ylabel('Principal Components');
title('Noisy Case - Principal Components');
set(gca,'xlim', [1 6],'Fontsize',12)
subplot(2, 2, 2)
plot(1:numFrames2, positions2(2, :), 1:numFrames2, positions2(1,:));
legend('Z', 'planeXY')
xlabel('Time (# of frames)'); ylabel('Displacements (pixels)');
title('Noisy Case - Original Displacement Data');
set(gca,'Fontsize',12)
subplot(2, 2, 3)
plot(1:6, lambda2/sum(lambda2), 'ko', 'MarkerSize', 10, 'Linewidth', 2)
xlabel('Measurements'); ylabel('Energy Captured');
title('Noisy Case - Energy Distibution');
set(gca,'xlim', [1 6],'Fontsize',12)
subplot(2, 2, 4)
projections2 = U2' * positions2;
plot(1:numFrames2, projections2(1, :), 1:numFrames2, projections2(2, :), 1:numFrames2, projections2(3, :), 1:numFrames2, projections2(4, :), 1:numFrames2, projections2(5, :));
legend('PC1', 'PC2', 'PC3', 'PC4', 'PC5');
xlabel('Time (# of frames)'); ylabel('Displacements (pixels)');
title('Noisy Case - Displacement After Projection');
set(gca,'Fontsize',12)
print('HW3NoisyCase.png', '-dpng');

figure(3)
subplot(2, 2, 1)
plot(1:6, lambda3, 'ko', 'MarkerSize', 10, 'Linewidth', 2)
xlabel('Measurements'); ylabel('Principal Components');
title('Horizontal Displacement Case - Principal Components');
set(gca,'xlim', [1 6],'Fontsize',12)
subplot(2, 2, 2)
plot(1:numFrames3, positions3(2, :), 1:numFrames3, positions3(1,:));
legend('Z', 'planeXY')
xlabel('Time (# of frames)'); ylabel('Displacements (pixels)');
title('Horizontal Displacement Case - Original Displacement Data');
set(gca,'Fontsize',12)
subplot(2, 2, 3)
plot(1:6, lambda3/sum(lambda3), 'ko', 'MarkerSize', 10, 'Linewidth', 2)
xlabel('Measurements'); ylabel('Energy Captured');
title('Horizontal Displacement Case - Energy Distibution');
set(gca,'xlim', [1 6],'Fontsize',12)
subplot(2, 2, 4)
projections3 = U3' * positions3;
plot(1:numFrames3, projections3(1, :), 1:numFrames3, projections3(2, :), 1:numFrames3, projections3(3, :), 1:numFrames3, projections3(4, :));
legend('PC1', 'PC2', 'PC3', 'PC4');
xlabel('Time (# of frames)'); ylabel('Displacements (pixels)');
title('Horizontal Displacement Case - Displacement After Projection');
set(gca,'Fontsize',12)
print('HW3HorizontalCase.png', '-dpng');

figure(4)
subplot(2, 2, 1)
plot(1:6, lambda4, 'ko', 'MarkerSize', 10, 'Linewidth', 2)
xlabel('Measurements'); ylabel('Principal Components');
title('Horizontal Displacement & Rotation Case - Principal Components');
set(gca,'xlim', [1 6],'Fontsize',12)
subplot(2, 2, 2)
plot(1:numFrames4, positions4(2, :), 1:numFrames4, positions4(1,:));
legend('Z', 'planeXY')
xlabel('Time (# of frames)'); ylabel('Displacements (pixels)');
title('Horizontal Displacement & Rotation Case - Original Displacement Data');
set(gca,'Fontsize',12)
subplot(2, 2, 3)
plot(1:6, lambda4/sum(lambda4), 'ko', 'MarkerSize', 10, 'Linewidth', 2)
xlabel('Measurements'); ylabel('Energy Captured');
title('Horizontal Displacement & Rotation Case - Energy Distibution');
set(gca,'xlim', [1 6],'Fontsize',12)
subplot(2, 2, 4)
projections4 = U4' * positions4;
plot(1:numFrames4, projections4(1, :), 1:numFrames4, projections4(2, :), 1:numFrames4, projections4(3, :));
legend('PC1', 'PC2', 'PC3');
xlabel('Time (# of frames)'); ylabel('Displacements (pixels)');
title('Horizontal Displacement & Rotation Case - Displacement After Projection');
set(gca,'Fontsize',12)
print('HW3HorizontalRotationCase.png', '-dpng');