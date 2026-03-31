
clear; clc; close all;

%% ─── 1. CIRCUIT PARAMETERS ──────────────────────────────────────
R1  = 10e3;         
R2  = 10e3;
Rg  = 322;          
R3  = 2e3;          
R4  = 32e3;          

V1  = 5e-3;         
V2  = 0;             
Vdd = 15;            
GBW = 1e6;           
k   = 1.38e-23;      
T   = 300;           
BW_op = 5;           

%% ─── 2. GAIN CALCULATIONS ───────────────────────────────────────
Vdiff = V1 - V2;
Vcm   = (V1 + V2) / 2;

A1      = 1 + (2*R1)/Rg;     
A2      = R4 / R3;            
A_total = A1 * A2;            

BW1 = GBW / A1;              
BW2 = GBW / A2;               
BW_sys = sqrt((sqrt(2)-1)) * min(BW1, BW2);  

Vout_dc = A_total * Vdiff;     

fprintf('╔══════════════════════════════════════════╗\n');
fprintf('║   3 Op-Amp INA — Analysis Summary        ║\n');
fprintf('╠══════════════════════════════════════════╣\n');
fprintf('║ R1=R2=%-6.0f Ω  Rg=%-6.0f Ω            ║\n', R1, Rg);
fprintf('║ R3=%-6.0f Ω     R4=%-6.0f Ω            ║\n', R3, R4);
fprintf('║ V1=%-5.1f mV    V2=%-5.1f mV            ║\n', V1*1e3, V2*1e3);
fprintf('╠══════════════════════════════════════════╣\n');
fprintf('║ Stage-1 Gain A1  = %8.4f  (%5.2f dB)  ║\n', A1, 20*log10(A1));
fprintf('║ Stage-2 Gain A2  = %8.4f  (%5.2f dB)  ║\n', A2, 20*log10(A2));
fprintf('║ Total Gain       = %8.4f  (%5.2f dB)  ║\n', A_total, 20*log10(A_total));
fprintf('╠══════════════════════════════════════════╣\n');
fprintf('║ Differential Input Vdiff = %+.2f mV      ║\n', Vdiff*1e3);
fprintf('║ Common-Mode Input Vcm   = %+.2f mV      ║\n', Vcm*1e3);
fprintf('║ DC Output Voltage       = %+.4f V       ║\n', Vout_dc);
fprintf('╠══════════════════════════════════════════╣\n');
fprintf('║ Stage-1 BW = %10.3f Hz                 ║\n', BW1);
fprintf('║ Stage-2 BW = %10.3f Hz                 ║\n', BW2);
fprintf('╚══════════════════════════════════════════╝\n');

%% ─── 3. FREQUENCY VECTORS ───────────────────────────────────────
f_log  = logspace(-2, 6, 20000);          % Wide log range for Bode
f_op   = linspace(0.001, 5, 5000);        % 0–5 Hz operating range

% Magnitude transfer functions (single-pole roll-off per stage)
H1 = @(f) A1 ./ sqrt(1 + (f./BW1).^2);
H2 = @(f) A2 ./ sqrt(1 + (f./BW2).^2);
H  = @(f) H1(f) .* H2(f);

% Phase (degrees)
Ph1 = @(f) -atan(f./BW1) .* (180/pi);
Ph2 = @(f) -atan(f./BW2) .* (180/pi);
Ph  = @(f) Ph1(f) + Ph2(f);

%% ═══════════════════════════════════════════════════════════════
%  FIGURE 1 — BODE PLOT (Full Frequency Range)
% ═══════════════════════════════════════════════════════════════
figure('Name','Fig 1 – Bode Plot','NumberTitle','off',...
       'Position',[40 40 950 700],'Color','w');

% — Magnitude —
ax1 = subplot(2,1,1);
semilogx(f_log, 20*log10(H(f_log)),  'b',  'LineWidth',2.5); hold on;
semilogx(f_log, 20*log10(H1(f_log)), 'r--','LineWidth',1.6);
semilogx(f_log, 20*log10(H2(f_log)), 'g--','LineWidth',1.6);
yline(20*log10(A_total)-3,'k:','LineWidth',1.4,'Label','–3 dB');
xline(5,   'Color',[0.6 0 0.6],'LineWidth',1.8,'Label','5 Hz (target BW)','LabelVerticalAlignment','top');
xline(BW1, 'r-.','LineWidth',1.4,'Label',sprintf('BW_1=%.1f Hz',BW1));
xline(BW2, 'g-.','LineWidth',1.4,'Label',sprintf('BW_2=%.1f Hz',BW2));
xlim([0.01 1e6]); grid on; box on;
ylabel('Magnitude (dB)','FontWeight','bold');
title('Bode Plot — 3 Op-Amp INA','FontSize',13,'FontWeight','bold');
legend('Overall','Stage 1','Stage 2','Location','southwest','FontSize',9);
set(ax1,'FontSize',10);

