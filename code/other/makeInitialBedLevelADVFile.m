% make bed-level SON file

close all
clear
clc

sedmexInit
global basePath

from = DBGetDatabaseEntry('site','PHZ','timeIN',MET2sedmextime([2021 9 10 0 0 0]));
to = DBGetDatabaseEntry('site','PHZ','timeOUT',MET2sedmextime([2021 10 19 0 0 0]));
t = from:1800:to;
t = t';
data = NaN(length(t),7);
data(:,1) = t;

fileName = makeFileName(data(1,1),'PHZ','bedLevelSON');
save([basePath, 'data' filesep 'misc' filesep fileName], 'data');

bedLevelSON.fname = fileName;
bedLevelSON.source = 'SON';
bedLevelSON.timeIN = from;
bedLevelSON.timeOUT = to;
bedLevelSON.dt = 1800;
bedLevelSON.param = 'bedlevel SON';
bedLevelSON.unit = 'm';
bedLevelSON.L2C5_SON1Transducer = 2;
bedLevelSON.L2C5_SON2Transducer = 3;
bedLevelSON.L2C5_SON3Transducer = 4;
bedLevelSON.L2C5_SON1SamplingVolume = 5;
bedLevelSON.L2C5_SON2SamplingVolume = 6;
bedLevelSON.L2C5_SON3SamplingVolume = 7;
bedLevelSON.error = NaN;
bedLevelSON.site = 'PHZ';

save([basePath, 'DB' filesep 'instruments.mat'],'bedLevelSON','-append');
