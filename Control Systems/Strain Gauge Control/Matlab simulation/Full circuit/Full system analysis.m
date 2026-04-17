%% ============================================================
%  COMPLETE CIRCUIT ANALYSIS
%  3 Op-Amp Instrumentation Amplifier + MFB Butterworth LPF
%  Author  : Circuit Analysis Script
%  Date    : 2026
% =============================================================

clc; clear; close all;

%% ---- DARK THEME SETUP ----------------------------------------
set(0,'DefaultFigureColor','k');
set(0,'DefaultAxesColor','k');
set(0,'DefaultAxesXColor','w');
set(0,'DefaultAxesYColor','w');
set(0,'DefaultAxesZColor','w');
set(0,'DefaultTextColor','w');
set(0,'DefaultAxesTitleFontSize',1.1);
set(0,'DefaultLineLineWidth',1.8);

GRID_ALPHA = 0.25;
ACCENT1    = [0.00 0.78 1.00];   % cyan
ACCENT2    = [1.00 0.40 0.00];   % orange
ACCENT3    = [0.40 1.00 0.40];   % green
ACCENT4    = [1.00 0.20 0.60];   % pink
ACCENT5    = [0.90 0.80 0.10];   % yellow

%% ============================================================
%  SECTION 1 : INSTRUMENTATION AMPLIFIER (3 Op-Amp)
% =============================================================

% --- Component values ---
Rf   = 24000;    % First-stage feedback resistors (each) [Ω]
Rg   = 1500;     % Gain-setting resistor [Ω]
Rm   = 1000;     % Output resistors of 1st-stage op-amps [Ω]
R4   = 32000;    % Final inverting amplifier resistor [Ω]
V1   = 5e-3;    % Input voltage 1 [V]
V2   = 0;       % Input voltage 2 [V]

% --- INA Gain Calculation ---
% Stage 1 (buffer + differential): A1 = 1 + 2*Rf/Rg
A1   = 1 + 2*Rf/Rg;

% Stage 2 (difference amplifier): A2 = Rm/R4  (inverting config)
% Standard INA output stage: Vout = (V1-V2) * A1 * (R4/Rm)
% With R3=R4 and R1=R2=Rm in the diff amp:
A2   = R4 / Rm;   % difference amp gain magnitude

% Total INA gain
G_INA = A1 * A2;

% Differential input
Vdiff = V1 - V2;

% Output of INA
Vout_INA = G_INA * Vdiff;

fprintf('============================================\n');
fprintf('  INSTRUMENTATION AMPLIFIER ANALYSIS\n');
fprintf('============================================\n');
fprintf('  Rf              = %.0f kΩ\n', Rf/1e3);
fprintf('  Rg              = %.0f Ω\n',  Rg);
fprintf('  Rm (stage-1 out)= %.0f kΩ\n', Rm/1e3);
fprintf('  R4 (inv amp)    = %.0f kΩ\n', R4/1e3);
fprintf('  V1              = %.0f mV\n',  V1*1e3);
fprintf('  V2              = %.0f mV\n',  V2*1e3);
fprintf('--------------------------------------------\n');
fprintf('  Stage-1 Gain A1 = 1 + 2*Rf/Rg = %.4f (%.2f dB)\n', A1, 20*log10(A1));
fprintf('  Stage-2 Gain A2 = R4/Rm        = %.4f (%.2f dB)\n', A2, 20*log10(A2));
fprintf('  Total INA Gain  = A1 x A2      = %.4f (%.2f dB)\n', G_INA, 20*log10(G_INA));
fprintf('  Vdiff           = V1-V2         = %.2f mV\n', Vdiff*1e3);
fprintf('  Vout_INA        = G x Vdiff    = %.4f V\n', Vout_INA);
fprintf('============================================\n\n');

%% ============================================================
%  SECTION 2 : MFB LOW-PASS BUTTERWORTH FILTER
% =============================================================

