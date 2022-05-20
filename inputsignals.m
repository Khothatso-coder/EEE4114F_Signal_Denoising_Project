%% Read in the sound data
[y,fs] = audioread('sf1_cln.wav');
[yn,fsn] = audioread('sf1_n0L.wav');

N = length(y);
t=(0:N-1)/fs;
df = fs/N;
w = (-(N/2):(N/2)-1)*df;

Y = fft(y(:,1),N)/N;
YN = fft(yn(:,1),N)/N;


%y_pause = yn([18000:19300,1]);
y_pause = yn([28450:29268,1]);
N1 = length(y_pause);
df1 = fs/N1;
w1 = (-(N1/2):(N1/2)-1)*df1;

Y_pause = fft(y_pause(:,1),N1)/N1;
figure;

%plot(t,y),title("Clean signal over time"),ylim([-0.6 0.6]),xlabel("Time [s]"),ylabel("Amplitude");
%plot(t,yn),title("Input Noisy Signal over time"),ylim([-0.6 0.6]),xlabel("Time [s]"),ylabel("Amplitude");
%plot(y_pause),title("Clean voice"),ylim([-0.6 0.6]);
%plot(w,(abs(fftshift(Y)))),title("Frequency spectrum of the clean signal"),xlabel("Frequency [Hz]"),ylabel("Magnitude");
%plot(w,(abs(fftshift(YN)))),title("Frequency spectrum of the noisy signal"),xlabel("Frequency [Hz]"),ylabel("Magnitude");
%plot(w1,(abs(fftshift(Y_pause)))),title("Noise fft");

%% NOTES
%though investigation: two pause periods were identified at the 
% ranges t=(1.125s:1.2s) and t=(1.77s:1.83s). Investigating the 
% spectral components at those times of the noisy signal spectral
%components of the noise were identified. Both found large spectral 
%components at 2.5KHz +- 500Hz and 0 +- 500Hz. Speach had a minimum 
%frequency present of 250Hz.
%
%thus we high pass at 250Hz and bandstop at 2.5KHz.

