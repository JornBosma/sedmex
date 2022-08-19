function [] = writeTemperature(Temp,fieldName,t)

% function file to add a temperature value measured at time t by instrument
% fieldName (ADV1, ADV2 or ADV3) to temperature file.

global basePath;

% get existing data
fileName = DBGetDatabaseEntry('instruments','waterTemperature','fname',t);
load([basePath filesep 'data' filesep 'misc' filesep fileName],'data');

% relevant column
colPos = DBGetDatabaseEntry('instruments','waterTemperature',(fieldName),t);

% find nearest entry
[~, id] = min(abs(data(:,1)-t));
clear dummy

% make entry into database --> no check whether data already exists!
data(id,colPos) = Temp;

% save data
save([basePath filesep 'data' filesep 'misc' filesep fileName],'data')
