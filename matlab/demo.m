% demo of matlab version of remixaview
% 2013-06-28 Dan Ellis dpwe@ee.columbia,edu

% Load in mix and acapella as mono files
[dmix,sr] = mp3read('../Data/Duffy.WarwickAvenue.mp3',0,1);
[dcap,sr] = mp3read('../Data/duffy_-_warwick_avenue_acapella.mp3',0,1);

% Attempt to trim and resample the full version to line up as well
% as possible with the acapella
dmr = deskew(dmix, dcap);
% It gets better when you repeat it
dmr = deskew(dmr, dcap);
% resampling can't handle ratios below 10 ppm, will just skip
% beyond that.

% Do the short-time coupling filter estimation
tic; [noise, targ, filt, SNR, del, filts] = ...
          find_in_mix(dmr,dcap,sr,0.006,0.003); toc
%Delay = -0.012698 s
%SNR = 0.10487 dB
%Elapsed time is 80.684044 seconds.

% Listen to the residual (accompaniment)
soundsc(noise(1:20*sr), sr);

% Plot the time-local coupling filters
% filter IR tima base
tt = [1:size(filts,1)]/sr;
% times of individual short-time window
tw = 0.25*[1:size(filts,2)];
% plot
imagesc(tt,tw,filts'); axis('xy');
xlabel('time / sec')
ylabel('window time / sec')
title('local coupling filter impulse responses (cap -> mix)')
% scale down impulse response extremes
caxis([-2 2])
