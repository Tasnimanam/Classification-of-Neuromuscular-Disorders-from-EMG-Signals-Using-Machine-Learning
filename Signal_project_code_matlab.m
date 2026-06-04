%EMG signal(healthy,myopathy,neuropathy) processing and feature extraction

clc;clear all;close all;

% Reading Data from .txt tile and ploting the signal

figure;

subplot(311);%healthy
signal_H=load("C:\Users\user\OneDrive\Desktop\BSP Final project file\Data set (Physiobank)\emg_healthy.txt");
time_H=signal_H(:,1);
amplitude_H=signal_H(:,2);
plot(time_H,amplitude_H), 
title('Raw Data of Healthy EMG');
xlabel('Time (sec)'); ylabel('Amplitude');grid on;
axis([0 1 -1.5 1.5]);

subplot(312);%myopathy
signal_M=load("C:\Users\user\OneDrive\Desktop\BSP Final project file\Data set (Physiobank)\emg_myopathy.txt");
amplitude=signal_M(:,2);
amplitude_M=amplitude(1:50860);
time=signal_M(:,1);
time_M=time(1:50860);
plot(time_M,amplitude_M), 
title('Raw Data of Myopathy EMG');
xlabel('Time (sec)'); ylabel('Amplitude');grid on;
axis([0 1 -1.5 1.5]);

subplot(313);%neuropathy
signal_N=load("C:\Users\user\OneDrive\Desktop\BSP Final project file\Data set (Physiobank)\emg_neuropathy.txt");
amplitude=signal_N(:,2);
amplitude_N=amplitude(1:50860);
time=signal_N(:,1);
time_N=time(1:50860);
plot(time_N,amplitude_N); 
title('Raw Data of Neuropathy EMG');
xlabel('Time (sec)'); ylabel('Amplitude');grid on;
axis([0 1 -1.5 1.5]);

%sampling frequency
fs_healthy=4000;
fs_myopathy =4000;
fs_neuropathy =4000;

%Nyquist frequency
fnq_H=fs_healthy/2; 
fnq_M=fs_myopathy/2;
fnq_N=fs_neuropathy/2;


% Removing noise

%Removing 50 Hz noise of powerline interference
q=35;%Q factor
fc=50;%cut off frequency of bandstop filter
%Healthy
wo_H=fc/(fs_healthy/2);bw_H=wo_H/q;
[b_H,a_H]=iirnotch(wo_H,bw_H);
filtered_sig_H=filtfilt(b_H,a_H,amplitude_H);
%Myopathy
wo_M=fc/(fs_myopathy/2);bw_M=wo_M/q;
[b_M,a_M]=iirnotch(wo_M,bw_M);
filtered_sig_M=filtfilt(b_M,a_M,amplitude_M);
%Neuropathy
wo_N=fc/(fs_neuropathy/2);bw_N=wo_N/q;
[b_N,a_N]=iirnotch(wo_N,bw_N);
filtered_sig_N=filtfilt(b_N,a_N,amplitude_N);

%single sided amplitude spectrum(frequency domain feature)
% Perform FFT to find cut off frequencies for bandpass filter to remove noise
figure;

subplot(311);%healthy
EMG_H = filtered_sig_H;
L=length(EMG_H);f=(0:L/2)*fs_healthy/L
fft_EMG_H = fft(EMG_H);
fft_EMG_H=abs(fft_EMG_H)/L;
fft_EMG_H=fft_EMG_H(1:L/2+1);
fft_EMG_H(2:end-1)=2*fft_EMG_H(2:end-1);
plot(f,fft_EMG_H);xlabel('Frequency(Hz)'); ylabel('Amplitude');grid on; 
title('(FFT) Single-Sided Amplitude Spectrum of Healthy EMG');

