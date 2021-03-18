% Clean workspace
clear all; close all; clc

load subdata.mat % Imports the data as the 262144x49 (space by time) matrix called subdata

L = 10; % spatial domain
n = 64; % Fourier modes
x2 = linspace(-L,L,n+1); x = x2(1:n); y =x; z = x;
k = (2*pi/(2*L))*[0:(n/2 - 1) -n/2:-1]; ks = fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

Utave  = zeros(1, n);

for j=1:49
Un(:,:,:)=reshape(subdata(:,j),n,n,n);
Ut(:,:,:) = fftn(Un(:,:,:));
Utave = Utave + Ut(:,:,:);
% M = max(abs(Un),[],'all');
% close all, isosurface(X,Y,Z,abs(Un)/M,0.7)
% axis([-20 20 -20 20 -20 20]), grid on, drawnow
% pause(1)
end

sz = [64 64 64];
Utave = fftshift(Utave)/49;
[M, I] = max(abs(Utave(:)),[],'all','linear');
[x0, y0, z0] = ind2sub(sz, I);
center(1) = Kx(x0, y0, z0);
center(2) = Ky(x0, y0, z0);
center(3) = Kz(x0, y0, z0);
% isosurface(X,Y,Z,abs(Utave)/max(abs(Utave), [], 'all'),0.7)

% Problem 2 
tau = 0.2;
x0 = center(1); y0 = center(2); z0 = center(3);
filter = exp(-tau*((Kx - x0).^2 + (Ky - y0).^2 + (Kz - z0).^2)); % Define the filter
indice = zeros(1);
sz = [64 64 64];

for i = 1:49
Un(:,:,:)=reshape(subdata(:,i),n,n,n);
Ut(:,:,:) = fftshift(fftn(Un(:,:,:)));
unft = filter.*Ut;
unf = ifftn(ifftshift(unft));
[M, indice(i)] = max(abs(unf(:)),[],'all','linear');
end

[xvector, yvector, zvector] = ind2sub(sz, indice);
path_x = Kx(xvector, yvector, zvector);
path_y = Ky(xvector, yvector, zvector);
path_z = Kz(xvector, yvector, zvector);

figure(2)
plot3(squeeze(path_x(1,:,1)), squeeze(path_y(:,1,1)), squeeze(path_z(1,1,:)), 'LineWidth', 2);
xlabel("x coordinate")
ylabel("y coordinate")
zlabel("z coordinate")
title("Path of the submarine")
set(gca, "fontsize", 15);
print('HW1Path.png', '-dpng');

