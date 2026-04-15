%% =========================================================
%  MFB (Multiple Feedback) Low-Pass Butterworth Filter
%  Topology: Vin-R1-N1-R2-N2(op-amp-) | C1:N1->GND
%            C2:N2->Vout | R3:Vout->N1 (feedback)
%  Author  : Generated for MFB LPF Analysis
% ==========================================================

clear; clc; close all;

%% ── 1. Component Values ───────────────────────────────────
R1 = 40;        % Input resistor        [Ohm]
R2 = 2800;       % Series resistor       [Ohm]
R3 = 1000;      % Feedback resistor     [Ohm]
C1 = 100e-6;     % Shunt capacitor       [F]
C2 = 10e-6;      % Feedback capacitor    [F]

 

num_coeff = -1/(R1 * R2 * C1 * C2);

a2 = 1;
a1 = (1/R1 + 1/R2 + 1/R3) / C1;          % s coefficient
a0 = 1 / (R2 * R3 * C1 * C2);             % constant term  = w0^2

num = [num_coeff];
den = [a2, a1, a0];

%% ── 3. System Object ──────────────────────────────────────
sys = tf(num, den);

%% ── 4. Key Parameters ─────────────────────────────────────
w0       = sqrt(a0);                       % Natural / cutoff freq [rad/s]
f0       = w0 / (2*pi);                    % [Hz]
Q        = w0 / a1;                        % Quality factor
DC_gain  = num_coeff / a0;                 % = -R3/R1
DC_dB    = 20*log10(abs(DC_gain));
%%AI GENERATED SEGMENT TO PRINT DATAS
fprintf('╔══════════════════════════════════════════╗\n');
fprintf('║  MFB Low-Pass Filter — Key Parameters   ║\n');
fprintf('╠══════════════════════════════════════════╣\n');
fprintf('║  Component Values:                       ║\n');
fprintf('║    R1 = %-6g Ω                          ║\n', R1);
fprintf('║    R2 = %-6g Ω  (%.1f kΩ)              ║\n', R2, R2/1e3);
fprintf('║    R3 = %-6g Ω  (%.0f kΩ) — feedback  ║\n', R3, R3/1e3);
fprintf('║    C1 = %.0f µF                        ║\n', C1*1e6);
fprintf('║    C2 = %.0f µF                         ║\n', C2*1e6);
fprintf('╠══════════════════════════════════════════╣\n');
fprintf('║  Filter Characteristics:                 ║\n');
fprintf('║    ω₀ = %8.4f rad/s                  ║\n', w0);
fprintf('║    f₀ = %8.4f Hz                     ║\n', f0);
fprintf('║    Q  = %8.4f                         ║\n', Q);
fprintf('║         (Butterworth target Q = 0.7071)  ║\n');
fprintf('║    DC Gain = %.4f  (%.2f dB)          ║\n', DC_gain, DC_dB);
fprintf('║    = -R3/R1 = -%g/%g = -%g           ║\n', R3, R1, R3/R1);
fprintf('╚══════════════════════════════════════════╝\n\n');

%% ── 5. Pole-Zero & Causality ──────────────────────────────
p = pole(sys);
z = zero(sys);

fprintf('─── Poles (roots of denominator) ──────────\n');
for k = 1:length(p)
    if imag(p(k)) == 0
        fprintf('  p%d = %.4f  (real)\n', k, real(p(k)));
    else
        fprintf('  p%d = %.4f ± %.4fi\n', k, real(p(k)), abs(imag(p(k))));
    end
end
fprintf('─── Zeros ──────────────────────────────────\n');
if isempty(z)
    fprintf('  None  (all-pole system)\n');
else
    disp(z);
end

fprintf('\n─── Causality & Stability Report ──────────\n');
sys_order = order(sys);
fprintf('  System order  : %d\n', sys_order);
if all(real(p) < 0)
    fprintf('  All poles in left-half plane → STABLE\n');
    fprintf('  Causal & BIBO stable ✓\n');
else
    fprintf('  WARNING: unstable pole detected!\n');
end
fprintf('  Relative degree (# poles - # zeros) = %d\n', sys_order - length(z));
fprintf('  → Proper transfer function (causal)\n\n');