% — Phase —
ax2 = subplot(2,1,2);
semilogx(f_log, Ph(f_log),  'b',  'LineWidth',2.5); hold on;
semilogx(f_log, Ph1(f_log), 'r--','LineWidth',1.6);
semilogx(f_log, Ph2(f_log), 'g--','LineWidth',1.6);
xline(5,'Color',[0.6 0 0.6],'LineWidth',1.8,'Label','5 Hz');
yline(-45, 'k:','LineWidth',1.2,'Label','–45°');
yline(-90, 'k:','LineWidth',1.2,'Label','–90°');
xlim([0.01 1e6]); grid on; box on;
xlabel('Frequency (Hz)','FontWeight','bold');
ylabel('Phase (°)','FontWeight','bold');
legend('Overall','Stage 1','Stage 2','Location','southwest','FontSize',9);
set(ax2,'FontSize',10);

%% ═══════════════════════════════════════════════════════════════
%  FIGURE 2 — GAIN IN OPERATING BAND (0–5 Hz)
% ═══════════════════════════════════════════════════════════════
figure('Name','Fig 2 – Operating Band Gain','NumberTitle','off',...
       'Position',[60 60 820 420],'Color','w');

yyaxis left
plot(f_op, H(f_op), 'b-', 'LineWidth',2.8);
yline(A_total,      'b:','LineWidth',1.3,'Label',sprintf('DC Gain = %.2f',A_total));
yline(A_total/sqrt(2),'b--','LineWidth',1.3,'Label','–3 dB');
ylabel('Gain (V/V)','FontWeight','bold','Color','b');
ylim([A_total*0.95  A_total*1.02]);

yyaxis right
plot(f_op, 20*log10(H(f_op)), 'r-', 'LineWidth',1.6);
ylabel('Gain (dB)','FontWeight','bold','Color','r');

xlabel('Frequency (Hz)','FontWeight','bold');
title('Voltage Gain in Operating Range (0–5 Hz)','FontSize',12,'FontWeight','bold');
xlim([0 5]); grid on; box on;

% Annotate gain flatness
gain_5Hz = H(5);
gain_drop_pct = (A_total - gain_5Hz)/A_total * 100;
text(4.5, A_total*0.972,...
    sprintf('Drop at 5Hz:\n%.3f%%', gain_drop_pct),...
    'HorizontalAlignment','center','FontSize',9,'Color',[0.5 0 0]);

%% ═══════════════════════════════════════════════════════════════
%  FIGURE 3 — TIME-DOMAIN ANALYSIS (DC + Sinusoidal sweeps)
% ═══════════════════════════════════════════════════════════════
figure('Name','Fig 3 – Time Domain','NumberTitle','off',...
       'Position',[80 80 980 760],'Color','w');

t = linspace(0, 2, 40000);
colors = lines(5);
freqs_test = [0.5, 1, 2, 5];
labels = arrayfun(@(f) sprintf('%.1f Hz',f), freqs_test,'UniformOutput',false);

subplot(3,2,[1 2]);
% Multiple frequency overlay
for i = 1:length(freqs_test)
    fi = freqs_test(i);
    Gain_i  = H(fi);
    Phase_i = (Ph1(fi)+Ph2(fi)) * pi/180;
    vout_i  = Gain_i * Vdiff * sin(2*pi*fi*t + Phase_i);
    plot(t, vout_i, 'LineWidth', 1.8, 'Color', colors(i,:)); hold on;
end
xlabel('Time (s)','FontWeight','bold');
ylabel('Vout (V)','FontWeight','bold');
title('Output for Multiple Input Frequencies (Vdiff = 5 mV)','FontWeight','bold');
legend(labels,'Location','northeast','FontSize',9);
grid on; box on;
yline(Vout_dc,'k--','LineWidth',1.2,'Label',sprintf('DC Vout=%.4fV',Vout_dc));

