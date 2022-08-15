% process L2C5_OSSI SEDMEX

close all
clear
clc

sedmexInit
global basePath

% OSSI name in the database
SN = 'L2C5_OSSI';

% where is the data?
rawDataPath = [basePath, 'dataRaw' filesep 'OSSI' filesep 'L2C5 OSSI #04.18.09.00.10' filesep 'raw' filesep];

% this is when the OSSI worked
tIn = DBGetDatabaseEntry('instruments',SN,'timeIN',MET2sedmextime([2021 9 19 15 0 0]));
tOut = DBGetDatabaseEntry('instruments',SN,'timeOUT',MET2sedmextime([2021 10 19 10 0 0]));

% file characteristics
dirInfo = dir([rawDataPath,'*.csv']);
nFiles = size(dirInfo,1);

for f = 11:nFiles-10 % based on data check

    % filenaam
    fullFileName = [rawDataPath,dirInfo(f).name];  
    
    % info naar scherm
    fprintf('Working on %s\n',dirInfo(f).name);
    
    % lees data. Er is in bursts per dag gewerkt, dus er is maar 1 burst
    dataOSSI = readOSSIinASCIIformat(fullFileName);

    % ga calibreren (eerst tijd-as maken van luchtdrukcorrectie)
    timeIN = MET2sedmextime(dataOSSI.timeIN);
    nSamples = length(dataOSSI.p);
    t = timeIN:1/dataOSSI.Fs:timeIN+nSamples/dataOSSI.Fs-1/dataOSSI.Fs;
    t = t(:);

    % bereken offset tot op 1 s
    try
       tOffset = estimateOssiTimeOffset(SN,t(1));
       tOffset = round(tOffset(2));
    catch %#ok<CTCH> 
       tOffset = 0;
    end
    t = t - tOffset;                                                  
 
    try
        p = calibrateOSSI(SN,dataOSSI.p,t);
    catch %#ok<CTCH>
        continue  % mocht er geen luchtdruk zijn
    end
    
    % instrument above water --> NaN
    p(p<0.025) = NaN;
        
    % filenaam voor output (in database format)
    fileName = makeFileName(t(1),'sedmex',SN);

    % gebaseerd op een check van de data
    if f == 11
        p(1:562000) = NaN;
    elseif f == nFiles-10
        p(432000:end) = NaN;
    end
    
    % voeg tijd en gecalibreerde data samen en sla op
    data = [t p];
    save([basePath 'data' filesep 'OSSI' filesep SN filesep fileName], 'data');
    
    % maak metadata
    L2C5_OSSI.fileName = fileName;
    L2C5_OSSI.timeIN = t(1);
    L2C5_OSSI.timeOUT = t(end);
    L2C5_OSSI.p.pos = 2;
    L2C5_OSSI.p.unit = 'm';
    L2C5_OSSI.error = NaN;
    addStructure2AvailableDataDB(SN,L2C5_OSSI);

    % data check
    figure
    plot(p); drawnow; pause(5)
    
end

fprintf('\nProcessing done!\n');
