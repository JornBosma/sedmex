% make water temperature file

close all
clear
clc

sedmexInit
global basePath

from = DBGetDatabaseEntry('site','PHZ','timeIN',MET2sedmextime([2021 9 10 0 0 0]));
to = DBGetDatabaseEntry('site','PHZ','timeOUT',MET2sedmextime([2021 10 19 0 0 0]));
t = from:1800:to;
t = t';
data = NaN(length(t),4);
data(:,1) = t;

fileName = makeFileName(data(1,1),'PHZ','waterTemperature');
save([basePath 'data' filesep 'misc' filesep fileName], 'data');

waterTemperature.fname = fileName;
waterTemperature.source = 'SON';
waterTemperature.timeIN = from;
waterTemperature.timeOUT = to;
waterTemperature.dt = 1800;
waterTemperature.param = 'water temperature';
waterTemperature.unit = 'deg Celcius';
waterTemperature.L2C5_SON1 = 2;
waterTemperature.L2C5_SON2 = 3;
waterTemperature.L2C5_SON3 = 4;
waterTemperature.error = NaN;
waterTemperature.site = 'PHZ';

save([basePath, 'DB' filesep 'instruments.mat'],'waterTemperature','-append');
