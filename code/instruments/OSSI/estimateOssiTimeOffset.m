function tOffset = estimateOssiTimeOffset(name,t)

% TOFFSET = ESTIMATEOSSITIMEOFFSET(NAME,T)
%
% retrieves the time-offset of an Ossi. 
%
% INPUT
%   name, OSSI name (string: for example, OSSI1)
%   t, time vector (column)
%
% OUTPUT
%   tOffset, [Nt x 2] column of (1) time and (2) timeOffset in s.
%
% v1, Gerben Ruessink, 1 september 2010: first version
% v2, Gerben Ruessink, 21 March 2016: modified to handle multiple
%     structures in OSSI DB entry

t = t(:);

try
   info = load('instruments.mat',name);
catch
   error('%s does not exist in instruments database',name);
end

if any(t < info.(name)(1).timeIN) || any(t > info.(name)(end).timeOUT),
   error('Offset requested for time moment OSSI was not operational')
end

nEntries = size(info.(name),2);
offsetTimes = NaN(nEntries*2,1);
offsets = NaN(nEntries*2,1);
for i = 1:nEntries
   offsetTimes((i-1)*2+1:2*i) = info.(name)(i).timeOffset(:,1);
   offsets((i-1)*2+1:2*i) = info.(name)(i).timeOffset(:,2);
end

tOffset = interp1(offsetTimes,offsets,t);
tOffset = [t, tOffset];

% ready
return