subplot (312)%myopathy
EMG_M = filtered_sig_M;
L=length(EMG_M);
f=(0:L/2)*fs_myopathy/L
fft_EMG_M= fft(EMG_M);
fft_EMG_M=abs(fft_EMG_M)/L ;
fft_EMG_M=fft_EMG_M(1:L/2+1);
fft_EMG_M(2:end-1)=2*fft_EMG_M(2:end-1);
plot(f,fft_EMG_M);xlabel('Frequency(Hz)'); ylabel('Amplitude'); grid on;
title('(FFT) Single-Sided Amplitude Spectrum of Myopathy EMG');

subplot (313)%neuropathy
EMG_N = filtered_sig_N;
L=length(EMG_N);
f=(0:L/2)*fs_neuropathy/L
fft_EMG_N = fft(EMG_N);
fft_EMG_N=abs(fft_EMG_N)/L;
fft_EMG_N=fft_EMG_N(1:L/2+1);
fft_EMG_N(2:end-1)=2*fft_EMG_N(2:end-1);
plot(f,fft_EMG_N);xlabel('Frequency(Hz)'); ylabel('Amplitude'); grid on;
title('(FFT) Single-Sided Amplitude Spectrum of Neuropathy EMG');

% Bandpass filter
figure;

subplot(311);%healthy
fcuthigh_H=10;fcutlow_H=500;
[b,a]=butter(6,[fcuthigh_H,fcutlow_H]/fnq_H,'bandpass');
filtered_emg_H= filtfilt(b,a,EMG_H);%Zero-phase digital filtering
plot(time_H,filtered_emg_H);
axis([0 1 -1.5 1.5]);
title('Filtered Healthy EMG signal with notch(50Hz) and bandpass filter');
xlabel('Time (sec)'); ylabel('Amplitude');grid on;

subplot(312);%myopathy
fcuthigh_M=20;fcutlow_M=1000;
[b,a]=butter(6,[fcuthigh_M,fcutlow_M]/fnq_M,'bandpass');
filtered_emg_M= filtfilt(b,a,EMG_M);%Zero-phase digital filtering
plot(time_M,filtered_emg_M);
axis([0 1 -1.5 1.5]);
title('Filtered EMG-Myopathy signal with notch(50Hz) and bandpass filter');
xlabel('Time (sec)'); ylabel('Amplitude');grid on;

subplot(313);%neuropathy
fcuthigh_N=20;fcutlow_N=1000;
[b,a]=butter(6,[fcuthigh_N,fcutlow_N]/fnq_N,'bandpass');
filtered_emg_N= filtfilt(b,a,EMG_N);%Zero-phase digital filtering
plot(time_N,filtered_emg_N);
axis([0 1 -1.5 1.5]);
title('Filtered EMG-Neuropathy signal with notch(50Hz) and bandpass filter');
xlabel('Time (sec)'); ylabel('Amplitude');grid on;

% Feature extraction

figure;
subplot(311);%healthy
%Full wave rectification
rec_signal_H=abs(filtered_emg_H);
plot(time_H,rec_signal_H);hold on;
%RMS envelope (moving average)- mean power of signal
window=50; % window size 
rms_envelop_H=sqrt(movmean((rec_signal_H.^2),window));
plot(time_H,rms_envelop_H,'r','linewidth',1);
xlabel('Time (sec)'); ylabel('Amplitude'); 
title('Rectified signal and RMS envelop of Healthy EMG signal');
legend('Rectified signal','RMS envelop', 'location', 'Northeast');
grid on;axis([0 1 -0.1 1.5]);

subplot(312);%myopathy
%Full wave rectification
rec_signal_M=abs(filtered_emg_M);
plot(time_M,rec_signal_M);hold on;
%RMS envelope (moving average)- mean power of signal
window=50; % window size 
envelop_M=sqrt(movmean((rec_signal_M.^2),window));
plot(time_M,envelop_M,'r','linewidth',1);
xlabel('Time (sec)'); ylabel('Amplitude');grid on; 
title('Rectified signal and RMS envelop of Myopathy EMG signal');
legend('Rectified signal','RMS envelop', 'location', 'Northeast');
axis([0 1 -0.1 1.5]);