% --- Component values ---
R1   = 1000;       % Input resistor [Ω]
R2   = 2800;      % Feedback resistor [Ω]
R3   = 1000;       % First feedback / gain resistor [Ω]
C1   = 100e-6;    % Grounding cap at Vx [F]
C2   = 10e-6;     % Inner feedback cap [F]
Q    = 0.707;     % Quality factor (Butterworth: 1/sqrt(2))
fc   = 3;         % Cutoff frequency [Hz]
wc   = 2*pi*fc;   % Angular cutoff [rad/s]

% --- MFB Transfer Function Coefficients ---
% Standard MFB 2nd-order LPF:
%   H(s) = -1/(R1*R2*C1*C2) / [s^2 + s*(1/(R2*C2)+1/(R1*C2)+1/(R3*C2)) + 1/(R1*R2*C1*C2)]
% (Note: gain is inverting)

% DC gain of MFB stage
Hmfb_dc = -R3 / R1;    % inverting DC gain

% Denominator coefficients [s^2, s^1, s^0]
a2 = R1*R2*C1*C2;
a1 = C2*(R1 + R2 + R1*R2/R3);   % simplified: R2*C2 + R1*C2 + R1*R2*C1/... 
% Correct MFB denominator:
% s^2 + s*[1/(R2*C1) + 1/(R1*C1) + 1/(R3*C1)] ... depends on topology
% Use canonical form: s^2 + (wc/Q)*s + wc^2

% Calculated filter parameters from components
wc_calc  = 1 / sqrt(R1*R2*C1*C2);
fc_calc  = wc_calc / (2*pi);
Q_calc   = (1/wc_calc) / (C2*(R1+R2) + C2*R1*(R2/R3));
% Simpler standard MFB Q formula:
Q_calc2  = (1/wc_calc) / (C2*(R1+R2) + C2*R1*(R2/R3));

fprintf('============================================\n');
fprintf('  MFB BUTTERWORTH LOW-PASS FILTER ANALYSIS\n');
fprintf('============================================\n');
fprintf('  R1 = %.0f Ω,  R2 = %.0f Ω,  R3 = %.0f Ω\n', R1, R2, R3);
fprintf('  C1 = %.0f µF,  C2 = %.0f µF\n', C1*1e6, C2*1e6);
fprintf('  Specified fc  = %.2f Hz,  Q = %.4f\n', fc, Q);
fprintf('  Calculated fc = %.4f Hz  (from components)\n', fc_calc);
fprintf('  MFB DC Gain   = R3/R1 = %.4f (%.2f dB)  [inverting]\n', abs(Hmfb_dc), 20*log10(abs(Hmfb_dc)));
fprintf('============================================\n\n');

%% ============================================================
%  SECTION 3 : TOTAL SYSTEM TRANSFER FUNCTION
% =============================================================

% Build transfer functions using control toolbox
% INA: flat DC gain (wideband assumed ideal)
% MFB: 2nd-order Butterworth

% Use the specified wc and Q for the ideal filter
num_mfb  = [0, 0, abs(Hmfb_dc) * wc^2];
den_mfb  = [1, wc/Q, wc^2];
H_MFB    = tf(num_mfb, den_mfb);

% INA is a flat gain block
H_INA    = tf(G_INA, 1);   % DC, frequency independent

% Total system
H_total  = H_INA * H_MFB;

fprintf('Transfer Functions:\n');
fprintf('  INA  Gain = %.4f (%.2f dB)\n', G_INA, 20*log10(G_INA));
fprintf('  Total System = INA gain × MFB filter\n');

%% ============================================================
%  SECTION 4 : FREQUENCY RESPONSE
% =============================================================

f   = logspace(-3, 4, 5000);   % 0.001 Hz to 10 kHz
w   = 2*pi*f;
s   = 1j*w;

% MFB frequency response (ideal from specifications)
H_mfb_w  = (abs(Hmfb_dc) * wc^2) ./ (-w.^2 + 1j*w*(wc/Q) + wc^2);
H_ina_w  = G_INA * ones(size(w));
H_tot_w  = H_ina_w .* H_mfb_w;

