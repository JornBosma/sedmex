function [meanAngle, dirSpread] = directionalWaveParameters(u,v,hf,Fs)

% function [meanAngle dirSpread] = directionalWaveParameters(u,v,hf,Fs)
%
% The energy-weighted mean angle is the orientation of the dominant
% principal axis of the (u,v) co-variance matrix. The energy-weighted
% directional spread is the square-root of the ratio between the velocity
% variance perpendicular to this dominant axis and the total variance. See
% Herbers et al. (1999) and Henderson et al. (2006). Both definitions
% correspond to a PCA analysis of the [u v] matrix. The main angle is
% related to the orientation of the first eigenvector and the spread is
% the square root of the relative contribution of the second eigenvector.
% Note that the maximum value of the spread is 40.5 degrees, corresponding
% to an isotropic velocity field.
%
% INPUT
%    u = time-series of cross-shore velocity
%    v = time-series of alongshore velocity
%    hf = frequency range to use, e.g., [0.05 0.33] [Hz]
%    Fs = sampling frequency [Hz]
% OUTPUT
%    meanAngle = energy-weighted mean angle [deg]
%    dirSpread = energy-weighted directional spread [deg]

% turn into columns
u = u(:);
v = v(:);

% apply band-pass filter (detrending is done inside NaNbandPassFilter
uband = NaNbandPassFilter(u,Fs,hf);
vband = NaNbandPassFilter(v,Fs,hf);

% perform eigenfunction analysis
[E,A,D,Dperc] = pca([uband vband]);

% mean angle
meanAngle = (180/pi)*atan(E(2,1)/E(1,1));

% spread
dirSpread = (180/pi)*sqrt(Dperc(2)/100);
