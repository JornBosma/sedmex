function vXYZ = beams2XYZ(V,T)

% function vXYZ = beams2XYZ(V,T)
%
% The function beams2XYZ transforms beam (123) velocity data (from a SonTek ADV (HYDRA) system)
% to XYZ velocity.
%
% INPUT
% V, [Nsamples x 3], 3 column vectors with beam 1, 2 and 3 velocities
% T, [3 x 3], Transformation matrix. The present file assumes T to come
% from adr2mat (metadata.xfercoeff). NOTE: the HydraView format corresponds
% to T'!
%
% Gerben Ruessink, 09-03-2008

% initialize output
vXYZ = [];

% check size of T
if (size(T,2) ~= size(T,1)) || (size(T,2) ~= 3)
    error('Transformation matrix of incorrect size');
end   

% check size of V
if size(V,2) ~= 3
    error('Velocity matrix of incorrect size');
end

% perform transformation
vXYZ = V*T;

% ready
return