mag_mfb  = 20*log10(abs(H_mfb_w));
mag_ina  = 20*log10(abs(H_ina_w));
mag_tot  = 20*log10(abs(H_tot_w));
ph_mfb   = angle(H_mfb_w) * 180/pi;
ph_ina   = zeros(size(w));
ph_tot   = angle(H_tot_w) * 180/pi;

%% ============================================================
%  SECTION 5 : STEP & IMPULSE RESPONSE
% =============================================================

t_end = 5;     % seconds
t     = linspace(0, t_end, 10000);

[y_step_mfb, t_s]   = step(H_MFB, t);
[y_step_tot, ~]     = step(H_total, t);
[y_imp_mfb,  t_i]   = impulse(H_MFB, t);
[y_imp_tot,  ~]     = impulse(H_total, t);

%% ============================================================
%  SECTION 6 : POLE-ZERO MAP
% =============================================================

[z_mfb, p_mfb, k_mfb] = zpkdata(H_MFB, 'v');
[z_tot, p_tot, k_tot]  = zpkdata(H_total, 'v');

%% ============================================================
%  SECTION 7 : NYQUIST & NICHOLS
% =============================================================

w_nyq = logspace(-2, 3, 4000);
[re_t, im_t] = nyquist(H_total, w_nyq);
re_t = squeeze(re_t); im_t = squeeze(im_t);

%% ============================================================
%  PLOTTING — 8 FIGURES
% =============================================================

%% FIGURE 1: Bode Plot (Magnitude + Phase) — All 3 systems
fig1 = figure('Name','Bode Plot','Position',[50 50 1300 700]);
set(fig1,'Color','k');

subplot(2,1,1);
semilogx(f, mag_ina, '--', 'Color', ACCENT5, 'LineWidth',1.5,'DisplayName','INA (flat)'); hold on;
semilogx(f, mag_mfb,  '-',  'Color', ACCENT1, 'LineWidth',2.0,'DisplayName','MFB Filter');
semilogx(f, mag_tot,  '-',  'Color', ACCENT2, 'LineWidth',2.2,'DisplayName','Total System');
xline(fc,'--','Color',[1 1 1 0.5],'LineWidth',1.2,'Label',sprintf('fc = %.1f Hz',fc),'LabelColor','w','FontSize',9);
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
grid on; xlabel('Frequency (Hz)','Color','w'); ylabel('Magnitude (dB)','Color','w');
title('Bode Plot — Magnitude Response','Color','w','FontWeight','bold','FontSize',13);
legend('Location','southwest','TextColor','w','Color','k','EdgeColor',[0.4 0.4 0.4]);
xlim([f(1) f(end)]); set(gca,'XMinorGrid','on');

subplot(2,1,2);
semilogx(f, ph_ina, '--', 'Color', ACCENT5, 'LineWidth',1.5,'DisplayName','INA'); hold on;
semilogx(f, ph_mfb,  '-',  'Color', ACCENT1, 'LineWidth',2.0,'DisplayName','MFB Filter');
semilogx(f, ph_tot,  '-',  'Color', ACCENT2, 'LineWidth',2.2,'DisplayName','Total System');
xline(fc,'--','Color',[1 1 1 0.5],'LineWidth',1.2,'Label',sprintf('fc = %.1f Hz',fc),'LabelColor','w','FontSize',9);
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
grid on; xlabel('Frequency (Hz)','Color','w'); ylabel('Phase (°)','Color','w');
title('Bode Plot — Phase Response','Color','w','FontWeight','bold','FontSize',13);
legend('Location','southwest','TextColor','w','Color','k','EdgeColor',[0.4 0.4 0.4]);
xlim([f(1) f(end)]); set(gca,'XMinorGrid','on');
sgtitle('COMPLETE BODE ANALYSIS','Color','w','FontSize',15,'FontWeight','bold');

%% FIGURE 2: Step Response
fig2 = figure('Name','Step Response','Position',[60 60 1200 500]);
set(fig2,'Color','k');

