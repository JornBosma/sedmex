function waterlevel = calibrateOSSI(SN,rawPressure,t)

% FUNCTION WATERLEVEL = CALIBRATEOSSI(SN,RAWPRESSURE,T)
%
% This function transforms the pressure ("rawPressure") measured by an
% OSSI pressure transducer with serial number SN into the corresponding
% waterlevel. t has the same length as rawPressure. Correction for air
% pressure is made. Note that this file assumes that all data and
% structures are stored as designed originally by GR for Truc Vert, ECORS,
% 2008. 
%
% v1, Gerben Ruessink, 28 May 2009
% v2, Gerben Ruessink, 27 November 2012: read rho and g from database.
% v3, Jorn Bosma, 2022: KellerAir --> L1C2_Keller

% start-time
startTime = t(1);

% check whether OSSI with serial number SN is available in instruments.mat
check = load('instruments.mat',SN);
if ~isfield(check,SN)
    error('OSSI with serial number %s does not exist in instruments database',SN);
end

% obtain information for pressure transducer
slope = DBGetDatabaseEntry('instruments',SN,'slope',startTime);
offset = DBGetDatabaseEntry('instruments',SN,'offset',startTime);
fieldOffset = DBGetDatabaseEntry('instruments',SN,'fieldOffset',startTime); 

% obtain atmospheric pressure data
atmPressure = DBGetData('L2C1_Keller',[t(1) t(end)],{'atmPressure'});
atmPressure4OSSI = interp1(atmPressure(:,1),atmPressure(:,2),t);

% calibration, bar --> mbar
p = slope*(rawPressure*1000) + offset - atmPressure4OSSI + fieldOffset;

% transform to waterlevel; corrected on 27/11/2012. rho = 1025 kg/m3 and g
% = 9.81 m/s2 were hardwired! Not good for flume experiments with fresh
% water.
site = load('site.mat');
site = fieldnames(site);
rho = DBGetDatabaseEntry('site',site{1},'rho',startTime);
g = DBGetDatabaseEntry('site',site{1},'g',startTime);
waterlevel = (p*100)/(rho*g);  % *100 converts from mbar to Pa

% ready
return