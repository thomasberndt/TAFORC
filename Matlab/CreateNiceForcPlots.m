

settings = readtable('../data/settings.csv'); 

figure(1)
clf;

for n_fig = 1:max(settings.figure)
    idx = logical(settings.figure==n_fig);

    set(gcf, 'Position', [48 48 48+(800-48)/3*max(settings.col(idx))/0.93 48+(800-48)/3*max(settings.row(idx))]);
    pbig = panel();
    pbig.pack({100}, {99 []});
    pcolorbar = pbig(1,2);
    pcolorbar.pack(max(settings.row(idx)), 1); 
    pcolorbar = pcolorbar(1, 1);
    p = pbig(1,1);
    p.pack(max(settings.row(idx)), max(settings.col(idx)));
    p.de.margin = 6;
    p.de.marginleft = 4;
    p.de.marginright = 4;
    set(gcf, 'Color', 'w');
    
    myrange = find(settings.figure==n_fig)';
    for i = myrange
        princeton = LoadPrincetonForc(sprintf('../data/forc/%s', settings.file{i}));
    
        princeton.forc.maxHc = settings.Hc(i)/1000;
        princeton.forc.maxHu = settings.Hu(i)/1000;
        princeton.forc.SF = settings.SF(i); 
        princeton.forc.SF_elong = settings.SF_elong(i);
        princeton.forc.limit = settings.rho(i); 
        
        f2 = figure(2);
        princeton = ProcessForc(princeton); 
        close(f2); 
        
        p(settings.row(i), settings.col(i)).select();
        
        PlotFORC(princeton.smooth);

        if settings.row(i) < max(settings.row(idx))
            xlabel('');
            xticklabels({});
        end
        if settings.col(i) > 1
            ylabel('');
            yticklabels({});
        end
        
        title(settings.Title{i});
        
        if settings.row(i) == max(settings.row(idx)) && ...
                settings.col(i) == max(settings.col(idx)) 
            pcolorbar.select();
            [~, h, ax] = PlotFORC(princeton.smooth);
            set(h, 'visible', 'off')
            set(ax, 'visible', 'off')
            c = colorbar('East'); 
        end
        
        drawnow
    
    end
    

    try
        export_fig(sprintf('../output/png/Experimental_Grid/%g.png', n_fig), '-m4'); 
        export_fig(sprintf('../output/pdf/Experimental_Grid/%g.pdf', n_fig)); 
    catch
        print(gcf, '-dpng', sprintf('../output/png/Experimental_Grid/%g.png', n_fig)); 
        print(gcf, '-dpdf', sprintf('../output/pdf/Experimental_Grid/%g.pdf', n_fig)); 
    end
    
end