subplot(1,2,1);
plot(t_s, y_step_mfb, 'Color', ACCENT1, 'LineWidth',2);
yline(abs(Hmfb_dc),'--','Color',[1 1 1 0.5],'LineWidth',1.2,'Label','DC Gain','LabelColor','w');
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
grid on; xlabel('Time (s)','Color','w'); ylabel('Amplitude','Color','w');
title('MFB Filter — Step Response','Color','w','FontWeight','bold','FontSize',12);

subplot(1,2,2);
plot(t_s, y_step_tot, 'Color', ACCENT2, 'LineWidth',2);
yline(G_INA*abs(Hmfb_dc),'--','Color',[1 1 1 0.5],'LineWidth',1.2,'Label','DC Steady State','LabelColor','w');
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
grid on; xlabel('Time (s)','Color','w'); ylabel('Amplitude (V)','Color','w');
title('Total System — Step Response','Color','w','FontWeight','bold','FontSize',12);
sgtitle('STEP RESPONSE ANALYSIS','Color','w','FontSize',15,'FontWeight','bold');

%% FIGURE 3: Impulse Response
fig3 = figure('Name','Impulse Response','Position',[70 70 1200 500]);
set(fig3,'Color','k');

subplot(1,2,1);
plot(t_i, y_imp_mfb, 'Color', ACCENT3, 'LineWidth',2);
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
grid on; xlabel('Time (s)','Color','w'); ylabel('Amplitude','Color','w');
title('MFB Filter — Impulse Response','Color','w','FontWeight','bold','FontSize',12);

subplot(1,2,2);
plot(t_i, y_imp_tot, 'Color', ACCENT4, 'LineWidth',2);
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
grid on; xlabel('Time (s)','Color','w'); ylabel('Amplitude (V)','Color','w');
title('Total System — Impulse Response','Color','w','FontWeight','bold','FontSize',12);
sgtitle('IMPULSE RESPONSE ANALYSIS','Color','w','FontSize',15,'FontWeight','bold');

%% FIGURE 4: Pole-Zero Map
fig4 = figure('Name','Pole-Zero Map','Position',[80 80 1200 500]);
set(fig4,'Color','k');

