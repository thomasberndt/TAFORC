function [M, mr] = PartialHysteresisLoop(mr, f, V, Tc, T, t, tau0, N, H)
% Simulates a Partial Hysteresis Loop (i.e. a single FORC) of an ensemble
% of grains. 
% mr - initial normalized (by Ms) remanent state of the ensemble 
% (vector or matrix) (dimensionless). 
% f - distribution of grains (vector or matrix) (dimensionless).
% V - volumes of grains (vector or matrix).
% Tc - Curie temperatures (in Kelvin) of grains (used to calculate Ms based on
% analytical expression for titanomagnetite TMx based on data by Dunlop).
% (vector or matrix). 
% T - temperature in Kelvin at which the FORC is measured (scalar). 
% t - time of each measurement step in seconds (scalar).
% tau0 - attempt time of the ensemble in seconds (scalar, vector or
% matrix).
% N - shape anisotropy factor of the ensemble (scalar, vector or matrix)
% (dimensionless). 

    M = zeros(size(H)); 
    
    for n = 1:length(H)-1
        mr = AcquireVRM(mr, V, Tc, T, t*abs(H(n+1)-H(n))*1000, H(n), tau0, N);
        M(n) = gather(MeasureNRM(mr, Tc, f, V)); 
    end
    
    if length(H) > 1
        mr = AcquireVRM(mr, V, Tc, T, t*abs(H(end)-H(end-1))*1000, H(end), tau0, N);
        M(end) = gather(MeasureNRM(mr, Tc, f, V)); 
    end
end