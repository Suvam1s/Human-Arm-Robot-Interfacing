clc;
clear;
close all;

%% =============================
% Instrumentation Amplifier
%% =============================

R = 10e3;
Rg = 322;
R3 = 2e3;
R4 = 32e3;

G1 = 1 + (2*R)/Rg;
G2 = R4 / R3;
G_total = G1 * G2;

Vin = 5e-3; % 5 mV
Vamp = G_total * Vin;

fprintf('Total Gain = %.2f\n', G_total);
fprintf('Amplified Voltage = %.3f V\n', Vamp);

%% =============================
% MFB Low Pass Filter
%% =============================

R1 = 400;
R2 = 7.5e3;
R3_f = 10e3;
C1 = 100e-6;
C2 = 10e-6;

% Transfer function coefficients
a = R2 * R3_f * C1 * C2;
b = R2*C2 + R3_f*C2 + R3_f*C1;
c = 1;

num = [1];
den = [a b c];

H = tf(num, den);

%% =============================
% Combined System
%% =============================

H_total = G_total * H;

%% =============================
% BODE PLOT
%% =============================
figure;
bode(H_total);
grid on;
title('Bode Plot (Full System)');

%% =============================
% STEP RESPONSE
%% =============================
figure;
step(Vin * H_total);
grid on;
title('Step Response (Final Output)');

%% =============================
% IMPULSE RESPONSE
%% =============================
figure;
impulse(Vin * H_total);
grid on;
title('Impulse Response');

%% =============================
% POLE-ZERO MAP
%% =============================
figure;
pzmap(H_total);
grid on;
title('Pole-Zero Map');

%% =============================
% NYQUIST PLOT
%% =============================
figure;
nyquist(H_total);
grid on;
title('Nyquist Plot');

%% =============================
% ROOT LOCUS
%% =============================
figure;
rlocus(H_total);
grid on;
title('Root Locus');

%% =============================
% FREQUENCY RESPONSE (0–10 Hz focus)
%% =============================
figure;
w = logspace(-2, 2, 1000); % 0.01 Hz to 100 Hz
[mag, phase] = bode(H_total, 2*pi*w);

mag = squeeze(mag);
phase = squeeze(phase);

subplot(2,1,1);
semilogx(w, 20*log10(mag));
grid on;
title('Magnitude (Focused Low Frequency)');
ylabel('dB');

subplot(2,1,2);
semilogx(w, phase);
grid on;
ylabel('Phase (deg)');
xlabel('Frequency (Hz)');

%% =============================
% TIME DOMAIN SIMULATION (REAL SIGNAL)
%% =============================
fs = 100; % sampling freq
t = 0:1/fs:5;

% 2 Hz test signal
input_signal = Vin * sin(2*pi*2*t);

output_signal = lsim(H_total, input_signal, t);

figure;
plot(t, input_signal, '--', t, output_signal, 'LineWidth', 1.5);
legend('Input', 'Output');
grid on;
title('Time Domain Response (2 Hz Signal)');
xlabel('Time (s)');
ylabel('Voltage');
