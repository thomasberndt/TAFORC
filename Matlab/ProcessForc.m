function processed = ProcessForc(princeton)
% Takes raw princeton VRM FORC and applies, drift correction and smoothing.
% princeton - Optional. A princeton FORC struct. If this argument is
% not given, a dialog is shown for the user to open a file. 
%
% As smoothing is quite slow, temporary files are created such that
% smoothing only has to be done once for each file with any given smoothing
% settings. 
%
% OUTPUT: 
% processed - a princeton forc struct with an additional field:
% processed.smooth - containes the smoothed FORC (struct). 
    
    if nargin < 1
        princeton = LoadPrincetonForc();
    end
    if ~isfield(princeton.forc, 'SF') || isempty(princeton.forc.SF)
        princeton.forc.SF = input('SF: '); 
    end
    if ~isfield(princeton.forc, 'SF_elong') || isempty(princeton.forc.SF_elong)
        princeton.forc.SF_elong = 1; 
    end

    princeton.correctedM = DriftCorrection(...
            princeton.measurements.M, princeton.measurements.t, ...
            princeton.calibration.M, princeton.calibration.t);

    princeton.grid = RegularizeForcGrid(princeton.correctedM, ...
        princeton.measurements.Ha, princeton.measurements.Hb); 

    unsmoothed = CalculateForc(princeton.grid); 
    princeton.forc.rho = unsmoothed.rho;
    princeton.forc.Hc  = unsmoothed.Hc;
    princeton.forc.Hu  = unsmoothed.Hu; 
    princeton.forc.Ha  = unsmoothed.Ha;
    princeton.forc.Hb  = unsmoothed.Hb; 
        
    if ~isfield(princeton.forc, 'maxHc') || isempty(princeton.forc.maxHc)
        princeton.forc.maxHc = princeton.metadata.script.Hc2; 
    end
    if ~isfield(princeton.forc, 'maxHu') || isempty(princeton.forc.maxHu)
        princeton.forc.maxHu = princeton.metadata.script.Hb2;
    end
    
    temp_filename = sprintf('../data/temp/%s_%g_%g_%g_%g.mat', ...
            princeton.filename, ...
            princeton.forc.maxHc, princeton.forc.maxHu, ...
            princeton.forc.SF, princeton.forc.SF_elong); 
        
    if exist(temp_filename, 'file') 
        tempfile = load(temp_filename); 
        princeton.smooth = tempfile.princeton.smooth; 
    else
        PlotFORC(princeton.forc);
        drawnow;
        princeton.smooth = SmoothForc(princeton.correctedM, ...
            princeton.measurements.Hc, princeton.measurements.Hu, ...
            princeton.forc.maxHc, princeton.forc.maxHu, ...
            princeton.forc.SF, princeton.forc.SF_elong);    
        save(temp_filename, 'princeton'); 
    end
    
    if isfield(princeton.forc, 'limit') && ~isempty(princeton.forc.limit)
        princeton.smooth.limit = princeton.forc.limit;
    else
        princeton.smooth.limit = [];
    end
    
    processed = princeton; 

    PlotFORC(princeton.smooth);
end