subplot(1,2,1);
ax = gca; set(ax,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
hold on; grid on;
% Draw unit circle reference
th = linspace(0,2*pi,200);
plot(cos(th)*wc, sin(th)*wc,'--','Color',[0.4 0.4 0.4],'LineWidth',0.8);
% Poles of MFB
plot(real(p_mfb), imag(p_mfb), 'x', 'Color', ACCENT4, 'MarkerSize',14, 'LineWidth',3,'DisplayName','Poles');
% Zeros
if ~isempty(z_mfb)
    plot(real(z_mfb), imag(z_mfb), 'o', 'Color', ACCENT1, 'MarkerSize',10, 'LineWidth',2,'DisplayName','Zeros');
end
xline(0,'Color',[0.5 0.5 0.5],'LineWidth',0.7);
yline(0,'Color',[0.5 0.5 0.5],'LineWidth',0.7);
xlabel('Real (rad/s)','Color','w'); ylabel('Imag (rad/s)','Color','w');
title('MFB Filter — Pole-Zero Map','Color','w','FontWeight','bold','FontSize',12);
legend('TextColor','w','Color','k','EdgeColor',[0.4 0.4 0.4]);
axis equal;

subplot(1,2,2);
ax2 = gca; set(ax2,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
hold on; grid on;
plot(cos(th)*wc, sin(th)*wc,'--','Color',[0.4 0.4 0.4],'LineWidth',0.8);
plot(real(p_tot), imag(p_tot), 'x', 'Color', ACCENT4, 'MarkerSize',14, 'LineWidth',3,'DisplayName','Poles');
if ~isempty(z_tot)
    plot(real(z_tot), imag(z_tot), 'o', 'Color', ACCENT1, 'MarkerSize',10, 'LineWidth',2,'DisplayName','Zeros');
end
xline(0,'Color',[0.5 0.5 0.5],'LineWidth',0.7);
yline(0,'Color',[0.5 0.5 0.5],'LineWidth',0.7);
xlabel('Real (rad/s)','Color','w'); ylabel('Imag (rad/s)','Color','w');
title('Total System — Pole-Zero Map','Color','w','FontWeight','bold','FontSize',12);
legend('TextColor','w','Color','k','EdgeColor',[0.4 0.4 0.4]);
axis equal;
sgtitle('POLE-ZERO ANALYSIS','Color','w','FontSize',15,'FontWeight','bold');

%% FIGURE 5: Nyquist Plot
fig5 = figure('Name','Nyquist Plot','Position',[90 90 900 700]);
set(fig5,'Color','k');
hold on; grid on;
plot(re_t,  im_t, '-',  'Color', ACCENT2, 'LineWidth',2,'DisplayName','+\omega'); 
plot(re_t, -im_t, '--', 'Color', ACCENT1, 'LineWidth',1.5,'DisplayName','-\omega');
plot(-1, 0, '+', 'Color', ACCENT4, 'MarkerSize',16,'LineWidth',3,'DisplayName','Critical Point (-1,0)');
plot(re_t(1), im_t(1), 'o', 'Color', ACCENT3, 'MarkerSize',10,'LineWidth',2,'DisplayName','Start');
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
xlabel('Real Axis','Color','w'); ylabel('Imaginary Axis','Color','w');
title('Nyquist Plot — Total System','Color','w','FontWeight','bold','FontSize',14);
legend('TextColor','w','Color','k','EdgeColor',[0.4 0.4 0.4],'Location','best');

%% FIGURE 6: Group Delay
fig6 = figure('Name','Group Delay','Position',[100 100 1000 450]);
set(fig6,'Color','k');

% Group delay = -d(phase)/d(omega)
ph_tot_rad = angle(H_tot_w);
gd_tot     = -diff(unwrap(ph_tot_rad)) ./ diff(w);

subplot(1,2,1);
semilogx(f(1:end-1), gd_tot*1000, 'Color', ACCENT3, 'LineWidth',2);
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
grid on; xlabel('Frequency (Hz)','Color','w'); ylabel('Group Delay (ms)','Color','w');
title('Group Delay — Total System','Color','w','FontWeight','bold','FontSize',12);
xline(fc,'--','Color',[1 1 1 0.4],'LineWidth',1.2);

subplot(1,2,2);
% Phase unwrapped
ph_unwrapped = unwrap(ph_tot_rad)*180/pi;
semilogx(f, ph_unwrapped, 'Color', ACCENT4, 'LineWidth',2);
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
grid on; xlabel('Frequency (Hz)','Color','w'); ylabel('Unwrapped Phase (°)','Color','w');
title('Unwrapped Phase — Total System','Color','w','FontWeight','bold','FontSize',12);
xline(fc,'--','Color',[1 1 1 0.4],'LineWidth',1.2);
sgtitle('GROUP DELAY & UNWRAPPED PHASE','Color','w','FontSize',15,'FontWeight','bold');

%% FIGURE 7: Time-domain Signal — Sinusoidal Input Test
fig7 = figure('Name','Time Domain Signal','Position',[110 110 1300 600]);
set(fig7,'Color','k');

% Test with input frequency below, at, and above cutoff
f_test = [0.5, fc, 10];   % Hz
colors_test = {ACCENT3, ACCENT5, ACCENT4};
t_td  = linspace(0, 3, 5000);

for i = 1:3
    ft = f_test(i);
    % Input sinusoid (at INA output = Vout_INA amplitude)
    vin_sig  = Vout_INA * sin(2*pi*ft*t_td);
    % Frequency response at this freq
    s_f      = 1j*2*pi*ft;
    H_at_f   = (abs(Hmfb_dc)*wc^2) / (-( 2*pi*ft)^2 + 1j*(2*pi*ft)*(wc/Q) + wc^2);
    H_total_at_f = G_INA * H_at_f;
    vout_sig = abs(H_total_at_f) * Vout_INA * sin(2*pi*ft*t_td + angle(H_total_at_f));

    subplot(3,1,i);
    plot(t_td, vin_sig*1e3, '--', 'Color', [0.6 0.6 0.6], 'LineWidth',1.2,'DisplayName','Input (INA out, mV scaled)'); hold on;
    plot(t_td, vout_sig,    '-',  'Color', colors_test{i},'LineWidth',2.0,'DisplayName','System Output (V)');
    set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA);
    grid on;
    xlabel('Time (s)','Color','w'); ylabel('Amplitude','Color','w');
    title(sprintf('f = %.1f Hz  |  |H| = %.2f dB  |  Phase = %.1f°', ft, ...
        20*log10(abs(H_total_at_f)), angle(H_total_at_f)*180/pi),'Color','w','FontSize',11);
    legend('TextColor','w','Color','k','EdgeColor',[0.4 0.4 0.4],'Location','northeast');
end
sgtitle('TIME-DOMAIN RESPONSE (Input×Gain ≜ dashed, Output ≜ solid)', ...
    'Color','w','FontSize',14,'FontWeight','bold');

%% FIGURE 8: Summary Dashboard
fig8 = figure('Name','Summary Dashboard','Position',[120 120 1400 750]);
set(fig8,'Color','k');

% Panel A: Gain table bar chart
subplot(2,3,1);
gains_dB = [20*log10(A1), 20*log10(A2), 20*log10(G_INA), ...
            20*log10(abs(Hmfb_dc)), 20*log10(abs(G_INA*Hmfb_dc))];
labels   = {'INA-A1','INA-A2','INA-Total','MFB-DC','System-DC'};
bar_colors = [ACCENT5; ACCENT1; ACCENT2; ACCENT3; ACCENT4];
b = bar(gains_dB, 'FaceColor','flat');
b.CData = bar_colors;
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA, ...
    'XTickLabel',labels,'XTickLabelRotation',25,'FontSize',8.5);