subplot(313);%neuropathy
%Full wave rectification
rec_signal_N=abs(filtered_emg_N);
plot(time_N,rec_signal_N);hold on;
%RMS envelope (moving average)- mean power of signal
window=50; % window size in ms
envelop_N=sqrt(movmean((rec_signal_N.^2),window));
plot(time_N,envelop_N,'r','linewidth',1);
xlabel('Time (sec)'); ylabel('Amplitude'); 
title('Rectified signal and RMS envelop of Neuropathy EMG signal');
legend('Rectified signal','RMS envelop', 'location', 'Northeast');
grid on;axis([0 1 -0.1 1.5]);

%linear envelop(Rectified signal+ low pass filter)
figure;
low_pass_cutoff_frequency = 500;

subplot(311);%healthy
[b, a] = butter(5, low_pass_cutoff_frequency / (fs_healthy / 2), 'low');
linear_envelop_healthy = filtfilt(b, a, rec_signal_H);
plot(time_H,linear_envelop_healthy);
axis([0 1 -0.1 1.5]);xlabel('Time (sec)'); ylabel('Amplitude');grid on; 
title('Linear envelop (low pass filtered rectified signal) of Healthy EMG');

subplot(312);%myopathy
[b, a] = butter(5, low_pass_cutoff_frequency / (fs_myopathy / 2), 'low');
linear_envelop_myopathy = filtfilt(b, a, rec_signal_M);
plot(time_M,linear_envelop_myopathy);
axis([0 1 -0.1 1.5]);xlabel('Time (sec)'); ylabel('Amplitude');grid on; 
title('Linear envelop (low pass filtered rectified signal) of Myopathy EMG');

subplot(313)%neuropathy
[b, a] = butter(5, low_pass_cutoff_frequency / (fs_neuropathy / 2), 'low');
linear_envelop_neuropathy = filtfilt(b, a, rec_signal_N);
plot(time_N,linear_envelop_neuropathy);
axis([0 1 -0.1 1.5]);xlabel('Time (sec)'); ylabel('Amplitude');grid on; 
title('Linear envelop (low pass filtered rectified signal) of Neuropathy EMG');

% Save linear envelope
save('linear_envelope_healthy.mat', 'linear_envelop_healthy');
save('linear_envelope_myopathy.mat', 'linear_envelop_myopathy');
save('linear_envelope_neuropathy.mat', 'linear_envelop_neuropathy');

% frequency domain feature extraction
figure;
subplot(311);
N=length(linear_envelop_healthy);
fft_H = fft(linear_envelop_healthy);
fft_H = fft_H(1:N/2+1);
psd_H = (1/(fs_healthy*N)) * abs(fft_H).^2;
psd_H(2:end-1) = 2*psd_H(2:end-1);
freq = 0:fs_healthy/N:fs_healthy/2;
plot(freq,10*log10(psd_H));%converts the PSD to decibels(log scale) for better visualization
grid on;title(' Power spectrum of Healthy EMG');
xlabel('Frequency (Hz)');ylabel('Power/Frequency (dB/Hz)');

subplot(312);
N=length(linear_envelop_myopathy);
fft_M = fft(linear_envelop_myopathy) ;
fft_M = fft_M(1:N/2+1) ;
psd_M = (1/(fs_myopathy*N)) * abs(fft_M).^2 ;
psd_M(2:end-1) = 2*psd_M(2:end-1);
freq = 0:fs_myopathy/N:fs_myopathy/2;
plot(freq,10*log10(psd_M));%converts the PSD to decibels(log scale) for better visualization
grid on;title(' Power spectrum of Myopathy EMG');
xlabel('Frequency (Hz)');ylabel('Power/Frequency (dB/Hz)');