subplot(3,2,3);
fi = 1;
v1s = V1*sin(2*pi*fi*t);
v2s = V2*sin(2*pi*fi*t);
plot(t, v1s*1e3,'b','LineWidth',1.8); hold on;
plot(t, v2s*1e3,'r','LineWidth',1.8);
legend('V1','V2','FontSize',9); grid on; box on;
xlabel('Time (s)'); ylabel('Voltage (mV)');
title('Input Signals @ 1 Hz','FontWeight','bold');

subplot(3,2,4);
vdiff_t = (v1s - v2s)*1e3;
plot(t, vdiff_t,'g','LineWidth',1.8); grid on; box on;
xlabel('Time (s)'); ylabel('Vdiff (mV)');
title('Differential Input @ 1 Hz','FontWeight','bold');

subplot(3,2,5);
Phase_1Hz = (Ph1(1)+Ph2(1))*pi/180;
vout_1Hz  = H(1)*Vdiff*sin(2*pi*1*t + Phase_1Hz);
plot(t, vout_1Hz,'r','LineWidth',2); grid on; box on;
xlabel('Time (s)'); ylabel('Vout (V)');
title('Output Voltage @ 1 Hz','FontWeight','bold');
yline(0,'k-','LineWidth',0.8);

subplot(3,2,6);
% Show DC operating point clearly
t_short = linspace(0,0.1,1000);
v1_dc   = V1 * ones(size(t_short));
vout_step = Vout_dc * ones(size(t_short));
stairs(t_short*1000, v1_dc*1e3,'b','LineWidth',2); hold on;
stairs(t_short*1000, vout_step,'r','LineWidth',2);
xlabel('Time (ms)'); ylabel('Voltage');
legend('V1 (mV)','Vout (V)','FontSize',9,'Location','east');
title('DC Operating Point','FontWeight','bold');
grid on; box on;
text(5, Vout_dc*0.95, sprintf('Vout = %.4f V', Vout_dc),...
    'FontSize',10,'FontWeight','bold','Color','r');

%% ═══════════════════════════════════════════════════════════════
%  FIGURE 4 — TRANSFER CHARACTERISTIC (Input vs Output)
% ═══════════════════════════════════════════════════════════════
figure('Name','Fig 4 – Transfer Characteristic','NumberTitle','off',...
       'Position',[100 100 780 540],'Color','w');

Vdiff_sw = linspace(-20e-3, 20e-3, 5000);
Vout_sw  = A_total * Vdiff_sw;
Vout_sw  = max(min(Vout_sw, Vdd), -Vdd);   % Rail clipping

% Ideal (no clipping)
Vout_ideal = A_total * Vdiff_sw;

plot(Vdiff_sw*1e3, Vout_ideal, 'b--', 'LineWidth',1.5,'DisplayName','Ideal (no rail)'); hold on;
plot(Vdiff_sw*1e3, Vout_sw,   'b-',  'LineWidth',2.5,'DisplayName','Actual (±15V rail)');
yline( Vdd,'r-.','LineWidth',1.4,'Label',sprintf('+Rail = +%dV', Vdd));
yline(-Vdd,'r-.','LineWidth',1.4,'Label',sprintf('–Rail = –%dV', Vdd));

% Operating point
scatter(Vdiff*1e3, Vout_dc, 150,'r','filled','DisplayName',...
    sprintf('Op. Point (%.0f mV → %.4f V)', Vdiff*1e3, Vout_dc));
text(Vdiff*1e3 + 0.5, Vout_dc - 0.8,...
    sprintf('  (%+.1f mV, %+.4f V)', Vdiff*1e3, Vout_dc),...
    'FontSize',10,'Color','r','FontWeight','bold');

% Linear region markers
Vdiff_max = Vdd / A_total;
xline( Vdiff_max*1e3,'g-.','LineWidth',1.2,...
    'Label',sprintf('+Vdiff_{max}=%.2f mV', Vdiff_max*1e3));
xline(-Vdiff_max*1e3,'g-.','LineWidth',1.2,...
    'Label',sprintf('–Vdiff_{max}=%.2f mV',-Vdiff_max*1e3));

