% Read in the sound data 

[d,r] = audioread('sf1_n2H.wav'); % r is the sampling rate, d is the data 
%soundsc(d,r)
figure(1) 

plot(d),xlabel('samples'),ylabel('amplitude'),title('Mix signal'); 

fc = 1000; % cut-off frequency 

xd = wden(d,'modwtsqtwolog','s','mln',8,'sym8'); 

%soundsc(xd,r) 

figure(2) 

plot(xd), xlabel('samples'),ylabel('amplitude'),title('Output from Wavelet filter of sym8'); 