subplot(313);
N=length(linear_envelop_neuropathy);
fft_N = fft(linear_envelop_neuropathy);
fft_N = fft_N(1:N/2+1);
psd_N = (1/(fs_neuropathy*N)) * abs(fft_N).^2;
psd_N(2:end-1) = 2*psd_N(2:end-1);
freq = 0:fs_neuropathy/N:fs_neuropathy/2;
plot(freq,10*log10(psd_N));%converts the PSD to decibels for better visualization
grid on;title(' Power spectrum of Neuropathy EMG');
xlabel('Frequency (Hz)');ylabel('Power/Frequency (dB/Hz)');


% Values for healthy data
total_samples_healthy = 50860;
sampling_frequency_healthy = 4000;
total_time_healthy =  12.71;
num_epochs = 12; 
% Calculate duration of each epoch for healthy data
epoch_duration_healthy = total_time_healthy / num_epochs;

% Calculate number of samples per epoch for healthy data
samples_per_epoch_healthy = (epoch_duration_healthy * sampling_frequency_healthy);

% Segment the healthy dataset into epochs
for i = 1:num_epochs
    start_index = (i - 1) * samples_per_epoch_healthy + 1;
    end_index = min(i * samples_per_epoch_healthy, length(linear_envelop_healthy));
    epoch_data_healthy = linear_envelop_healthy(start_index:end_index);  % Extract data for the current epoch
    epochs_healthy{i} = epoch_data_healthy;
end

% Plotting segmented epochs for healthy data
figure;
for i = 1:6
    subplot(6, 1, i);
    plot(epochs_healthy{i});
    title(['Healthy Epoch ', num2str(i)]);
    xlabel('Sample');
    ylabel('Amplitude');
    grid on;
end

figure;
for i = 7:12
    subplot(6, 1, i-6);
    plot(epochs_healthy{i});
    title(['Healthy Epoch ', num2str(i)]);
    xlabel('Sample');
    ylabel('Amplitude');
    grid on;
end

% Feature extraction of each epoch for healthy data
for i = 1:num_epochs
    epoch_data_healthy = epochs_healthy{i};
    variance_healthy(i) = var(epoch_data_healthy);%variance calculation
    rms_healthy(i) = sqrt(mean(epoch_data_healthy.^2)); % RMS calculation
    arv_filtered_emg_healthy(i) = mean(epoch_data_healthy); % ARV calculation
    skewness_healthy(i) = skewness(epoch_data_healthy);%skewness calculation
    kurtosis_healthy(i) = kurtosis(epoch_data_healthy);%kurtosis calculation
    max_amplitude_healthy(i)=max(epoch_data_healthy);%maximum amplitude calculation
    % Create time vector for integration
    epoch_time_healthy = (0:length(epoch_data_healthy)-1) / fs_healthy; % Relative time vector for each epoch
    integration_value_healthy(i) = trapz(epoch_time_healthy, epoch_data_healthy); % Integration calculation
    % Peak detection
        threshold = 0.002 * max(epoch_data_healthy);
        sig_length=length(epoch_data_healthy);
        Total_peak_healthy=0;
        for j=1:1:sig_length
           if (epoch_data_healthy(j) > threshold)
            Total_peak_healthy=1+Total_peak_healthy;
          end
       end
    % Store values for all epochs for healthy data
    all_rms_healthy(i) = rms_healthy(i);
    all_arv_healthy(i) = arv_filtered_emg_healthy(i);
    all_integration_healthy(i) = integration_value_healthy(i);
    all_variance_healthy(i) = variance_healthy(i);
    all_skewness_healthy(i) = skewness_healthy(i);
    all_kurtosis_healthy(i) = kurtosis_healthy(i);
    all_max_amplitude_healthy(i) = max_amplitude_healthy(i);
    all_total_peaks_healthy(i) = Total_peak_healthy;
    fprintf('Epoch_healthy %d - RMS: %.4f, ARV: %.4f,Max amplitude:%.4f, Integration: %.4f, Variance: %.4f,Skewness:%.4f,Kurtosis:%.4f, Total Peaks: %d\n', ...
        i, rms_healthy(i), arv_filtered_emg_healthy(i),max_amplitude_healthy(i), integration_value_healthy(i), variance_healthy(i),skewness_healthy(i),kurtosis_healthy(i), Total_peak_healthy);
        
