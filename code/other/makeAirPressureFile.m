% This file processes airpressure files as recorded near PHZ in
% the framework of the SEDMEX campaign

close all
clear
clc

sedmexInit
global basePath

tIN = DBGetDatabaseEntry('instruments','L2C1_Keller','timeIN',MET2sedmextime([2021 9 10 0 0 0])); 
tOUT = DBGetDatabaseEntry('instruments','L2C1_Keller','timeOUT',MET2sedmextime([2021 10 19 10 0 0]));
Fs = DBGetDatabaseEntry('instruments','L2C1_Keller','sampleFrequency',MET2sedmextime([2021 9 10 0 0 0])); 
dt = 1/Fs;
tAxis = (tIN:dt:tOUT)';
Nt = length(tAxis);
data = NaN*ones([Nt,2]);
data(:,1) = tAxis;
fileName = makeFileName(tIN,'sedmex','L2C1_Keller');
meta.fileName = fileName;
meta.source = 'UU KellerAir sensor on upper beach (L2C1)';
meta.timeIN = data(1,1);
meta.timeOUT = data(end,1);
meta.dt = dt;
meta.atmPressure.pos = 2;
meta.atmPressure.unit = 'mbar';
meta.error = NaN;
meta.sampleFrequency = Fs;

% add meta data to database
addStructure2AvailableDataDB('L2C1_Keller',meta)

% offset (= to convert upper-beach sensor to sea level)
offset = DBGetDatabaseEntry('instruments','L2C1_Keller','fieldIntercept', MET2sedmextime([2021 9 10 0 0 0]));

% This is the list of files to be processed, including their path
airPressureFiles{1} = strcat(basePath,'dataRaw\Keller\C5 Keller DCX-22 #149592\export\_08_09_2021-00_00_00.TXT');
nFiles = size(airPressureFiles,2);

% Now process all files: adjust if necessary!!
for f = 1:nFiles

    allData = readtext(airPressureFiles{f}, '[\t:]', '', '', '');  
    noHeaderLines = 9;
    atmPres = cell2mat(allData(noHeaderLines+1:end,7)) - offset;
    day = datenum(allData(noHeaderLines+1:end,3),'dd-mm-yyyy');
    day = datevec(day);
    day(:,4) = cell2mat(allData(noHeaderLines+1:end,4));
    day(:,5) = cell2mat(allData(noHeaderLines+1:end,5));
    day(:,6) = cell2mat(allData(noHeaderLines+1:end,6));
        
    % remove final value: often incorrect because sensor was moved prior to
    % data readout.
    % atmPres(end) = []; day(end,:) = [];
    
    % set to local time
    sedmextime = MET2sedmextime(day);

    % now interpolate onto those parts that are NaNs
    id = isnan(data(:,2));
    data(id,2) = interp1(sedmextime,atmPres,data(id,1));
    
end
   
% and now, fill small gaps with linear interpolation (happened only once
% during mid-campaign data offload)
% id = ~isnan(data(:,2));
% data(:,2) = interp1(data(id,1),data(id,2),data(:,1));

% Check time series
figure
plot(data(:,1),data(:,2))
axis tight

% Finally! Save output file
save([basePath filesep 'data' filesep 'Keller' filesep meta.fileName], 'data')
