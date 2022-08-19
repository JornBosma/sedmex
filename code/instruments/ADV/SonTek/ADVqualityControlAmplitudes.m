function [Rbad, badId] = ADVqualityControlAmplitudes(amp,thresholdAmp)

% check input
if nargin < 2
    thresholdAmp = 100;  % value for SonTek Ocean Probes, Elgar et al. 2005, p. 1891
end

% total number of observations Nt and sensors Ns
[Nt, Ns] = size(amp);

% identify amplitudes that are too low
Rbad = nan(1,Ns);
badId = cell(1,3);
for s = 1:Ns

    % ids
    badId{s} = find(amp(:,s) < thresholdAmp);

    % relative badness
    Rbad(s) = length(badId{s}) / Nt;

end
