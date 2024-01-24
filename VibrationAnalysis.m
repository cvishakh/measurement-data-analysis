%VibrationSensorData

%Reading_data_file
filePath = 'C:/Users/visha/Downloads/VibrationSensorData.xlsx';
num = readtable(filePath);

%Extracting x and y Values
xValues = num.Var2;
yValues = num.Var3;

% Assuming xValues and yValues are your datasets
validIndices = ~isnan(xValues) & ~isnan(yValues);
xValues = xValues(validIndices);
yValues = yValues(validIndices);


%Reading data
disp('xValues:');
disp(xValues);

disp('yValues:');
disp(yValues);


%........................................................................%
%Task 4:
% Creating a new plot 
figure(1);
plot(xValues, yValues, 'c');
title('Vibration Measurement Signal');
xlabel('Time(in sec)');
ylabel('Amplitude');
grid on;
hold on;

% 2. Check for Equidistance
dx = diff(xValues);
isEquidistant = all(abs(dx - dx(1)) < eps);

if isEquidistant
    disp('The x values are equidistant.');
else
    disp('The x values are not equidistant.');
end

% 3. Calculate the Derivative and Unique Values
deriv = gradient(xValues);
uniqueDeriv = unique(deriv);

% 4. Determine Differences
differences = diff(uniqueDeriv);
disp(['Differences between neighboring unique values: ', num2str(differences(:)')]);

%........................................................................%
%Task 5:
%Number of unique values
num_unique_values = length(unique(xValues));

%Mean value of unique values
mean_unique_value = mean(unique(xValues));

%Printing the results
fprintf('Number of unique values in x: %d\n', num_unique_values);
fprintf('Mean value of unique values in x: %.4f\n', mean_unique_value);

%Number of unique values with floating value accuracy
num_unique_values_simple = length(unique(xValues));

%Mean value of unique values with floating value accuracy
mean_unique_value_simple = mean(unique(xValues));


%Printing the results
fprintf('Number of unique values in x (with floating point accuracy): %d\n', num_unique_values_simple);
fprintf('Mean value of unique values in x (with floating point accuracy): %.4f\n', mean_unique_value_simple);

%Assuming the value x(2) - x(1) represents the time difference between successive samples
sampling_frequency = 1 / (xValues(2) - xValues(1));

fprintf('Estimated sampling frequency based on provided time difference: %.4f\n', sampling_frequency);

%FFT
signalLength = length(xValues);
signalsFrequencyDomain = fft(yValues);         % calculate fft
doubleSidedSpectra = abs(signalsFrequencyDomain) / signalLength * 2;    % FFT returns complex result, amplitude is the absolute value
frequency = (0:length(doubleSidedSpectra)-1)*sampling_frequency / signalLength; % Frequency vector in Hz
%Figure2
figure(2);
plot(frequency,doubleSidedSpectra,'blue','Marker','*','MarkerEdgeColor','r');


%Determine indices of dominant frequencies
threshold = 0.1 * max(abs(signalsFrequencyDomain)); % Adjust the threshold as needed
dominant_indices = find(abs(signalsFrequencyDomain) > threshold);

%Create a new complex frequency vector with only dominant frequencies
cleaned_frequencies = zeros(size(signalsFrequencyDomain));
cleaned_frequencies(dominant_indices) = signalsFrequencyDomain(dominant_indices);

% (1) Transform the cleaned complex frequency vector back into the time domain using ifft
reconstructed_signal = ifft(cleaned_frequencies);

%Visualize the result and compare with the original signal
% Plot the original signal and the reconstructed signal in the time domain
figure(3);
plot(xValues, yValues, 'b', 'DisplayName', 'Original Signal'); % Original signal
hold on;
plot(xValues, real(reconstructed_signal), 'r', 'DisplayName', 'Reconstructed Signal'); % Reconstructed signal (real part)
title('Comparison of Original and Reconstructed Signals');
xlabel('Time(in sec)');
ylabel('Amplitude of signal');
legend;
grid on;
hold off;

