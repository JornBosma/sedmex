function sedmextime = MET2sedmextime(when)

% use: VJtime = MET2sedmextime(when)
%
% where when is a [Nt x 6] matrix, with each row in datevec format
% [yyyy mm dd hh mi ss]. MET2sedmextime then converts each row to sedmex
% time unit, that is, in seconds with respect to [2021 9 10 0 0 0]. sedmextime
% is [Nt x 1] output matrix with the sedmex times.
%
% v1, Gerben Ruessink, 09 October 2020
% v2, Jorn Bosma, 27 October 2021

% check input format
if size(when,2) ~= 6
    error('Input should contain 6 columns as [yyyy mm dd hh mi ss]');
end

% sedmextime = 0
METzero = [2021 9 10 0 0 0];

% compute sedmextime for "when", unit = s
sedmextime = (1/100)*round(100*((datenum(when) - datenum(METzero))*24*3600));

% ready
return;