end

avg_rms_healthy = mean(all_rms_healthy);
avg_arv_healthy = mean(all_arv_healthy);
avg_integration_healthy = mean(all_integration_healthy);
avg_variance_healthy = mean(all_variance_healthy);
avg_skewness_healthy = mean(all_skewness_healthy);
avg_kurtosis_healthy = mean(all_kurtosis_healthy);
avg_max_amplitude_healthy=mean(all_max_amplitude_healthy);
avg_total_peaks_healthy = mean(all_total_peaks_healthy);

% Display average values for Healthy data
fprintf('\nAverage across all epochs of healthy data:\n');
fprintf('RMS: %.4f\n', avg_rms_healthy);
fprintf('ARV: %.4f\n', avg_arv_healthy);
fprintf('Integration: %.4f\n', avg_integration_healthy);
fprintf('Variance: %.4f\n', avg_variance_healthy);
fprintf('Skewness: %.4f\n', avg_skewness_healthy);
fprintf('Kurtosis: %.4f\n', avg_kurtosis_healthy);
fprintf('Max Amplitude:%.4f\n',avg_max_amplitude_healthy);
fprintf('Total Peaks: %.4f\n', avg_total_peaks_healthy);


% Values for Myopathy data
total_samples_myopathy = 50860;
sampling_frequency_myopathy = 4000;
total_time_myopathy =  12.71;
num_epochs = 12; 
% Calculate duration of each epoch for Myopathy data
epoch_duration_myopathy = total_time_myopathy / num_epochs;

% Calculate number of samples per epoch for Myopathy data
samples_per_epoch_myopathy = (epoch_duration_myopathy * sampling_frequency_myopathy);

% Segment the Myopathy dataset into epochs
for i = 1:num_epochs
    start_index = (i - 1) * samples_per_epoch_myopathy + 1;
    end_index = min(i * samples_per_epoch_myopathy, length(linear_envelop_myopathy));
    epoch_data_myopathy = linear_envelop_myopathy(start_index:end_index);  % Extract data for the current epoch
    epochs_myopathy{i} = epoch_data_myopathy;
end

% Plotting segmented epochs for Myopathy data
figure;
for i = 1:6
    subplot(6, 1, i);
    plot(epochs_myopathy{i});
    title(['Myopathy Epoch ', num2str(i)]);
    xlabel('Sample');
    ylabel('Amplitude');
    grid on;
end

figure;
for i = 7:12
    subplot(6, 1, i-6);
    plot(epochs_myopathy{i});
    title(['Myopathy Epoch ', num2str(i)]);
    xlabel('Sample');
    ylabel('Amplitude');
    grid on;
end

