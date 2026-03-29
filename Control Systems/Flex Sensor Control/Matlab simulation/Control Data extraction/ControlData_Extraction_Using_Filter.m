clc; clear; close all;

%% ── 1. Component Values ───────────────────────────────────
R1 = 40;
R2 = 750;
R3 = 1000;
C1 = 100e-6;
C2 = 10e-6;

num_coeff = -1/(R1 * R2 * C1 * C2);

a2 = 1;
a1 = (1/R1 + 1/R2 + 1/R3) / C1;
a0 = 1 / (R2 * R3 * C1 * C2);

num = [num_coeff];
den = [a2, a1, a0];

sys = tf(num, den);

%% ── 2. Time Vector ────────────────────────────────────────
t = 0:0.001:10;   % 10 seconds

%% ── 3. Create NOISY FLEX SIGNAL ───────────────────────────
% Slow flex movement (desired signal)
flex = 0.2*sin(2*pi*1*t);

% Noise components
noise1 = 0.05*sin(2*pi*50*t);   % mains noise
noise2 = 0.02*sin(2*pi*120*t);  % higher freq noise
noise3 = 0.01*randn(size(t));   % random noise

% Total input signal
input_signal = flex + noise1 + noise2 + noise3;

%% ── 4. Pass through filter ────────────────────────────────
output = lsim(sys, input_signal, t);

%% ── 5. Rectification + Smoothing (DC extraction) ─────────
rectified = abs(output);

% Low-pass smoothing (envelope detection)
[b,a] = butter(2, 0.5/(1/0.001/2));  % cutoff ~2 Hz
dc_output = filtfilt(b,a,rectified);

%% ── 6. Plot Results ───────────────────────────────────────
figure;

subplot(3,1,1)
plot(t, input_signal)
title('Noisy Input Signal')
xlabel('Time (s)'), ylabel('Amplitude')

subplot(3,1,2)
plot(t, output)
title('Filtered Output (AC)')
xlabel('Time (s)'), ylabel('Amplitude')

subplot(3,1,3)
plot(t, dc_output)
title('Final DC-like Output (Flex Level)')
xlabel('Time (s)'), ylabel('Amplitude')
