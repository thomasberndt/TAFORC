function smooth = SmoothForc(M, Hc, Hu, maxHc, maxHu, SF, SF_elong) 
% Smoothes the FORC using the weighted LOESS algorithm by Harrison and
% Feinberg (2008). Uses the Matlab Parallel Computing Toolbox to make this
% painfully slow and inefficient Matlab code at least a little bit more
% bearable. 
%
% M - raw magnetization measurements (matrix) on grid (regular or
% irregular) of (Ha, Hb). 
% Ha, Hb - grid (regular or irrgeular) where the measurements are taken 
% (matrices). 
% maxHc, maxHu - the smoothed output will be on a regular grid of (Hc, Hu),
% where Hc goes from 0 to maxHc, and Hu goes from -maxHu to +maxHu.
% (scalars). 
% SF - smoothing factor. Can be a floating point number, as the LOESS
% algorithm does not need an integer smoothing factor. 
% SF_elong - optional argument. This can be used to preferentially smooth
% in either the Hu direction (SF_elong>1) or in the Hc direction
% (SF_elong<1). Default is SF_elong=1. 

    if nargin < 7
        SF_elong = 1;
    end

    smooth = []; 
    [smooth.Hc, smooth.Hu] = meshgrid(linspace(0, maxHc, size(Hc,1)), ...
                                      linspace(-maxHu, maxHu, size(Hu,2))); 
    Ha = Hu - Hc;
    Hb = Hu + Hc;
    smooth.Ha = smooth.Hu - smooth.Hc;
    smooth.Hb = smooth.Hu + smooth.Hc;
    smooth.rho = NaN * zeros(size(smooth.Hc));
    smoothHc = smooth.Hc; 
    
    parfor u = 1:size(smooth.Hc, 2)
        slicedRho = zeros(1,size(smoothHc,1));
        for c = 1:size(smoothHc, 1)
            dist = (Hc-smooth.Hc(c,u)).^2 + SF_elong*(Hu-smooth.Hu(c,u)).^2; 
            
            [~, i]=sort(dist(:));
            idx = i(1:round((2*SF+1)^2));
            
            w = (1 - (abs(dist(idx))/max(abs(dist(idx)))).^3).^3;

            f = fit([Ha(idx), Hb(idx)], M(idx), 'poly22', 'Weights', w);
            slicedRho(c) = -f.p11; 
        end
        smoothRho(:,u) = slicedRho; 
        drawnow
        fprintf('%g/%g \n', u, size(smooth.Hu, 2));
    end
    
    smooth.Hc = smoothHc; 
    smooth.rho = smoothRho; 
    smooth.maxHc = maxHc;
    smooth.maxHu = maxHu; 
end
