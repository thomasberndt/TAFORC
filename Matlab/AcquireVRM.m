function mr_out = AcquireVRM(mr, V, Tc, T, t, H, tau0, shape)
% Simulates VRM acquisition of an ensemble defined by (V, Tc, tau0, shape)
%   mr - is the initial normalized (by Ms) remanent state of the ensemble 
%       (dimensionless) (vector). 
%   V  - volumes of the ensemble (vector)
%   Tc - Curie temperatures of the ensemble (scalar or vector). 
%        Ms0 is calculated from
%        this using an analytical expression for titanomagnetites with titanium-
%        contents x based on data published by Dunlop. 
%   T  - Temperature of VRM acquisition in Kelvin (scalar)
%   t  - Time of VRM acquisition in seconds (scalar)
%   H  - Applied field in Tesla (scalar)
%   tau0 - tau0 of the ensemble in seconds (scalar or vector)
%   shape - shape anisotropy factor of the ensemble (dimensionless) (scalar
%           or vector).
%   OUTPUT: mr_out is the normalized (by Ms) remanent state after VRM 
%           acquisition (dimensionless) (normalized). 
    mu0 = pi*4e-7; 
    kB = 1.38e-23;
    if numel(Tc) <= 1
        Tc = Tc * ones(size(mr));
    end
    ms = CalculateMsT(T, Tc);
    t_12 = tau0 .* exp(V ./ (2*kB*T) .* (mu0*shape.*ms.^2 + 2*abs(H(1)).*ms + H(1)^2./(mu0*shape)) );
    t_21 = tau0 .* exp(V ./ (2*kB*T) .* (mu0*shape.*ms.^2 - 2*abs(H(1)).*ms + H(1)^2./(mu0*shape)) );
    highfield = abs(H/mu0) >= shape.*ms; 
    t_21(highfield) = 0; 
    t_relax = 1 ./ (1./t_12 + 1./t_21); 
    mr_eq = tanh( V.*ms*H(1) ./ (kB*T) ); 
    mr_eq(highfield) = sign(H); 
    mr_out = mr .* exp(-t./t_relax) + ...
                    mr_eq .* (1-exp(-t./t_relax));
                
    if isnan(sum(sum(mr_out)))
        disp('Error');
    end
    
end