clear; clc; close all;
figure(1)
[y, Fs] = audioread('Floyd.m4a');
tr_gnr = length(y)/Fs; % record time in seconds
% plot((1:length(y))/Fs,y);
% xlabel('Time [sec]'); ylabel('Amplitude');
% title('Sweet Child O Mine');
% p8 = audioplayer(y,Fs); playblocking(p8);

y = y.';

a = 6000;
tau = 0:1:tr_gnr;

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

pcolor(tau,ks,ygt_spec(1:end-1,:))
shading interp
set(gca,'ylim',[0 1000],'Fontsize',20)
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (k)')
title('Spectrogram of "Comfortably Numb"');
print('HW2Floyd.png', '-dpng');

% problem 2

figure(2)
pcolor(tau,ks,ygt_spec(1:end-1,:))
shading interp
set(gca,'ylim',[0 200],'Fontsize',20)
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (k)')
title('Bass Frequency');
yticks([0 50 82 97 110 123 150 200]);
yticklabels({0, 50, 'E', 'G', 'A', 'B', 150, 200});
print('HW2FloydBass.png', '-dpng');

% problem 3

figure(3)
pcolor(tau,ks,ygt_spec(1:end-1,:))
shading interp
set(gca,'ylim',[200 1000],'Fontsize',20)
colormap(hot)
colorbar
xlabel('time (t)'), ylabel('frequency (k)')
title('Guitar Frequency');
yticks([200 391 440 587 659 740 1000]);
yticklabels({0,'G','A','D','E','F^#',1000});
print('HW2FloydGuitar.png', '-dpng');
