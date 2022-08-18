function METtime = sedmex2METtime(when)

% use: METtime = sedmex2METtime(when)
%
% where when is a [Nt x 1] matrix, with each row in sedmex-time format, that is,
% in s with respect to [2021 9 10 0 0 0]. sedmex2METtime then converts each row to
% MET in datevec format. METtime is [Nt x 6] output matrix with the MET
% times, [yyyy mm dd hr mi s]
%
% v1, Gerben Ruessink, 09 October 2020
% v2, Jorn Bosma, 27 October 2021

% check input format
if size(when,2) ~= 1
    error('Input should contain 1 column only with sedmex times in s');
end

% sedmextime = 0
sedmexzero = datenum([2021 9 10 0 0 0]);

% compute LST time for "when", datevec format
date = sedmexzero + when/(24*3600);
METtime = datevec(date);

% recompute hr, mi, si --> avoid si = 60 s 
fracd = date - floor (date);
tmps = abs(eps*(24*3600)*date);
tmps(tmps==0) = 1;
srnd = 2.^floor(-log2(tmps));
s = round((24*3600)*fracd.*srnd)./srnd;
h = floor(s/3600);
s = s - 3600*h;
mi = floor(s/60);
s = (1/100)*round(100*(s - 60*mi));

% put back into METtime
METtime(:, [4 5 6]) = [h mi s];

% ready
return;