% Feature extraction of each epoch for Myopathy data
for i = 1:num_epochs
    epoch_data_myopathy = epochs_myopathy{i};
    variance_myopathy(i) = var(epoch_data_myopathy);%variance calculation
    rms_myopathy(i) = sqrt(mean(epoch_data_myopathy.^2)); % RMS calculation
    arv_filtered_emg_myopathy(i) = mean(epoch_data_myopathy); % ARV calculation
    skewness_myopathy(i) = skewness(epoch_data_myopathy);%skewness calculation
    kurtosis_myopathy(i) = kurtosis(epoch_data_myopathy);%kurtosis calculation
    max_amplitude_myopathy(i)=max(epoch_data_myopathy);%maximum amplitude calculation
    % Create time vector for integration
    epoch_time_myopathy = (0:length(epoch_data_myopathy)-1) / fs_myopathy; % Relative time vector for each epoch
    integration_value_myopathy(i) = trapz(epoch_time_myopathy, epoch_data_myopathy); % Integration calculation
    % Peak detection
        threshold = 0.002 * max(epoch_data_myopathy);
        sig_length=length(epoch_data_myopathy);
        Total_peak_myopathy=0;
        for j=1:1:sig_length
           if (epoch_data_myopathy(j) > threshold)
            Total_peak_myopathy=1+Total_peak_myopathy;
          end
       end
    % Store values for all epochs for Myopathy data
    all_rms_myopathy(i) = rms_myopathy(i);
    all_arv_myopathy(i) = arv_filtered_emg_myopathy(i);
    all_integration_myopathy(i) = integration_value_myopathy(i);
    all_variance_myopathy(i) = variance_myopathy(i);
    all_total_peaks_myopathy(i) = Total_peak_myopathy;
    all_skewness_myopathy(i) = skewness_myopathy(i);
    all_kurtosis_myopathy(i) = kurtosis_myopathy(i);
    all_max_amplitude_myopathy(i) = max_amplitude_myopathy(i);
    fprintf('Epoch_myopathy %d - RMS: %.4f, ARV: %.4f,Max amplitude:%.4f, Integration: %.4f, Variance: %.4f,Skewness:%.4f,Kurtosis:%.4f,Total Peaks: %d\n', ...
        i, rms_myopathy(i), arv_filtered_emg_myopathy(i),max_amplitude_myopathy(i), integration_value_myopathy(i), variance_myopathy(i),skewness_myopathy(i),kurtosis_myopathy(i), Total_peak_myopathy);
end

% Calculate average values across all epochs for Myopathy data
avg_rms_myopathy = mean(all_rms_myopathy);
avg_arv_myopathy = mean(all_arv_myopathy);
avg_integration_myopathy = mean(all_integration_myopathy);
avg_variance_myopathy = mean(all_variance_myopathy);
avg_skewness_myopathy = mean(all_skewness_myopathy);
avg_kurtosis_myopathy = mean(all_kurtosis_myopathy);
avg_max_amplitude_myopathy = mean(all_max_amplitude_myopathy);
avg_total_peaks_myopathy = mean(all_total_peaks_myopathy);

% Display average values for Myopathy data
fprintf('\nAverage across all epochs of myopathy data:\n');
fprintf('RMS: %.4f\n', avg_rms_myopathy);
fprintf('ARV: %.4f\n', avg_arv_myopathy);
fprintf('Integration: %.4f\n', avg_integration_myopathy);
fprintf('Variance: %.4f\n', avg_variance_myopathy);
fprintf('Skewness: %.4f\n', avg_skewness_myopathy);
fprintf('Kurtosis: %.4f\n', avg_kurtosis_myopathy);
fprintf('Max amplitude: %.4f\n', avg_max_amplitude_myopathy);
fprintf('Total Peaks: %.4f\n', avg_total_peaks_myopathy);

% Values for  Neuropathy data
total_samples_neuropathy = 50860;
sampling_frequency_neuropathy = 4000;
total_time_neuropathy =  12.71;
num_epochs = 12; 
% Calculate duration of each epoch for Neuropathy data
epoch_duration_neuropathy = total_time_neuropathy / num_epochs;

% Calculate number of samples per epoch for Neuropathy data
samples_per_epoch_neuropathy = (epoch_duration_neuropathy * sampling_frequency_neuropathy);

% Segment the Neuropathy dataset into epochs
for i = 1:num_epochs
    start_index = (i - 1) * samples_per_epoch_neuropathy + 1;
    end_index = min(i * samples_per_epoch_neuropathy, length(linear_envelop_neuropathy));
    epoch_data_neuropathy = linear_envelop_neuropathy(start_index:end_index);  % Extract data for the current epoch
    epochs_neuropathy{i} = epoch_data_neuropathy;
