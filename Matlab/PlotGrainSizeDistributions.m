% Plots the grain size distributions of all the simulated scenarios

V = logspace(log10(1e-24), log10(1e-21), 200);

f_TM0 = normpdf(log10(V), log10(1.9e-24), 0.045); 
f_TM0 = 100*0.8e15*f_TM0 / max(f_TM0);
totV_Magnetite = f_TM0.*V;


f_TM60 = normpdf(log10(V), log10(33e-24), 0.16); 
f_TM60 = 0.8e15*f_TM60 / max(f_TM60);
totV_TM = f_TM60.*V;


f_wide = normpdf(log10(V), log10(3.4e-27), 1); 
f_wide = f_wide ./ max(f_wide) * 1e17;
totV_wide = f_wide.*V;

f_elongated = normpdf(log10(V), log10(1.5e-24), 0.02); 
f_elongated = 250*1.2e15*f_elongated / max(f_elongated);
totV_elongated = f_elongated.*V;

f_round = normpdf(log10(V), log10(11.2e-24), 0.15); 
f_round = 1.2e15*f_round / max(f_round);
totV_round = f_round.*V;


c_magnetite = [0.7 0 0]; 
c_TM = [0 0.5 0]; 
c_elongated = [0 0 1]; 
c_round = [0.7 0.7 0];
c_wide = [0 0 0];


figure(1); 
set(gcf, 'Color', 'w');
semilogx(V,f_TM0, 'Color', c_magnetite, 'LineWidth', 2);
hold on

semilogx(V,f_TM60, 'Color', c_TM, 'LineWidth', 2);
semilogx(V,f_elongated, 'Color', c_elongated, 'LineWidth', 2);
semilogx(V,f_round, 'Color', c_round, 'LineWidth', 2);
semilogx(V,f_wide, 'Color', c_wide, 'LineWidth', 1);
hold off

xlabel('Grain volume [m^3]');
ylabel('Number of grains'); 
xlim([1e-24 1e-22]);

legend('a) Magnetite', 'b) Titanomagnetite', 'c) Elongated', 'd) Rounded', 'e) Wide'); 

try
    export_fig('../output/png/GrainSizeDistribution/GrainSizeDistributionNumbers.png', '-m4'); 
    export_fig('../output/pdf/GrainSizeDistribution/GrainSizeDistributionNumbers.pdf'); 
catch
    print(gcf, '-dpng', '../output/png/GrainSizeDistribution/GrainSizeDistributionNumbers.png'); 
    print(gcf, '-dpdf', '../output/pdf/GrainSizeDistribution/GrainSizeDistributionNumbers.pdf'); 
end

figure(2); 
set(gcf, 'Color', 'w');
semilogx(V,totV_Magnetite, 'Color', c_magnetite, 'LineWidth', 2);
hold on

semilogx(V, totV_TM, 'Color', c_TM, 'LineWidth', 2);
semilogx(V,totV_elongated, 'Color', c_elongated, 'LineWidth', 2);
semilogx(V,totV_round, 'Color', c_round, 'LineWidth', 2);
semilogx(V,totV_wide, 'Color', c_wide, 'LineWidth', 1);

hold off

xlabel('Grain volume [m^3]');
ylabel('Relative abundance by volume [m^3]'); 
xlim([1e-24 1e-22]);

legend('a) Magnetite', 'b) Titanomagnetite', 'c) Elongated', 'd) Rounded', 'e) Wide'); 


try
    export_fig('../output/png/GrainSizeDistribution/GrainSizeDistributionVolumes.png', '-m4'); 
    export_fig('../output/pdf/GrainSizeDistribution/GrainSizeDistributionVolumes.pdf'); 
catch
    print(gcf, '-dpng', '../output/png/GrainSizeDistribution/GrainSizeDistributionVolumes.png'); 
    print(gcf, '-dpdf', '../output/pdf/GrainSizeDistribution/GrainSizeDistributionVolumes.pdf'); 
end