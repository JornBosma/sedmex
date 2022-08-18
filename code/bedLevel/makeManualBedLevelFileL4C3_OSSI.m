% process manual bed-level observations L4C3_OSSI
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
data(id,2) = 0.23;

t = MET2sedmextime([2021 9 13 9 30 0]); % second observation
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 9 14 20 30 0]); % third observation (time tag missing)
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 9 15 9 0 0]); % etc...
id = data(:,1) == t;
data(id,2) = 0.21;

t = MET2sedmextime([2021 9 16 10 45 0]);
id = data(:,1) == t;
data(id,2) = 0.25;

t = MET2sedmextime([2021 9 17 12 0 0]);
id = data(:,1) == t;
data(id,2) = 0.23;

t = MET2sedmextime([2021 9 18 13 45 0]);
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 9 26 20 0 0]);
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 9 28 19 15 0]);
id = data(:,1) == t;
data(id,2) = 0.21;

%% October 2021
t = MET2sedmextime([2021 10 3 13 0 0]);
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 10 7 16 30 0]);
id = data(:,1) == t;
data(id,2) = 0.20;

t = MET2sedmextime([2021 10 11 18 30 0]);
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 10 13 19 0 0]);
id = data(:,1) == t;
data(id,2) = 0.23;

t = MET2sedmextime([2021 10 18 14 30 0]);
id = data(:,1) == t;
data(id,2) = 0.21;

%%
% prepare output
fileName = makeFileName(data(1,1),'PHZ','manualHeight_L4C3_OSSI');
save([basePath, 'data', filesep, 'misc', filesep, fileName],'data');

% prepare 
manualHeight_L4C3_OSSI.fileName = fileName;
manualHeight_L4C3_OSSI.timeIN = data(1,1);
manualHeight_L4C3_OSSI.timeOUT = data(end,1);
manualHeight_L4C3_OSSI.dt = dt;
manualHeight_L4C3_OSSI.source = 'measured in the field around low tide';
manualHeight_L4C3_OSSI.error = NaN;
manualHeight_L4C3_OSSI.pos = 2;

save([basePath, 'DB' filesep 'instruments.mat'],'manualHeight_L4C3_OSSI','-append')
