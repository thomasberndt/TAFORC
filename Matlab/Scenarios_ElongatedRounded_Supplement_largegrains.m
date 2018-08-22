% Simulates and plots assemblages of large elongated and 
% large rounded magnetite grains


V = logspace(log10(1e-24), log10(1e-22), 200);
mr = zeros(size(V));

Tc = (580+273);
Ms0 = CalculateMs0(Tc); 
tau0  = 1e-10;
T     = 20+273;
Ha    = -0.12; 
Hb    =  0.12; 
Hcmax = 0.08; 
Humax = 0.04; 
steps = 201; 

N_elongated = 0.5;
f_elongated = normpdf(log10(V), log10(11.2e-24), 0.15);      % This is the same as the elongated distribution from the main scenario
f_elongated = 1e6*1.2e15*f_elongated / max(f_elongated);  

N_round = 0.10;
f_round = normpdf(log10(V), log10(11.2e-24), 0.15); 
f_round = 1.2e15*f_round / max(f_round);

ta = [0.125 50 350];
tb = 0.125; 

[M_elongated_0s,   forc_elongated_0s, Hu, Hc, Haa, Hbb] = FORC(f_elongated,  V, Tc, T, ta(1), tb, tau0, N_elongated, steps, Ha, Hb);
[M_rounded_0s,     forc_rounded_0s]                     = FORC(f_round,      V, Tc, T, ta(1), tb, tau0, N_round, steps, Ha, Hb);
[M_elongated_50s,  forc_elongated_50s]                  = FORC(f_elongated,  V, Tc, T, ta(2), tb, tau0, N_elongated, steps, Ha, Hb);
[M_rounded_50s,    forc_rounded_50s]                    = FORC(f_round,      V, Tc, T, ta(2), tb, tau0, N_round, steps, Ha, Hb);
[M_elongated_350s, forc_elongated_350s]                 = FORC(f_elongated,  V, Tc, T, ta(3), tb, tau0, N_elongated, steps, Ha, Hb);
[M_rounded_350s,   forc_rounded_350s]                   = FORC(f_round,      V, Tc, T, ta(3), tb, tau0, N_round, steps, Ha, Hb);
forc_mix_0s   = forc_elongated_0s   + forc_rounded_0s; 
forc_mix_50s  = forc_elongated_50s  + forc_rounded_50s; 
forc_mix_350s = forc_elongated_350s + forc_rounded_350s; 
M_mix_0s      = M_elongated_0s      + M_rounded_0s; 
M_mix_50s     = M_elongated_50s     + M_rounded_50s; 
M_mix_350s    = M_elongated_350s    + M_rounded_350s; 

figure(1)
set(gcf, 'Position', [48 48 800/0.95 800]);
pbig = panel();
pbig.pack({100}, {99 []});
pcolorbar = pbig(1,2);
pcolorbar.pack(3, 1); 
pcolorbar = pcolorbar(1, 1);
p = pbig(1,1);
p.pack(3, 3);
p.de.margin = 6;
p.de.marginleft = 4;
p.de.marginright = 4;
set(gcf, 'Color', 'w');

limit = EstimateForcPeak(forc_mix_350s, Hc, Hu, Hcmax, Humax); 

p(1, 1).select();
PlotFORC(forc_elongated_0s, Hc, Hu, Hcmax, Humax, limit);
title('a) Elongated TS-FORC', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});

