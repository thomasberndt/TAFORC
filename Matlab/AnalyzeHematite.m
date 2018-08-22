% 

settings = readtable('../data/settings.csv'); 

figure(1)

n_fig = 2; % Hematite sample
idx = logical(settings.figure==n_fig);

set(gcf, 'Position', [48 48 600 600]);
p = panel();
p.pack(1,1);
p(1,1).select();
p.de.margin = 6;
p.de.marginleft = 3.5;
p.de.marginright = 3.5;
set(gcf, 'Color', 'w');

linesettings = {'k-', 'b-', 'r-'}; 

myrange = find(settings.figure==n_fig)';
n = 1;
for i = myrange

    temp_filename = sprintf('../Input/ExperimentalTemp/%s_%g_%g_%g.mat', ...
            settings.file{i}, settings.Hc(i), settings.Hu(i), settings.SF(i)); 

    princeton = load(temp_filename); 
    princeton = princeton.princeton; 

    Hu = princeton.smooth.Hu(:,1);
    rho = princeton.smooth.rho(princeton.smooth.Hc>0.01); 
    rho = reshape(rho, length(Hu), []);
    
    h = plot(Hu*1000, mean(rho,2), linesettings{n}, 'LineWidth', 2); 
    xlabel('H_u [mT]');
    ylabel('Mean \rho(10mT<H_c<90mT, H_u) [Am^2/T^2]'); 
    hold on
    errup = mean(rho,2)+std(rho,0,2); 
    errdown = mean(rho,2)-std(rho,0,2);
    patch([Hu; Hu(end:-1:1)]*1000, [errup; errdown(end:-1:1)], ...
            h.Color, 'FaceAlpha', .1, ...
            'EdgeColor', h.Color, 'EdgeAlpha', 0.5, ...
            'HandleVisibility','off'); 
    xlim([-10 10]);
    grid on
    grid minor
    
    drawnow
    n = n + 1;
end

legend('TS-FORC', '50 s', '200 s', 'location', 'northwest'); 

export_fig('../Output/Experimental/HematiteProfile.png', '-m4'); 

h = gcf;
set(h,'Units','Inches');

pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

print(gcf, '-dpdf', '../Output/Experimental/HematiteProfile.pdf'); 
