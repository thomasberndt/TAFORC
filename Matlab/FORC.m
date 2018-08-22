function [M, forc, Hu, Hc, Ha, Hb] = FORC(f, V, Tc, T, t_a, t_b, tau0, N, steps, Hmin, Hmax)
% Simulates a FORC of an ensemble of grains. 
% f - distribution of grains (vector or matrix) (dimensionless). 
% V - volumes of grains (vector or matrix).
% Tc - Curie temperatures (in Kelvin) of grains (used to calculate Ms based on
% analytical expression for titanomagnetite TMx based on data by Dunlop).
% (vector or matrix).
% T - temperature in Kelvin at which the FORC is measured (scalar). 
% t_a - time in seconds of the reversal field (scalar).
% t_b - time in seconds of the measurement field (scalar).
% tau0 - attempt time of the ensemble in seconds (scalar, vector or
% matrix).
% N - shape anisotropy factor of the ensemble (scalar, vector or matrix)
% (dimensionless). 
% steps - number of field steps from Hmin to Hmax. 
% Hmin, Hmax - minimum and maximum applied fields, respectively, in Tesla
% (scalars). FORCs are calculated for all reversal fields Ha starting from
% Hmin up to Hmax, with a total of steps loops. Hb goes from Ha to Hmax for
% each loop, with the same field increases as Ha. 
%
% OUTPUT:
% M - the raw measurements in Am2 as a function of Ha and Hb (matrix).
% forc - the forc, i.e. second mixed derivative (unsmoothed) of M.
% Hu, Hc - fields in Tesla (matrix). These are not a meshgrid. 
% Ha, Hb - fields in Tesla (matrix). These are a meshgrid. 

    
    Hsat = 1;
    ha = linspace(Hmin, Hmax, steps); 
    hb = linspace(Hmin, Hmax, steps); 
    [Ha, Hb] = meshgrid(ha, hb); 
    
    mr = zeros(size(f));
    M = NaN * zeros(size(Ha));
    
    for n = 1:length(ha)    
        idx = find(hb >= ha(n));     
        mr = AcquireVRM(mr, V, Tc, T ,t_a, Hsat, tau0, N); 
        mr = AcquireVRM(mr, V, Tc, T ,t_a, ha(n), tau0, N); 
        M(idx, n) = PartialHysteresisLoop(mr, f, V, Tc, T, t_b, tau0, N, hb(idx)); 
    end
        
    forc = -diff(diff(M, 1, 1), 1, 2)./diff(Ha(1:end-1,:), 1, 2)./diff(Hb(:,1:end-1), 1, 1); 
    Hu = (Ha(1:end-1,1:end-1) + Hb(1:end-1,1:end-1)) / 2;  
    Hc = (Hb(1:end-1,1:end-1) - Ha(1:end-1,1:end-1)) / 2; 
    Ha = Ha(1:end-1,1:end-1); 
    Hb = Hb(1:end-1,1:end-1); 
    
end