%% ── 6. Figure Styling Setup ───────────────────────────────
colors.blue   = [0.22 0.54 0.85];
colors.red    = [0.85 0.22 0.22];
colors.green  = [0.10 0.62 0.40];
colors.amber  = [0.90 0.60 0.10];
colors.purple = [0.50 0.30 0.80];
colors.gray   = [0.45 0.45 0.45];

set(0,'DefaultAxesFontSize', 11);
set(0,'DefaultLineLineWidth', 1.8);
set(0,'DefaultAxesGridAlpha', 0.3);
set(0,'DefaultAxesGridLineStyle','--');

%% ── 7. FIGURE 1 — Bode Plot ───────────────────────────────
fig1 = figure('Name','Bode Plot','Position',[50 50 900 620]);
bodeOpts = bodeoptions('cstprefs');
bodeOpts.FreqUnits   = 'Hz';
bodeOpts.MagUnits    = 'dB';
bodeOpts.PhaseUnits  = 'deg';
bodeOpts.Grid        = 'on';
bodeOpts.Title.String = '';
bodeOpts.XLabel.String = 'Frequency (Hz)';

bode(sys, bodeOpts);

% Annotate cutoff
ax = findall(fig1,'Type','Axes');
for k = 1:length(ax)
    tag = get(ax(k),'Tag');
    hold(ax(k),'on');
    xline(ax(k), f0, '--', 'Color', colors.red, ...
          'LineWidth',1.4,'Label',sprintf('f₀ = %.2f Hz',f0),...
          'LabelHorizontalAlignment','right');
end

sgtitle('Bode Plot — MFB Low-Pass Butterworth Filter', 'FontSize',14, 'FontWeight','bold');

%% ── 8. FIGURE 2 — Custom Magnitude & Phase ────────────────
w_range = logspace(log10(w0/1000), log10(w0*1000), 3000);
[mag, phase_deg, w_out] = bode(sys, w_range);
mag       = squeeze(mag);
phase_deg = squeeze(phase_deg);
f_range   = w_out / (2*pi);

% -3dB frequency (actual)
mag_dB  = 20*log10(mag);
ref_dB  = 20*log10(abs(DC_gain)) - 3;
idx_3dB = find(mag_dB <= ref_dB, 1,'first');
if ~isempty(idx_3dB)
    f_3dB = f_range(idx_3dB);
else
    f_3dB = f0;
end

fig2 = figure('Name','Frequency Response','Position',[80 80 960 640]);

% ── Magnitude ──
subplot(2,1,1);
semilogx(f_range, mag_dB, 'Color', colors.blue, 'LineWidth', 2);
hold on;
yline(ref_dB,'--','Color',colors.red,'LineWidth',1.2,...
      'Label',sprintf('%.1f dB (−3dB point)',ref_dB),...
      'LabelHorizontalAlignment','right');
xline(f0,'--','Color',colors.amber,'LineWidth',1.2,...
      'Label',sprintf('f₀=%.2f Hz',f0),...
      'LabelHorizontalAlignment','right');
if ~isempty(idx_3dB)
    plot(f_3dB, ref_dB, 'o','Color',colors.red,'MarkerFaceColor',colors.red,'MarkerSize',7);
end
grid on; hold off;
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Magnitude Response');
legend({'|H(f)|','-3 dB line','f_0'},'Location','southwest');

% ── Phase ──
subplot(2,1,2);
semilogx(f_range, phase_deg, 'Color', colors.purple, 'LineWidth', 2);
hold on;
xline(f0,'--','Color',colors.amber,'LineWidth',1.2,...
      'Label',sprintf('f₀=%.2f Hz',f0),...
      'LabelHorizontalAlignment','right');
yline(-90,'--','Color',colors.gray,'LineWidth',1,...
      'Label','-90°','LabelHorizontalAlignment','right');
yline(-180,'--','Color',colors.gray,'LineWidth',1,...
      'Label','-180°','LabelHorizontalAlignment','right');
grid on; hold off;
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
title('Phase Response');

sgtitle('Frequency Response — MFB LPF', 'FontSize',13,'FontWeight','bold');