xlabel('Differential Input Voltage (mV)','FontWeight','bold');
ylabel('Output Voltage (V)','FontWeight','bold');
title(sprintf('Transfer Characteristic  |  Total Gain = %.2f (%.2f dB)',...
    A_total, 20*log10(A_total)),'FontWeight','bold','FontSize',12);
legend('Location','northwest','FontSize',9);
grid on; box on;

%% ═══════════════════════════════════════════════════════════════
%  FIGURE 5 — CMRR ANALYSIS
% ═══════════════════════════════════════════════════════════════
figure('Name','Fig 5 – CMRR Analysis','NumberTitle','off',...
       'Position',[120 120 900 500],'Color','w');

% Left plot: CMRR vs resistor mismatch %
subplot(1,2,1);
mismatch = linspace(0.001, 5, 2000);   % % mismatch
delta = mismatch / 100;
% Differential amp CMRR with R3 mismatch: CMRR ≈ A_diff / A_cm
% A_cm ≈ delta * A2 / 2  (first-order approximation)
A_cm_approx = (delta .* A2) ./ 2;
CMRR_dB = 20*log10(A_total ./ A_cm_approx);

plot(mismatch, CMRR_dB,'b-','LineWidth',2.5); hold on;
yline(100,'g--','LineWidth',1.4,'Label','100 dB (Excellent)');
yline(80, 'y--','LineWidth',1.4,'Label','80 dB (Good)');
yline(60, 'r--','LineWidth',1.4,'Label','60 dB (Minimum)');

% Operating point CMRR (assume 0.1% mismatch)
CMRR_op = interp1(mismatch, CMRR_dB, 0.1);
scatter(0.1, CMRR_op, 100,'r','filled');
text(0.2, CMRR_op-5, sprintf('%.1f dB at 0.1%% mismatch', CMRR_op),...
    'FontSize',9,'Color','r');

xlabel('Resistor Mismatch (%)','FontWeight','bold');
ylabel('CMRR (dB)','FontWeight','bold');
title('CMRR vs Resistor Mismatch','FontWeight','bold');
xlim([0 5]); grid on; box on;

% Right plot: CMRR vs frequency
subplot(1,2,2);
f_cmrr = logspace(-2, 5, 5000);
% CMRR degrades at higher freq due to op-amp open-loop gain roll-off
CMRR_freq = CMRR_op - 20*log10(sqrt(1 + (f_cmrr/1000).^2));
semilogx(f_cmrr, CMRR_freq,'m-','LineWidth',2.5); hold on;
xline(5,'k--','LineWidth',1.5,'Label','5 Hz operating limit');
yline(80,'g--','LineWidth',1.2); yline(60,'r--','LineWidth',1.2);
xlabel('Frequency (Hz)','FontWeight','bold');
ylabel('CMRR (dB)','FontWeight','bold');
title('CMRR vs Frequency','FontWeight','bold');
xlim([0.01 1e5]); grid on; box on;

% Annotate at 5 Hz
CMRR_5Hz = interp1(f_cmrr, CMRR_freq, 5);
scatter(5, CMRR_5Hz, 100,'r','filled');
text(6, CMRR_5Hz-4, sprintf('%.1f dB @ 5 Hz', CMRR_5Hz),'FontSize',9,'Color','r');

%% ═══════════════════════════════════════════════════════════════
%  FIGURE 6 — NOISE ANALYSIS
% ═══════════════════════════════════════════════════════════════
figure('Name','Fig 6 – Noise Analysis','NumberTitle','off',...
       'Position',[140 140 950 600],'Color','w');

% Johnson (thermal) noise voltages referred to output
Vn_R1 = sqrt(4*k*T*R1*BW_op);
Vn_R2 = sqrt(4*k*T*R2*BW_op);
Vn_Rg = sqrt(4*k*T*Rg*BW_op);
Vn_R3 = sqrt(4*k*T*R3*BW_op);
Vn_R4 = sqrt(4*k*T*R4*BW_op);

% Refer each to input (RTI)
RTI_R1 = Vn_R1 / A_total * 1e9;    % nV
RTI_R2 = Vn_R2 / A_total * 1e9;
RTI_Rg = Vn_Rg / A2     * 1e9;     % Rg sees full stage-1 gain
RTI_R3 = Vn_R3 / A_total * 1e9;
RTI_R4 = Vn_R4 / A_total * 1e9;

