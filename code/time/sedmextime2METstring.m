function METstring = sedmextime2METstring(sedmextime)

% use: METstring = sedmextime2METstring(sedmextime)
%
% where sedmextime is a single [1 x 1] time, which is converted into
% a MET string to be used in a file name. The MET string has the following
% structure: MON.HH_MM_SS.YYYY.
%
% v1, Gerben Ruessink, 09 October 2020
% v2, Jorn Bosma, 27 October 2021

% check input
if length(sedmextime) ~= 1
    error('Specify a single sedmextime only');
end

% convert sedmextime to METtime
METtime = sedmex2METtime(sedmextime);

% make LSTstring
METstring = strcat(datestr(METtime,'mmm'),'.',datestr(METtime,'dd'),'_',datestr(METtime,'HH'),'_',...
                   datestr(METtime,'MM'),'_',datestr(METtime,'SS'),'.','MET','.',datestr(METtime,'yyyy'));

% ready
return;