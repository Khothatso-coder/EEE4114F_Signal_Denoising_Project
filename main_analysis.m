%% Importing noisy signals
[yL,fsL] = audioread('sf1_n0L.wav');
[yH,fsH] = audioread('sf1_n0H.wav');
fs = fsL;

%% Detecting pauses in signals
highNoise_pauses = pause_Detection(yH,fs);
lowNoise_pauses = pause_Detection(yL,fs);


%% filtering with obtained noise spectrum estimation
yL_filtered = butterworthfilter(yL,fs);
yH_filtered = butterworthfilter(yH,fs);




%% calculating SNR
snr_H = calculate_snr(yH,18304,19204);
snr_L = calculate_snr(yL,18304,19204);
snr_Hf = calculate_snr(yH_filtered,18304,19204);
snr_Lf = calculate_snr(yL_filtered,18304,19204);
disp("Signal to noise ration of original signal with high noise: "+snr_H);
disp("Signal to noise ration of original signal with low noise: "+snr_L);
disp("Signal to noise ration of filtered signal with high noise: "+snr_Hf);
disp("Signal to noise ration of filtered signal with low noise: "+snr_Lf);


function filtered_signal = butterworthfilter(signal,fs)
    [b,a] = butter(4,[2200 3400]/(fs/2),'stop');
    [b1,a1] = butter(4,500/(fs/2),"high");
    stopfiltered = filter(b,a,signal);
    filtered_signal = filter(b1,a1,stopfiltered);
    N = length(filtered_signal);
    t=(0:N-1)/fs;
    figure;
    %plot(t,filtered_signal),title("Cascaded bandstop and high pass filtered signal"),ylim([-0.6 0.6]),xlabel("Time [s]"),ylabel("magnitude");
end

function snr = calculate_snr(signal,pauseStart,pauseEnd)
    noise = signal([pauseStart:pauseEnd,1]);
    noise_power = calc_power(noise);
    signal_power = calc_power(signal);
    pure_signal_power = signal_power - noise_power;
    snr = 10*log10(pure_signal_power/noise_power);
end

function truncated_signal = truncate(signal,start,stop)
    truncated_signal = signal([start:stop,1]);
end

function pauses = pause_Detection(signal,fs)
    speechIdx = detectSpeech(signal,fs);
    n = length(signal);
    numIdx = size(speechIdx,1);
    if (numIdx > 1)
        pauses(1,1) = 1;
        pauses(1,2) = speechIdx(1,1);
        for i = 1:length(speechIdx)-1
            pauses(i+1,1) = speechIdx(i,2);
            pauses(i+1,2) = speechIdx(i+1,1);
        end
        pauses(numIdx+1,1) = speechIdx(numIdx,2); 
        pauses(numIdx+1,2) = n;
    else
        pauses(1,1) = 1; 
        pauses(1,2) = speechIdx(1,1);
        pauses(2,1) = speechIdx(1,2); 
        pauses(2,2) = n;
    end
    for i = 1:size(pauses,1)
        y_pause = truncate(signal,pauses(i,1),pauses(i,2));
        N = length(y_pause);
        df = fs/N;
        w = (-(N/2):(N/2)-1)*df;
        Y_pause = fft(y_pause(:,1),N)/N;
        %figure;
        %plot(w,(abs(fftshift(Y_pause)))),title("Frequency spectrum of Pause"+i+" "+title),xlabel("Frequency [Hz]"),ylabel("Magnitude");
    end
end

function power = calc_power(signal)
    dft_signal = fft(signal);
    energy = sum(abs(dft_signal).^2);
    power = energy/(length(dft_signal)^2);  
end

