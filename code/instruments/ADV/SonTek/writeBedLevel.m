function [] = writeBedLevel(bed,fieldName,t)

% function file to add a SON bedlevel value measured at time t by instrument
% fieldName (SON1, SON2 or SON3) to bedLevel file.

global basePath

% get existing data
fileName = DBGetDatabaseEntry('instruments','bedLevelSON','fname',t);
load([basePath filesep 'data' filesep 'misc' filesep fileName],'data')

% relevant column
colPos = DBGetDatabaseEntry('instruments','bedLevelSON',strcat(fieldName,'Transducer'),t);

% find nearest entry
[dummy, id] = min(abs(data(:,1)-t));
clear dummy

% make entry into datbase --> no check whether data already exists!
data(id,colPos) = bed(1);
data(id,colPos+3) = bed(2);

% save data
save([basePath filesep 'data' filesep 'misc' filesep fileName],'data')