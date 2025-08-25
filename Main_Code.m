%% Room Size Estimation from Recorded Audio
clc; clear;

%% Parameters
record_duration = 3;      % Duration in seconds
fs = 44100;               % Sampling frequency
alpha = 0.45;             % Average absorption coefficient
c = 6;                    % Surface area coefficient

%% Reset Java and Audio System (fixes detection issues)
clear java
clear classes
rehash toolboxcache
pause(1);  % Give MATLAB a second to reset

%% Record Audio
%% Load Pre-recorded Audio Instead of Recording
[clap, fs] = audioread('clap2.m4a');  % <-- Use your WAV file here
clap = clap / max(abs(clap));        % Normalize
audio = clap;

% Optional: Save normalized version for consistency
audiowrite('recorded_clap.wav', audio, fs);
disp('Clap audio loaded and normalized.');


%% Extract Room Impulse Response (RIR)
% For a simple impulse (e.g., clap), we assume the RIR is the initial part
% Extract the first N samples where energy is high
threshold = 0.1;
start_idx = find(abs(audio) > threshold, 1, 'first');
rir = audio(start_idx:end);
rir = rir / max(abs(rir));  % Normalize
t = (0:length(rir)-1) / fs;

%% Estimate RT60 (Schroeder Integration)
energy = flipud(cumsum(flipud(rir.^2)));  % Energy decay
edc_db = 10 * log10(energy / max(energy));  % Convert to dB

% Fit line to decay range (-5 dB to -35 dB)
idx = find(edc_db < -5 & edc_db > -35);
if length(idx) < 10
    error('Not enough decay data. Try clapping louder or longer.');
end

p = polyfit(t(idx), edc_db(idx), 1);
rt60 = -60 / p(1);  % RT60 in seconds

%% Estimate Room Volume Using Sabine Formula
record_duration = 3;      % Duration in seconds
fs = 44100;               % Sampling frequency
alpha = 0.45;             % Average absorption coefficient
c = 6;                   % Surface area coefficient
V = ((rt60 * alpha * c) / 0.161)^(3/2);

%% Results
fprintf('\nEstimated RT60: %.2f seconds\n', rt60);
fprintf('Estimated Room Volume: %.2f cubic meters\n', V);

%% Plot Energy Decay
figure;
plot(t, edc_db);
xlabel('Time (s)');
ylabel('Energy Decay (dB)');
title('Schroeder Energy Decay Curve');
grid on;
