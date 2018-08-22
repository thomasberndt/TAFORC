% Simulates and plots assemblages of small grained magnetite (TM0) and 
% large grained titanomagnetite (TM60)


V = logspace(log10(1e-24), log10(1e-21), 200);
mr = zeros(size(V));

N     = 0.4;
tau0  = 1e-10;
T     = 20+273;
Ha    = -0.06; 
Hb    =  0.06; 
Hcmax = 0.04; 
Humax = 0.02; 
steps = 201; 

f_TM0 = normpdf(log10(V), log10(1.9e-24), 0.045); 
f_TM0 = 100*0.8e15*f_TM0 / max(f_TM0);
Tc_TM0 = (580+273);
Ms0_TM0 = CalculateMs0(Tc_TM0); 

f_TM60 = normpdf(log10(V), log10(33e-24), 0.16); 
f_TM60 = 0.8e15*f_TM60 / max(f_TM60);
Tc_TM60 = 200+273; 
Ms0_TM60 = CalculateMs0(Tc_TM60); 

ta = [0.125 50 350];
tb = 0.125; 

[M_TM0_0s,   forc_TM0_0s, Hu, Hc, Haa, Hbb] = FORC(f_TM0,  V, Tc_TM0,  T, ta(1), tb, tau0, N, steps, Ha, Hb);
[M_TM60_0s,  forc_TM60_0s]                  = FORC(f_TM60, V, Tc_TM60, T, ta(1), tb, tau0, N, steps, Ha, Hb);
[M_TM0_50s,  forc_TM0_50s]                  = FORC(f_TM0,  V, Tc_TM0,  T, ta(2), tb, tau0, N, steps, Ha, Hb);
[M_TM60_50s, forc_TM60_50s]                 = FORC(f_TM60, V, Tc_TM60, T, ta(2), tb, tau0, N, steps, Ha, Hb);
[M_TM0_350s,  forc_TM0_350s]                = FORC(f_TM0,  V, Tc_TM0,  T, ta(3), tb, tau0, N, steps, Ha, Hb);
[M_TM60_350s, forc_TM60_350s]               = FORC(f_TM60, V, Tc_TM60, T, ta(3), tb, tau0, N, steps, Ha, Hb);
forc_mix_0s   = forc_TM0_0s   + forc_TM60_0s; 
forc_mix_50s  = forc_TM0_50s  + forc_TM60_50s; 
forc_mix_350s = forc_TM0_350s + forc_TM60_350s; 
M_mix_0s      = M_TM0_0s      + M_TM60_0s; 
M_mix_50s     = M_TM0_50s     + M_TM60_50s; 
M_mix_350s    = M_TM0_350s    + M_TM60_350s; 

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
PlotFORC(forc_TM0_0s, Hc, Hu, Hcmax, Humax, limit);
title('a) Magnetite TS-FORC', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});

p(1, 2).select();
PlotFORC(forc_TM0_50s, Hc, Hu, Hcmax, Humax, limit);
title('b) Magnetite TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});
ylabel('');
yticklabels({});

p(1, 3).select();
PlotFORC(forc_TM0_350s, Hc, Hu, Hcmax, Humax, limit);
title('c) Magnetite TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});
ylabel('');
yticklabels({});

p(2, 1).select();
PlotFORC(forc_TM60_0s, Hc, Hu, Hcmax, Humax, limit);
title('d) TM60 TS-FORC', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});

p(2, 2).select();
PlotFORC(forc_TM60_50s, Hc, Hu, Hcmax, Humax, limit);
title('e) TM60 TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('');
xticklabels({});
ylabel('');
yticklabels({});

p(2, 3).select();
PlotFORC(forc_TM60_350s, Hc, Hu, Hcmax, Humax, limit);
title('f) TM60 TA-FORC (350 s)', 'FontWeight', 'Normal');
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
    export_fig('../output/png/Forc/MagnetiteTitanomagnetite.png', '-m4'); 
    export_fig('../output/pdf/Forc/MagnetiteTitanomagnetite.pdf'); 
catch
    print(gcf, '-dpng', '../output/png/Forc/MagnetiteTitanomagnetite.png'); 
    print(gcf, '-dpdf', '../output/pdf/Forc/MagnetiteTitanomagnetite.pdf'); 
end





figure(2)
set(gcf, 'Position', [48 48 800 900]);
p = panel();
p.pack(3, 3);
p.de.margin = 10;
p.de.margintop = 20; 
set(gcf, 'Color', 'w');



p(1, 1).select();
plot(1000*Hbb(1:2:end,1:2:end), M_TM0_0s(2:2:end,2:2:end)/ max(M_TM0_0s(:)) * Ms0_TM0 / 1000, 'k-'); 
title('a) Magnetite TS-FORC', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(1, 2).select();
plot(1000*Hbb(1:2:end,1:2:end), M_TM0_50s(2:2:end,2:2:end)/ max(M_TM0_50s(:)) * Ms0_TM0 / 1000, 'k-'); 
title('b) Magnetite TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(1, 3).select();
plot(1000*Hbb(1:2:end,1:2:end), M_TM0_350s(2:2:end,2:2:end)/ max(M_TM0_350s(:)) * Ms0_TM0 / 1000, 'k-'); 
title('c) Magnetite TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(2, 1).select();
plot(1000*Hbb(1:2:end,1:2:end), M_TM60_0s(2:2:end,2:2:end)/ max(M_TM60_0s(:)) * Ms0_TM60 / 1000, 'k-'); 
title('d) TM60 TS-FORC', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(2, 2).select();
plot(1000*Hbb(1:2:end,1:2:end), M_TM60_50s(2:2:end,2:2:end)/ max(M_TM60_50s(:)) * Ms0_TM60 / 1000, 'k-'); 
title('e) TM60 TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(2, 3).select();
plot(1000*Hbb(1:2:end,1:2:end), M_TM60_350s(2:2:end,2:2:end)/ max(M_TM60_350s(:)) * Ms0_TM60 / 1000, 'k-'); 
title('f) TM60 TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(3, 1).select();
plot(1000*Hbb(1:2:end,1:2:end), M_mix_0s(2:2:end,2:2:end)/ max(M_TM0_0s(:)) * Ms0_TM0 / 1000, 'k-'); 
title('g) Mixture TS-FORC', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(3, 2).select();
plot(1000*Hbb(1:2:end,1:2:end), M_mix_50s(2:2:end,2:2:end)/ max(M_TM0_50s(:)) * Ms0_TM0 / 1000, 'k-'); 
title('g) Mixture TA-FORC (50 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);

p(3, 3).select();
plot(1000*Hbb(1:2:end,1:2:end), M_mix_350s(2:2:end,2:2:end)/ max(M_TM0_350s(:)) * Ms0_TM0 / 1000, 'k-'); 
title('h) Mixture TA-FORC (350 s)', 'FontWeight', 'Normal');
xlabel('H [mT]');
ylabel('M [kA/m]');
xlim([-45 45]);




try
    export_fig('../output/png/Hysteresis/MagnetiteTitanomagnetite_Hysteresis.png', '-m4'); 
    export_fig('../output/pdf/Hysteresis/MagnetiteTitanomagnetite_Hysteresis.pdf'); 
catch
    print(gcf, '-dpng', '../output/png/Hysteresis/MagnetiteTitanomagnetite_Hysteresis.png'); 
    print(gcf, '-dpdf', '../output/pdf/Hysteresis/MagnetiteTitanomagnetite_Hysteresis.pdf'); 
end