end

% Plotting segmented epochs for Neuropathy data
figure;
for i = 1:6
    subplot(6, 1, i);
    plot(epochs_neuropathy{i});
    title(['Neuropathy Epoch ', num2str(i)]);
    xlabel('Sample');
    ylabel('Amplitude');
    grid on;
end

figure;
for i = 7:12
    subplot(6, 1, i-6);
    plot(epochs_neuropathy{i});
    title(['Neuropathy Epoch ', num2str(i)]);
    xlabel('Sample');
    ylabel('Amplitude');
    grid on;
end

% Feature extraction of each epoch for Neuropathy data
for i = 1:num_epochs
    epoch_data_neuropathy = epochs_neuropathy{i};
    variance_neuropathy(i) = var(epoch_data_neuropathy);%variance calculation
    rms_neuropathy(i) = sqrt(mean(epoch_data_neuropathy.^2)); % RMS calculation
    arv_filtered_emg_neuropathy(i) = mean(epoch_data_neuropathy); % ARV calculation
    skewness_neuropathy(i) = skewness(epoch_data_neuropathy);%skewness calculation
    kurtosis_neuropathy(i) = kurtosis(epoch_data_neuropathy);%kurtosis calculation
    max_amplitude_neuropathy(i)=max(epoch_data_neuropathy);%maximum amplitude calculation
    % Create time vector for integration
    epoch_time_neuropathy = (0:length(epoch_data_neuropathy)-1) / fs_neuropathy; % Relative time vector for each epoch
    integration_value_neuropathy(i) = trapz(epoch_time_neuropathy, epoch_data_neuropathy); % Integration calculation
    % Peak detection
        threshold = 0.002 * max(epoch_data_neuropathy);
        sig_length=length(epoch_data_neuropathy);
        Total_peak_neuropathy=0;
        for j=1:1:sig_length
           if (epoch_data_neuropathy(j) > threshold)
            Total_peak_neuropathy=1+Total_peak_neuropathy;
          end
       end
    % Store values for all epochs for Neuropathy data
    all_rms_neuropathy(i) = rms_neuropathy(i);
    all_arv_neuropathy(i) = arv_filtered_emg_neuropathy(i);
    all_integration_neuropathy(i) = integration_value_neuropathy(i);
    all_variance_neuropathy(i) = variance_neuropathy(i);
    all_skewness_neuropathy(i) = skewness_neuropathy(i);
    all_kurtosis_neuropathy(i) = kurtosis_neuropathy(i);
    all_max_amplitude_neuropathy(i)=max_amplitude_neuropathy(i);
    all_total_peaks_neuropathy(i) = Total_peak_neuropathy;
    
    fprintf('Epoch_Neuropathy %d - RMS: %.4f, ARV: %.4f,Max amplitude:%.4f, Integration: %.4f, Variance: %.4f,Skewness: %.4f,Kurtosis: %.4f, Total Peaks: %d\n', ...
        i, rms_neuropathy(i), arv_filtered_emg_neuropathy(i),max_amplitude_neuropathy(i), integration_value_neuropathy(i), variance_neuropathy(i),skewness_neuropathy(i),kurtosis_neuropathy(i),Total_peak_neuropathy);
end
% Calculate average values across all epochs for Neuropathy data

avg_rms_neuropathy = mean(all_rms_neuropathy);
avg_arv_neuropathy = mean(all_arv_neuropathy);
avg_integration_neuropathy = mean(all_integration_neuropathy);
avg_variance_neuropathy = mean(all_variance_neuropathy);
avg_skewness_neuropathy = mean(all_skewness_neuropathy);
avg_kurtosis_neuropathy = mean(all_kurtosis_neuropathy);
avg_max_amplitude_neuropathy=mean(all_max_amplitude_neuropathy);
avg_total_peaks_neuropathy = mean(all_total_peaks_neuropathy);