grid on; ylabel('Gain (dB)','Color','w');
title('Gain Summary','Color','w','FontWeight','bold');

% Panel B: Magnitude at key frequencies
subplot(2,3,2);
f_key = [0.1, 0.5, 1, fc, 5, 10, 100];
H_key = abs(G_INA .* (abs(Hmfb_dc)*wc^2) ./ (-(2*pi*f_key).^2 + 1j*(2*pi*f_key)*(wc/Q) + wc^2));
bar(20*log10(H_key),'FaceColor',ACCENT1,'EdgeColor','none');
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA, ...
    'XTickLabel',arrayfun(@(x)sprintf('%.1fHz',x),f_key,'UniformOutput',false),...
    'XTickLabelRotation',30,'FontSize',7.5);
grid on; ylabel('|H| (dB)','Color','w');
title('System Gain @ Key Frequencies','Color','w','FontWeight','bold');

% Panel C: Component values visualization
subplot(2,3,3);
comp_names = {'Rf(INA)','Rg','Rm','R4','R1(MFB)','R2','R3'};
comp_vals  = [Rf, Rg, Rm, R4, R1, R2, R3];
barh(log10(comp_vals),'FaceColor',ACCENT5,'EdgeColor','none');
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA, ...
    'YTickLabel',comp_names,'FontSize',8.5);
grid on; xlabel('log₁₀(Resistance [Ω])','Color','w');
title('Resistor Values (log scale)','Color','w','FontWeight','bold');

% Panel D: Vout breakdown
subplot(2,3,4);
stages = {'V1-V2','After A1','After A2 (=Vout INA)'};
voltages = [Vdiff*1e3, A1*Vdiff*1e3, Vout_INA*1e3];
b2 = bar(voltages,'FaceColor','flat');
b2.CData = [ACCENT1; ACCENT2; ACCENT3];
set(gca,'Color','k','XColor','w','YColor','w','GridColor','w','GridAlpha',GRID_ALPHA,...
    'XTickLabel',stages,'XTickLabelRotation',15,'FontSize',8.5);
grid on; ylabel('Voltage (mV)','Color','w');
title('Voltage Through INA Stages (mV)','Color','w','FontWeight','bold');

