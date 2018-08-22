function M = MeasureNRM(mr, Tc, f, V)
% Calculates the total remanent magnetization of the ensemble of particles
% given by (Tc, f, V), with remanence states given by mr. 
% mr - normalized (by Ms) remanence states of the grains (vector or
% matrix).
% Tc - Curie temperatures (in Kelvin) of the grains (used to calculate Ms based on
% analytical expression for titanomagnetite TMx based on data by Dunlop).
% (vector or matrix)
% f - distribution of grains (e.g. number or frequency of grains). (vector
% or matrix)
% V - volumes of grains (vector or matrix)
% OUTPUT: M - total remanence magnetization in Am2 (scalar)
    Ms0 = CalculateMs0(Tc); 
    M = sum(sum(Ms0.*mr.*f.*V)); 
end