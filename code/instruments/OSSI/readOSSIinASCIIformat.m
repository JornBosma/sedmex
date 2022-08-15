function data = readOSSIinASCIIformat(fullFileName)

% FUNCTION DATA = READOSSIINASCIIFORMAT(FULLFILENAME)
%
% This function reads the ASCII *.CSV file produced by an Ocean Sensor
% Systems Wave Gauge OSSI-010-003B. The input file (with its full path given
% as input by fullFileName) is read by readtext.m, with empty fields set to NaN.
% Each burst may miss some pressure values! I have
% not tested this file with the temperature switched off. Output is the
% structure data, with the fields timeIN (start time in dateVec format), Fs
% (sampling frequency), p (pressure values; these still need to be
% converted to m water), and T (air temperature in deg. Celsius). p and T
% are timeseries. These fields are available for every burst.
%
% v1, Gerben Ruessink, 21 May 2009
% v2, Gerben Ruessink, 25 May 2009; added remove NaN for p and T

if ~exist('readtext.m','file')
    error('The file readtext.m is not on the search path.');
end

[rawData, results] = readtext(fullFileName,',','','','empty2nan');

% find string lines --> these are the headers and number of bursts minus 1
idString = find(results.stringMask(:,1)==1);
nBursts = length(idString) - 1;
if nBursts == 0
    data = [];
    return;
end

% get sampling frequency from header line
Fs = str2double(rawData{1,7}(2:3));

% prepare to process all bursts
idString(1) = [];
idString(end+1) = results.rows;

% loop for all bursts
for b = 1:nBursts
    
    % timeIN (in datevec format)
    timeIN = [str2double(rawData{idString(b),1}(2:3)) + 2000, ...
              str2double(rawData{idString(b),2}(2:3)), ...
              str2double(rawData{idString(b),3}(2:3)), ...
              str2double(rawData{idString(b),4}(2:3)), ...
              str2double(rawData{idString(b),5}(2:3)), ...
              str2double(rawData{idString(b),6}(2:3))];
        
    % data (pressure and temperature)
    idData = find(results.numberMask(idString(b):idString(b+1),1)==1) + idString(b) - 1;
    thisBurstPressure = cell2mat(rawData(idData,1:12))';
    thisBurstPressure = thisBurstPressure(:);
    thisBurstTemperature = cell2mat(rawData(idData,13))*0.0625;

    % and store (remove NaNs as well; NaNs are sometimes found at the END
    % of a burst; I have never seen them inside a burst)
    data(b).timeIN = timeIN;
    data(b).p = thisBurstPressure(~isnan(thisBurstPressure));
    data(b).Fs = Fs;
    data(b).T = thisBurstTemperature(~isnan(thisBurstTemperature));

    % just to make sure, get rid of original values
    clear timeIN thisBurstPressure thisBurstTemperature;

end