RTI_total = sqrt(RTI_R1^2 + RTI_R2^2 + RTI_Rg^2 + RTI_R3^2 + RTI_R4^2);
SNR_dB    = 20*log10((Vdiff*1e9) / RTI_total);

subplot(1,2,1);
resistors = {'R1 (10kΩ)','R2 (10kΩ)','Rg (322Ω)','R3 (2kΩ)','R4 (32kΩ)'};
RTI_vals  = [RTI_R1, RTI_R2, RTI_Rg, RTI_R3, RTI_R4];
bar_clr   = [0.2 0.5 0.9; 0.2 0.5 0.9; 0.9 0.3 0.2; 0.3 0.75 0.3; 0.85 0.6 0.1];
b = bar(RTI_vals,'FaceColor','flat');
b.CData = bar_clr;
set(gca,'XTickLabel',resistors,'FontSize',9);
xtickangle(30);
xlabel('Resistor','FontWeight','bold');
ylabel('Input-Referred Noise (nV)','FontWeight','bold');
title(sprintf('Thermal Noise RTI  (BW = %d Hz, T = %d K)',BW_op,T),'FontWeight','bold');
yline(RTI_total,'k--','LineWidth',1.5,...
    'Label',sprintf('Total RTI = %.2f nV', RTI_total));
grid on; box on;

% Add value labels on bars
for i = 1:length(RTI_vals)
    text(i, RTI_vals(i)+0.01, sprintf('%.3f',RTI_vals(i)),...
        'HorizontalAlignment','center','FontSize',8,'FontWeight','bold');
end

subplot(1,2,2);
% Noise spectral density (1/f + thermal model) vs frequency
f_n = linspace(0.01, 5, 2000);
f_corner = 1;    % 1/f corner ~1 Hz for typical BJT-input op-amps
% Total input-referred noise spectral density
Vn_spec  = RTI_total/sqrt(BW_op) .* sqrt(1 + f_corner./f_n);  % nV/√Hz
plot(f_n, Vn_spec,'r-','LineWidth',2.5); hold on;
yline(RTI_total/sqrt(BW_op),'b--','LineWidth',1.4,...
    'Label',sprintf('Thermal floor = %.3f nV/√Hz', RTI_total/sqrt(BW_op)));
xlabel('Frequency (Hz)','FontWeight','bold');
ylabel('Noise Density (nV/√Hz)','FontWeight','bold');
title('Input-Referred Noise Spectral Density (0–5 Hz)','FontWeight','bold');
xlim([0.01 5]); grid on; box on;

fprintf('\n── Noise Summary ──\n');
fprintf('Total RTI noise (0–5 Hz): %.3f nV\n', RTI_total);
fprintf('Signal (Vdiff):          %.0f nV  (5 mV × 1)\n', Vdiff*1e9);
fprintf('SNR:                     %.1f dB\n', SNR_dB);

%% ═══════════════════════════════════════════════════════════════
%  FIGURE 7 — GAIN SENSITIVITY TO Rg
% ═══════════════════════════════════════════════════════════════
figure('Name','Fig 7 – Gain Sensitivity','NumberTitle','off',...
       'Position',[160 160 900 450],'Color','w');

Rg_range = linspace(10, 2000, 5000);
A1_range = 1 + 2*R1 ./ Rg_range;
A_tot_range = A1_range * A2;
Vout_range  = A_tot_range * Vdiff;
Vout_range  = min(Vout_range, Vdd);   % clip at rail

subplot(1,2,1);
yyaxis left
semilogx(Rg_range, A_tot_range,'b-','LineWidth',2.5);
ylabel('Total Gain (V/V)','FontWeight','bold','Color','b');
yyaxis right
semilogx(Rg_range, 20*log10(A_tot_range),'r-','LineWidth',1.8);
ylabel('Total Gain (dB)','FontWeight','bold','Color','r');

xline(Rg,'k--','LineWidth',1.8,...
    'Label',sprintf('Rg=322Ω  G=%.0f',A_total));
xlabel('Rg (Ω)','FontWeight','bold');
title('Gain vs Rg','FontWeight','bold');
grid on; box on;

subplot(1,2,2);
semilogx(Rg_range, Vout_range*1e3,'g-','LineWidth',2.5); hold on;
xline(Rg,'k--','LineWidth',1.8,...
    'Label',sprintf('Rg=322Ω → Vout=%.1f V',Vout_dc));
