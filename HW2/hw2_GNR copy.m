clear; clc; close all;
figure(1)
[y, Fs] = audioread('GNR.m4a');
tr_gnr = length(y)/Fs; % record time in seconds
% plot((1:length(y))/Fs,y);
% xlabel('Time [sec]'); ylabel('Amplitude');
% title('Sweet Child O Mine');
% p8 = audioplayer(y,Fs); playblocking(p8);

y = y.';

a = 1200;
tau = 0:0.1:tr_gnr;

n = length(y);
t2 = linspace(0,tr_gnr,n+1); t = t2(1:n);
k = (1/tr_gnr)*[0:n/2-1 -n/2:-1];
ks = fftshift(k);

for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); % Window function
   yg = g.*y;
   ygt = fft(yg);
   ygt_spec(:,j) = fftshift(abs(ygt)); % We don't want to scale it
end

pcolor(tau,ks,ygt_spec)
shading interp
set(gca,'ylim',[200 800],'Fontsize',20)
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (k)')
title('Spectrogram of "Sweet Child O '' Mine"');
yticks([277 370 415 523 698 740]);
yticklabels({'C^#','F^#','G^#','{C^#}^+','F','{F^#}^+'});
print('HW2GNR.png', '-dpng');