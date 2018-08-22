% Loads, smoothes, plots, and saves all the FORCs that are listed in the
% /data/settings.csv file. 

files = dir('../data/forc/*.frc'); 
settings = readtable('../data/settings.csv'); 

set(gcf, 'Position', [61 48 1541 1195]);

for n = 1:numel(files)
    princeton = LoadPrincetonForc(sprintf('../data/forc/%s', files(n).name));
    disp(files(n).name);
    i = strcmpi(settings.file,files(n).name);
        
    if any(i)
        princeton.forc.maxHc = settings.Hc(i)/1000;
        princeton.forc.maxHu = settings.Hu(i)/1000;
        princeton.forc.SF = settings.SF(i); 
        princeton.forc.SF_elong = settings.SF_elong(i);
        princeton.forc.limit = settings.rho(i); 
    else 
        princeton.forc.SF = 2; 
    end
    
    princeton = ProcessForc(princeton);
    
    PlotFORC(princeton.smooth);
    
    set(gca, 'FontSize', 36)
    
    if any(i)
        axis([0 settings.Hc(i) -settings.Hu(i), settings.Hu(i)]); 
        title(settings.Title{i});
    else 
        title(files(n).name);
    end 
    
    f= gcf;
    f.PaperPositionMode = 'auto';
    print(sprintf('../output/png/Experimental/%s.png', files(n).name), '-dpng');
    print(sprintf('../output/pdf/Experimental/%s.pdf', files(n).name), '-dpdf');
end