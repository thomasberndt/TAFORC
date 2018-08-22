

settings = readtable('../data/settings.csv'); 

figure(1)

for n_fig = 1:max(settings.figure)
    idx = logical(settings.figure==n_fig);

    set(gcf, 'Position', [48 48 48+(800-48)/3*max(settings.col(idx)) 48+(800-48)/3*max(settings.row(idx))]);
    p = panel();
    p.pack(max(settings.row(idx)), max(settings.col(idx)));
    p.de.margin = 6;
    p.de.marginleft = 3.5;
    p.de.marginright = 3.5;
    set(gcf, 'Color', 'w');
    
    myrange = find(settings.figure==n_fig)';
    for i = myrange

        filename = sprintf('../data/forc/%s', settings.file{i}); 
        
        princeton = LoadPrincetonForc(filename); 

        princeton.forc.maxHc = settings.Hc(i)/1000;
        princeton.forc.maxHu = settings.Hu(i)/1000;
        princeton.forc.SF = settings.SF(i); 
        princeton.forc.SF_elong = settings.SF_elong(i);
        princeton.forc.limit = settings.rho(i); 
        
        f2 = figure(2);
        princeton = ProcessForc(princeton); 
        close(f2); 
        
        p(settings.row(i), settings.col(i)).select();
        
        step = settings.hys_steps(i);
        Hb = princeton.grid.Hb(:,1:step:end);
        M = princeton.grid.M(:,1:step:end); 
        
        plot(1000*Hb, 1000*M, 'k-'); 
        xlim(settings.Hc(i) * [-1 1]);
        xlabel('H [mT]');
        ylabel('M [mAm^2]');

        if settings.row(i) < max(settings.row(idx))
            xlabel('');
            xticklabels({});
        end
        if settings.col(i) > 1
            ylabel('');
            yticklabels({});
        end

        title(settings.Title{i});
        
        drawnow
    
    end
    
    try
        export_fig(sprintf('../output/png/Hysteresis/%g.png', n_fig), '-m4'); 
        export_fig(sprintf('../output/pdf/Hysteresis/%g.pdf', n_fig)); 
    catch
        print(gcf, '-dpng', sprintf('../output/png/Hysteresis/%g.png', n_fig)); 
        print(gcf, '-dpdf', sprintf('../output/pdf/Hysteresis/%g.pdf', n_fig)); 
    end
        
end