p(1, 2).select();
PlotFORC(forc_elongated_50s, Hc, Hu, Hcmax, Humax, limit);
title('b) Elongated TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});
ylabel('');
yticklabels({});

p(1, 3).select();
PlotFORC(forc_elongated_350s, Hc, Hu, Hcmax, Humax, limit);
title('c) Elongated TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});
ylabel('');
yticklabels({});

p(2, 1).select();
PlotFORC(forc_rounded_0s, Hc, Hu, Hcmax, Humax, limit);
title('d) Rounded TS-FORC', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});

p(2, 2).select();
PlotFORC(forc_rounded_50s, Hc, Hu, Hcmax, Humax, limit);
title('e) Rounded TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});
ylabel('');
yticklabels({});

p(2, 3).select();
PlotFORC(forc_rounded_350s, Hc, Hu, Hcmax, Humax, limit);
title('f) Rounded TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});
ylabel('');
yticklabels({});

p(3, 1).select();
PlotFORC(forc_mix_0s, Hc, Hu, Hcmax, Humax, limit);
title('g) Mixture TS-FORC', 'FontWeight', 'Normal');

p(3, 2).select();
PlotFORC(forc_mix_50s, Hc, Hu, Hcmax, Humax, limit);
title('g) Mixture TA-FORC (50 s)', 'FontWeight', 'Normal');
ylabel('');
yticklabels({});

p(3, 3).select();
PlotFORC(forc_mix_350s, Hc, Hu, Hcmax, Humax, limit);
title('h) Mixture TA-FORC (350 s)', 'FontWeight', 'Normal');
ylabel('');
yticklabels({});

pcolorbar.select();
[~, h, ax] = PlotFORC(forc_mix_0s, Hc, Hu, Hcmax, Humax, limit);
set(h, 'visible', 'off')
set(ax, 'visible', 'off')
c = colorbar('East'); 

try
    export_fig('../output/png/Forc/ElongatedRounded_largegrains.png', '-m4'); 
    export_fig('../output/pdf/Forc/ElongatedRounded_largegrains.pdf'); 
catch
    print(gcf, '-dpng', '../output/png/Forc/ElongatedRounded_largegrains.png'); 
    print(gcf, '-dpdf', '../output/pdf/Forc/ElongatedRounded_largegrains.pdf'); 
end





figure(2)
set(gcf, 'Position', [48 48 800 900]);
p = panel();
p.pack(3, 3);
p.de.margin = 10;
p.de.margintop = 20; 
set(gcf, 'Color', 'w');



p(1, 1).select();
plot(1000*Hbb(1:2:end,1:2:end), M_elongated_0s(2:2:end,2:2:end)/ max(M_elongated_0s(:)) * Ms0 / 1000, 'k-'); 
title('a) Elongated TS-FORC', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(1, 2).select();
plot(1000*Hbb(1:2:end,1:2:end), M_elongated_50s(2:2:end,2:2:end)/ max(M_elongated_50s(:)) * Ms0 / 1000, 'k-'); 
title('b) Elongated TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(1, 3).select();
plot(1000*Hbb(1:2:end,1:2:end), M_elongated_350s(2:2:end,2:2:end)/ max(M_elongated_350s(:)) * Ms0 / 1000, 'k-'); 
title('c) Elongated TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(2, 1).select();
plot(1000*Hbb(1:2:end,1:2:end), M_rounded_0s(2:2:end,2:2:end)/ max(M_rounded_0s(:)) * Ms0 / 1000, 'k-'); 
title('d) Rounded TS-FORC', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(2, 2).select();
plot(1000*Hbb(1:2:end,1:2:end), M_rounded_50s(2:2:end,2:2:end)/ max(M_rounded_50s(:)) * Ms0 / 1000, 'k-'); 
title('e) Rounded TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(2, 3).select();
plot(1000*Hbb(1:2:end,1:2:end), M_rounded_350s(2:2:end,2:2:end)/ max(M_rounded_350s(:)) * Ms0 / 1000, 'k-'); 
title('f) Rounded TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(3, 1).select();
plot(1000*Hbb(1:2:end,1:2:end), M_mix_0s(2:2:end,2:2:end)/ max(M_elongated_0s(:)) * Ms0 / 1000, 'k-'); 
title('g) Mixture TS-FORC', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(3, 2).select();
plot(1000*Hbb(1:2:end,1:2:end), M_mix_50s(2:2:end,2:2:end)/ max(M_elongated_50s(:)) * Ms0 / 1000, 'k-'); 
title('g) Mixture TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(3, 3).select();
plot(1000*Hbb(1:2:end,1:2:end), M_mix_350s(2:2:end,2:2:end)/ max(M_elongated_350s(:)) * Ms0 / 1000, 'k-'); 
title('h) Mixture TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);




try
    export_fig('../output/png/Hysteresis/ElongatedRounded_largegrains_Hysteresis.png', '-m4'); 
    export_fig('../output/pdf/Hysteresis/ElongatedRounded_largegrains_Hysteresis.pdf'); 
catch
    print(gcf, '-dpng', '../output/png/Hysteresis/ElongatedRounded_largegrains_Hysteresis.png'); 
    print(gcf, '-dpdf', '../output/pdf/Hysteresis/ElongatedRounded_largegrains_Hysteresis.pdf'); 
end