% Panel E: Capacitor values
subplot(2,3,5);
cap_names = {'C1 (100µF)','C2 (10µF)'};
cap_vals  = [C1*1e6, C2*1e6];
pie([C1 C2],{'C1=100µF','C2=10µF'});
colormap([ACCENT1; ACCENT4]);
title('Capacitor Ratio','Color','w','FontWeight','bold');
set(gca,'Color','k');

% Panel F: System block diagram text
subplot(2,3,6);
axis off;
str = sprintf(['SYSTEM SUMMARY\n' ...
    '─────────────────────────────\n' ...
    'V1 = %.0f mV,  V2 = %.0f mV\n' ...
    'Vdiff = %.0f mV\n\n' ...
    'INA Stage-1 Gain  A1 = %.2f\n' ...
    'INA Stage-2 Gain  A2 = %.2f\n' ...
    'INA Total Gain       = %.2f\n' ...
    'INA Output  Vout_INA = %.4f V\n\n' ...
    'MFB DC Gain        = %.4f\n' ...
    'MFB Cutoff fc      = %.2f Hz\n' ...
    'MFB Q              = %.4f\n\n' ...
    'TOTAL DC Gain      = %.2f dB\n' ...
    'Vout_total (DC)    = %.4f V'], ...
    V1*1e3, V2*1e3, Vdiff*1e3, ...
    A1, A2, G_INA, Vout_INA, ...
    abs(Hmfb_dc), fc, Q, ...
    20*log10(abs(G_INA*Hmfb_dc)), abs(G_INA*Hmfb_dc)*Vdiff);
text(0.05,0.95,str,'Color','w','FontSize',9,'VerticalAlignment','top', ...
    'FontName','Courier','Units','normalized', ...
    'BackgroundColor',[0.08 0.08 0.08],'EdgeColor',[0.3 0.3 0.3],'Margin',8);

sgtitle('CIRCUIT ANALYSIS — SUMMARY DASHBOARD','Color','w','FontSize',15,'FontWeight','bold');

%% ============================================================
%  PRINT FINAL SUMMARY TO CONSOLE
% =============================================================

fprintf('\n=====================================================\n');
fprintf('  FINAL SYSTEM SUMMARY\n');
fprintf('=====================================================\n');
fprintf('  V1 = %.0f mV | V2 = %.0f mV | Vdiff = %.0f mV\n', V1*1e3, V2*1e3, Vdiff*1e3);
fprintf('  INA Gain  A1          = %.4f  (%.2f dB)\n', A1, 20*log10(A1));
fprintf('  INA Gain  A2          = %.4f  (%.2f dB)\n', A2, 20*log10(A2));
fprintf('  INA Total Gain        = %.4f  (%.2f dB)\n', G_INA, 20*log10(G_INA));
fprintf('  INA Output Vout_INA   = %.6f V\n', Vout_INA);
fprintf('  MFB DC Gain (inv)     = %.4f  (%.2f dB)\n', abs(Hmfb_dc), 20*log10(abs(Hmfb_dc)));
fprintf('  MFB Cutoff fc         = %.4f Hz\n', fc_calc);
fprintf('  MFB Q (from comps)    = %.4f\n', Q_calc);
fprintf('  Total DC System Gain  = %.4f  (%.2f dB)\n', abs(G_INA*Hmfb_dc), 20*log10(abs(G_INA*Hmfb_dc)));
fprintf('  Total Vout (DC, Vdiff)= %.6f V\n', abs(G_INA*Hmfb_dc)*Vdiff);
fprintf('  Poles of MFB filter:\n');
for k=1:length(p_mfb)
    fprintf('    p%d = %.4f + %.4fj  (|p|=%.4f)\n', k, real(p_mfb(k)), imag(p_mfb(k)), abs(p_mfb(k)));
end
fprintf('=====================================================\n');
fprintf('  ALL 8 FIGURES GENERATED SUCCESSFULLY.\n');
fprintf('=====================================================\n');