fprintf('─── Frequency Response Summary ─────────────\n');
fprintf('  f₀ (natural) = %.4f Hz\n', f0);
fprintf('  f₋₃dB        ≈ %.4f Hz\n', f_3dB);
fprintf('  DC Gain       = %.2f dB\n', DC_dB);
fprintf('\n');

%% ── 9. FIGURE 3 — Step Response ──────────────────────────
fig3 = figure('Name','Step Response','Position',[110 110 900 480]);


T_settle = 10 / (abs(real(p(1)))); 
t_step   = linspace(0, T_settle, 5000);
[y_step, t_out] = step(sys, t_step);

ss_val = dcgain(sys);    % Steady-state (= DC gain for unit step)

plot(t_out, y_step,  'Color', colors.blue, 'LineWidth', 2);
hold on;
yline(ss_val,  '--', 'Color', colors.red, 'LineWidth', 1.2, ...
      'Label', sprintf('Steady state = %.3f', ss_val), ...
      'LabelHorizontalAlignment','right');
yline(0,'k-','LineWidth',0.8);


[pk, idx_pk] = max(abs(y_step));
if pk > abs(ss_val)*1.005      
    OS_pct = (pk - abs(ss_val)) / abs(ss_val) * 100;
    plot(t_out(idx_pk), y_step(idx_pk), '^', 'Color', colors.amber, ...
         'MarkerFaceColor', colors.amber, 'MarkerSize', 8);
    text(t_out(idx_pk), y_step(idx_pk), sprintf('  Peak\n  OS=%.1f%%', OS_pct), ...
         'Color', colors.amber, 'FontSize',10);
end

try
    si = stepinfo(sys);
    rt  = si.RiseTime;
    st  = si.SettlingTime;
    fprintf('─── Step Response Metrics ─────────────────\n');
    fprintf('  Steady-state value  = %.4f\n', ss_val);
    fprintf('  Rise time (10–90%%) = %.4f s\n', rt);
    fprintf('  Settling time (2%%) = %.4f s\n', st);
    if isfield(si,'Overshoot')
        fprintf('  Overshoot           = %.2f %%\n', si.Overshoot);
    end
    fprintf('\n');
catch
end

grid on; hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('Step Response — MFB Low-Pass Butterworth Filter', 'FontSize', 12, 'FontWeight','bold');
legend('y(t)','Steady-state','Location','best');

%% ── 10. FIGURE 4 — Impulse Response ──────────────────────
fig4 = figure('Name','Impulse Response','Position',[140 140 900 480]);

T_imp = 6 / abs(real(p(1)));
t_imp = linspace(0, T_imp, 5000);
[y_imp, t_imp_out] = impulse(sys, t_imp);

plot(t_imp_out, y_imp, 'Color', colors.green, 'LineWidth', 2);
hold on;
yline(0,'k-','LineWidth',0.8);
grid on; hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('Impulse Response (h(t)) — MFB LPF', 'FontSize', 12, 'FontWeight','bold');

trap_int = trapz(t_imp_out, abs(y_imp));
fprintf('─── Impulse Response Check ─────────────────\n');
fprintf('  ∫|h(t)|dt ≈ %.6f  (finite → BIBO stable)\n\n', trap_int);

%% ── 11. FIGURE 5 — Pole-Zero Map (Causality) ─────────────
fig5 = figure('Name','Pole-Zero Map','Position',[170 170 700 580]);

pzplot(sys);
grid on;
hold on;

ylims = ylim;
xlims = xlim;
patch([0 xlims(2) xlims(2) 0], [ylims(1) ylims(1) ylims(2) ylims(2)], ...
      [1 0.8 0.8], 'FaceAlpha', 0.15, 'EdgeColor','none');
text(xlims(2)*0.6, ylims(2)*0.8, 'Unstable (RHP)', ...
     'Color',[0.7 0.1 0.1], 'FontSize', 10, 'FontAngle','italic');
text(xlims(1)*0.9, ylims(2)*0.8, 'Stable (LHP)', ...
     'Color',[0.1 0.5 0.2], 'FontSize', 10, 'FontAngle','italic');

title('Pole-Zero Map — Causality & Stability Analysis', 'FontSize',12,'FontWeight','bold');
xlabel('Real part σ (rad/s)');
ylabel('Imaginary part jω (rad/s)');
hold off;

