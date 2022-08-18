% process manual bed-level observations L2C9_OSSI
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
t = MET2sedmextime([2021 9 11 19 15 0]); % first observation (times are rounded to nearest quarter of an hour)
id = data(:,1) == t;
data(id,2) = 0.16;

t = MET2sedmextime([2021 9 13 9 30 0]); % second observation
id = data(:,1) == t;
data(id,2) = 0.19;

t = MET2sedmextime([2021 9 14 20 30 0]); % third observation
id = data(:,1) == t;
data(id,2) = 0.16;

t = MET2sedmextime([2021 9 15 9 30 0]); % etc...
id = data(:,1) == t;
data(id,2) = 0.15;

t = MET2sedmextime([2021 9 16 11 15 0]);
id = data(:,1) == t;
data(id,2) = 0.17;

t = MET2sedmextime([2021 9 17 12 30 0]);
id = data(:,1) == t;
data(id,2) = 0.15;

t = MET2sedmextime([2021 9 18 14 15 0]);
id = data(:,1) == t;
data(id,2) = 0.16;

t = MET2sedmextime([2021 9 19 14 15 0]);
id = data(:,1) == t;
data(id,2) = 0.16;

t = MET2sedmextime([2021 9 20 16 15 0]);
id = data(:,1) == t;
data(id,2) = 0.17;

t = MET2sedmextime([2021 9 23 17 30 0]);
id = data(:,1) == t;
data(id,2) = 0.15;

t = MET2sedmextime([2021 9 26 19 15 0]);
id = data(:,1) == t;
data(id,2) = 0.16;

t = MET2sedmextime([2021 9 28 20 15 0]);
id = data(:,1) == t;
data(id,2) = 0.14;

t = MET2sedmextime([2021 9 30 9 15 0]);
id = data(:,1) == t;
data(id,2) = 0.13;

%% October 2021
t = MET2sedmextime([2021 10 3 13 15 0]);
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 10 6 15 45 0]);
id = data(:,1) == t;
data(id,2) = 0.12;

t = MET2sedmextime([2021 10 7 17 45 0]);
id = data(:,1) == t;
data(id,2) = 0.13;

t = MET2sedmextime([2021 10 11 19 15 0]);
id = data(:,1) == t;
data(id,2) = 0.50;

t = MET2sedmextime([2021 10 13 19 45 0]);
id = data(:,1) == t;
data(id,2) = 0.49;

t = MET2sedmextime([2021 10 18 13 15 0]);
id = data(:,1) == t;
data(id,2) = 0.50;

%%
% prepare output
fileName = makeFileName(data(1,1),'PHZ','manualHeight_L2C9_OSSI');
save([basePath, 'data', filesep, 'misc', filesep, fileName],'data');

% prepare 
manualHeight_L2C9_OSSI.fileName = fileName;
manualHeight_L2C9_OSSI.timeIN = data(1,1);
manualHeight_L2C9_OSSI.timeOUT = data(end,1);
manualHeight_L2C9_OSSI.dt = dt;
manualHeight_L2C9_OSSI.source = 'measured in the field around low tide';
manualHeight_L2C9_OSSI.error = NaN;
manualHeight_L2C9_OSSI.pos = 2;

save([basePath, 'DB' filesep 'instruments.mat'],'manualHeight_L2C9_OSSI','-append')
