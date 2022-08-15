% process manual bed-level observations L2C5_OSSI
close all
clear
clc

sedmexInit
global basePath

from = DBGetDatabaseEntry('site','PHZ','timeIN',MET2sedmextime([2021 9 10 0 0 0]));
to = DBGetDatabaseEntry('site','PHZ','timeOUT',MET2sedmextime([2021 9 10 0 0 0]));

dt = 15*60;                % resolution of 15 minutes
tAxis = from:900:to;      
data = NaN(length(tAxis),2);
data(:,1) = tAxis';

% now add observations; when done, just run entire file

%% September 2021
t = MET2sedmextime([2021 9 20 16 30 0]); % first observation (times are rounded to nearest quarter of an hour)
id = data(:,1) == t;
data(id,2) = 0.32;

t = MET2sedmextime([2021 9 28 20 0 0]); % second observation
id = data(:,1) == t;
data(id,2) = 0.31;

t = MET2sedmextime([2021 9 30 9 0 0]); % third observation
id = data(:,1) == t;
data(id,2) = 0.34;

%% October 2021
t = MET2sedmextime([2021 10 2 11 30 0]); % etc...
id = data(:,1) == t;
data(id,2) = 0.30;

t = MET2sedmextime([2021 10 6 15 45 0]);
id = data(:,1) == t;
data(id,2) = 0.05;

t = MET2sedmextime([2021 10 7 17 30 0]);
id = data(:,1) == t;
data(id,2) = 0.04;

t = MET2sedmextime([2021 10 11 19 0 0]);
id = data(:,1) == t;
data(id,2) = 0.07;

t = MET2sedmextime([2021 10 13 19 30 0]);
id = data(:,1) == t;
data(id,2) = 0.11;

t = MET2sedmextime([2021 10 18 13 0 0]);
id = data(:,1) == t;
data(id,2) = 0.11;

%%
% prepare output
fileName = makeFileName(data(1,1),'PHZ','manualHeight_L2C5_OSSI');
save([basePath, 'data', filesep, 'misc', filesep, fileName],'data');

% prepare 
manualHeight_L2C5_OSSI.fileName = fileName;
manualHeight_L2C5_OSSI.timeIN = data(1,1);
manualHeight_L2C5_OSSI.timeOUT = data(end,1);
manualHeight_L2C5_OSSI.dt = dt;
manualHeight_L2C5_OSSI.source = 'measured in the field around low tide';
manualHeight_L2C5_OSSI.error = NaN;
manualHeight_L2C5_OSSI.pos = 2;

save([basePath, 'DB' filesep 'instruments.mat'],'manualHeight_L2C5_OSSI','-append')