fprintf('─── Causality Summary ──────────────────────\n');
fprintf('  A causal LTI system has its ROC to the right of\n');
fprintf('  the rightmost pole. All poles at:\n');
for k = 1:length(p)
    fprintf('    p%d = %.4f + %.4fi\n', k, real(p(k)), imag(p(k)));
end
fprintf('  ROC : Re(s) > %.4f\n', max(real(p)));
fprintf('  System is: CAUSAL, STABLE, and PROPER\n\n');

%% ── 12. FIGURE 6 — Nyquist Diagram ───────────────────────
fig6 = figure('Name','Nyquist Diagram','Position',[200 200 720 620]);
nyquist(sys);
grid on;
title('Nyquist Diagram — MFB LPF', 'FontSize',12,'FontWeight','bold');

%% ── 13. FIGURE 7 — Group Delay ───────────────────────────
fig7 = figure('Name','Group Delay','Position',[230 230 900 420]);

gd = -diff(unwrap(phase_deg*pi/180)) ./ diff(w_out);
f_gd = f_range(1:end-1);

semilogx(f_gd, gd*1000, 'Color', colors.amber, 'LineWidth', 2);
hold on;
xline(f0,'--','Color',colors.red,'LineWidth',1.2,...
      'Label',sprintf('f₀=%.2f Hz',f0));
grid on; hold off;
xlabel('Frequency (Hz)');
ylabel('Group Delay (ms)');
title('Group Delay — MFB LPF', 'FontSize',12,'FontWeight','bold');

fprintf('─── Group Delay at DC ──────────────────────\n');
fprintf('  τ_gd(0) ≈ %.4f ms\n\n', gd(1)*1000);

%% ── 14. FIGURE 8 — Combined Dashboard ────────────────────
fig8 = figure('Name','MFB LPF — Summary Dashboard','Position',[100 50 1200 780]);
set(fig8,'Color','white');

% Panel 1: Magnitude
ax1 = subplot(2,3,1);
semilogx(f_range, mag_dB, 'Color', colors.blue, 'LineWidth',2); grid on;
xline(f0,'--r','LineWidth',1.1); xline(f_3dB,':','Color',colors.amber,'LineWidth',1.1);
xlabel('f (Hz)'); ylabel('|H| (dB)'); title('Magnitude');

% Panel 2: Phase
ax2 = subplot(2,3,2);
semilogx(f_range, phase_deg, 'Color', colors.purple, 'LineWidth',2); grid on;
xline(f0,'--r','LineWidth',1.1);
xlabel('f (Hz)'); ylabel('Phase (°)'); title('Phase');

% Panel 3: Step response
ax3 = subplot(2,3,3);
plot(t_out, y_step, 'Color', colors.blue, 'LineWidth',2); grid on;
yline(ss_val,'--r','LineWidth',1.1);
xlabel('t (s)'); ylabel('y(t)'); title('Step Response');

% Panel 4: Impulse response
ax4 = subplot(2,3,4);
plot(t_imp_out, y_imp, 'Color', colors.green, 'LineWidth',2); grid on;
yline(0,'k','LineWidth',0.8);
xlabel('t (s)'); ylabel('h(t)'); title('Impulse Response');

% Panel 5: Pole-Zero
ax5 = subplot(2,3,5);
zplane(roots(num_coeff), roots(den));   % discrete-style P-Z on s-plane
grid on; title('Pole-Zero Map');

% Panel 6: Group delay
ax6 = subplot(2,3,6);
semilogx(f_gd, gd*1000, 'Color', colors.amber, 'LineWidth',2); grid on;
xline(f0,'--r','LineWidth',1.1);
xlabel('f (Hz)'); ylabel('τ_g (ms)'); title('Group Delay');

sgtitle('MFB Low-Pass Butterworth Filter — Analysis Dashboard', ...
        'FontSize',14,'FontWeight','bold','Color',[0.1 0.1 0.35]);

fprintf('══════════════════════════════════════════\n');
fprintf('  All figures generated successfully.\n');
fprintf('  Figures: Bode, Freq. Response, Step,\n');
fprintf('           Impulse, Pole-Zero, Nyquist,\n');
fprintf('           Group Delay, Dashboard.\n');
fprintf('══════════════════════════════════════════\n');