yline(Vdd*1e3,'r-.','LineWidth',1.3,'Label',sprintf('+%dV Rail',Vdd));
scatter(Rg, Vout_dc*1e3, 130,'r','filled');
xlabel('Rg (Ω)','FontWeight','bold');
ylabel('DC Output Voltage (mV)','FontWeight','bold');
title(sprintf('Vout vs Rg  (Vdiff = %.0f mV)',Vdiff*1e3),'FontWeight','bold');
grid on; box on;

%% ═══════════════════════════════════════════════════════════════
%  FIGURE 8 — POLE-ZERO MAP & STEP RESPONSE
% ═══════════════════════════════════════════════════════════════
figure('Name','Fig 8 – Pole-Zero & Step Response','NumberTitle','off',...
       'Position',[180 180 950 480],'Color','w');

% Poles (in s-domain: s = –2π·BW)
p1 = -2*pi*BW1;
p2 = -2*pi*BW2;

subplot(1,2,1);
plot(real(p1), imag(p1), 'bx','MarkerSize',18,'LineWidth',3,...
    'DisplayName',sprintf('Pole 1: %.1f rad/s  (Stage 1)', abs(p1))); hold on;
plot(real(p2), imag(p2), 'rx','MarkerSize',18,'LineWidth',3,...
    'DisplayName',sprintf('Pole 2: %.1f rad/s  (Stage 2)', abs(p2)));
plot(0, 0,'ko','MarkerSize',10,'LineWidth',2,'DisplayName','No zeros');
xline(0,'k-','LineWidth',0.8); yline(0,'k-','LineWidth',0.8);
xlim([1.2*min([p1 p2]) 0.5*abs(p1)]);
ylim([-abs(p1)*0.3  abs(p1)*0.3]);
xlabel('Real (rad/s)','FontWeight','bold');
ylabel('Imaginary (rad/s)','FontWeight','bold');
title('Pole-Zero Map','FontWeight','bold');
legend('Location','northeast','FontSize',9);
grid on; box on;

subplot(1,2,2);
% Approximate step response for cascaded 2-pole system
t_step = linspace(0, 3/BW_sys, 5000);
% Inverse Laplace of cascaded first-order: 1 - (1+w2·t)e^(-w1·t) etc.
w1 = 2*pi*BW1; w2 = 2*pi*BW2;
if abs(w1 - w2) > 1   % distinct poles
    step_resp = A_total * Vdiff * ...
        (1 - (w2/(w2-w1))*exp(-w1*t_step) + (w1/(w2-w1))*exp(-w2*t_step));
else                   % nearly equal poles
    step_resp = A_total * Vdiff * (1 - (1 + w1*t_step).*exp(-w1*t_step));
end
step_resp = min(step_resp, Vdd);

plot(t_step, step_resp,'b-','LineWidth',2.5); hold on;
yline(Vout_dc,     'r--','LineWidth',1.4,'Label',sprintf('Final = %.4f V',Vout_dc));
yline(0.9*Vout_dc, 'k:','LineWidth',1.2,'Label','90%');
yline(0.1*Vout_dc, 'k:','LineWidth',1.2,'Label','10%');
xlabel('Time (s)','FontWeight','bold');
ylabel('Output Voltage (V)','FontWeight','bold');
title('Approximate Step Response','FontWeight','bold');
grid on; box on;

%% ─── FINAL CONSOLE OUTPUT ────────────────────────────────────
fprintf('\n══════════ FINAL DESIGN CHECK ══════════\n');
fprintf('Operating BW target  :  0 – 5 Hz\n');
fprintf('Stage-1 BW           :  %.2f Hz  ✓ (> 5 Hz)\n', BW1);
fprintf('Stage-2 BW           :  %.2f Hz  ✓ (> 5 Hz)\n', BW2);
fprintf('Gain flatness @5 Hz  :  %.4f%% drop\n', gain_drop_pct);
fprintf('Gain in linear region:  Vdiff < ±%.4f mV\n', Vdiff_max*1e3);
fprintf('DC Output Voltage    :  %.4f V  (within ±15V rail)\n', Vout_dc);
fprintf('SNR                  :  %.1f dB\n', SNR_dB);
fprintf('=========================================\n');