% Display average values for Neuropathy data
fprintf('\nAverage across all epochs of neuropathy data:\n');
fprintf('RMS: %.4f\n', avg_rms_neuropathy);
fprintf('ARV: %.4f\n', avg_arv_neuropathy);
fprintf('Integration: %.4f\n', avg_integration_neuropathy);
fprintf('Variance: %.4f\n', avg_variance_neuropathy);
fprintf('Skewness: %.4f\n', avg_skewness_neuropathy);
fprintf('Kurtosis: %.4f\n', avg_kurtosis_neuropathy);
fprintf('Max amplitude:%.4f\n',avg_max_amplitude_neuropathy);
fprintf('Total Peaks: %.4f\n', avg_total_peaks_neuropathy);



%Matrix
Feature_matrix=[ 0.0539, 0.0358,0.0379, 0.0016, 4197, 0;
                 0.0656, 0.0413,0.0438, 0.0026, 4154, 0;
                 0.0492, 0.0318,0.0336, 0.0014, 4172, 0;
                 0.1126, 0.0623,0.0660, 0.0088, 4127, 0;
                 0.0518, 0.0358,0.0379, 0.0014, 4169, 0;
                 0.0487, 0.0315,0.0333, 0.0014, 4155, 0;
                 0.0489, 0.0321,0.0340,0.0014,  4141, 0;
                 0.0610, 0.0372,0.0394, 0.0023, 4147 ,0;
                 0.0466, 0.0318,0.0337, 0.0012, 4186 ,0;
                 0.0705, 0.0441,0.0467, 0.0030, 4131 ,0;
                 0.0602, 0.0375, 0.0397,0.0022, 4153 ,0;
                 0.0523, 0.0341, 0.0361,0.0016, 4167 ,0;
                 0.0757, 0.0492, 0.0521, 0.0033, 4156, 1;
                 0.0789, 0.0505, 0.0535, 0.0037, 4157, 1;
                 0.0831, 0.0568, 0.0602, 0.0037, 4179, 1;
                 0.0798, 0.0537, 0.0569, 0.0035, 4155, 1;
                 0.0828, 0.0553, 0.0586, 0.0038, 4166, 1;
                 0.0817, 0.0547, 0.0579, 0.0037, 4161 ,1;
                 0.0793, 0.0543, 0.0575, 0.0033, 4166 ,1;
                 0.0768, 0.0530, 0.0561, 0.0031, 4185 ,1;
                 0.0814, 0.0560, 0.0593, 0.0035, 4170 ,1;
                 0.0845, 0.0556, 0.0589, 0.0040, 4177 ,1;
                 0.0813, 0.0566, 0.0599, 0.0034, 4192 ,1;
                 0.0837, 0.0559, 0.0592, 0.0039, 4193 ,1;
                 0.2536, 0.1090, 0.1153, 0.0524, 3736, 2;
                 0.1965, 0.0855, 0.0905, 0.0313, 3998, 2;
                 0.1821, 0.0757, 0.0802, 0.0274, 3917, 2;
                 0.1924, 0.0811, 0.0859, 0.0304, 3907, 2;
                 0.1962, 0.0852, 0.0902, 0.0312, 3929, 2;
                 0.1862, 0.0790, 0.0837, 0.0284, 3949, 2;
                 0.1886, 0.0802, 0.0849, 0.0291, 3833, 2;
                 0.1824, 0.0760, 0.0804, 0.0275, 3959, 2;
                 0.1818, 0.0778, 0.0824, 0.0270, 3981 ,2;
                 0.1824, 0.0819, 0.0867, 0.0266, 4047 ,2;
                 0.2661, 0.1098, 0.1163, 0.0588, 3630 ,2;
                 0.6635, 0.3762, 0.3984, 0.2987, 4068 ,2] 
             
             
             
