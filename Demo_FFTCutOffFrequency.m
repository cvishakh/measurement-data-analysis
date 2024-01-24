
runFFT = false;

samplingFrequency = 100;                               % Sampling frequency in Hz
signalLength = 100;                                    % Number of data points
time = (0:signalLength-1) * 1 / samplingFrequency;     % Time vector in sec

signalFrequency1 =  2;       % in Hz
signalFrequency2 = 10;       % in Hz
signalFrequency3 = 20;       % in Hz

signalAmplitude = 0.9;       % no unit

% A = A0 * cos(w * t); with w = 2 * pi * f
x1 = signalAmplitude * cos(2 * pi * signalFrequency1 * time);     % First row wave
x2 = signalAmplitude * cos(2 * pi * signalFrequency2 * time);     % Second row wave
x3 = signalAmplitude * cos(2 * pi * signalFrequency3 * time);     % Third row wave

frequencies = [signalFrequency1;signalFrequency2;signalFrequency3];
signalsTimeDomain = [x1; x2; x3];

figure(1);
for i = 1:length(frequencies)
    subplot(length(frequencies),1,i)
    scatter(time,signalsTimeDomain(i,:),25,"b","filled");
    title(['Signal with frequency ',num2str(frequencies(i)),' Hz, sampled with ',num2str(samplingFrequency), ' Hz']);
    xlabel('time in sec')
    ylabel('amplitude')
    ylim([-1 1])
    grid on;
end

if(runFFT)
    signalsFrequencyDomain = fft(signalsTimeDomain,[],2);         % calculate fft
    doubleSidedSpectra = abs(signalsFrequencyDomain) / signalLength * 2;    % FFT returns complex result, amplitude is the absolute value
    frequency = (0:length(doubleSidedSpectra)-1)*samplingFrequency / signalLength; % Frequency vector in Hz

    figure(2);
    for i=1:length(frequencies)
        subplot(length(frequencies),1,i)
        scatter(frequency,doubleSidedSpectra(i,:),25,"r","filled");
        title(['FFT of signal with frequency ',num2str(frequencies(i)),' Hz, sampled with ',num2str(samplingFrequency), ' Hz']);
        ylim([0 1])
        xlabel('frequency in Hz')
        ylabel('amplitude')
        grid on;
    end
end
