% process manual bed-level observations L6C2_OSSI
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
t = MET2sedmextime([2021 9 13 20 30 0]); % first observation (times are rounded to nearest quarter of an hour)
id = data(:,1) == t;
data(id,2) = 0.24;

t = MET2sedmextime([2021 9 14 20 30 0]); % second observation (time tag missing)
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 9 15 8 30 0]); % etc...
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 9 16 10 15 0]);
id = data(:,1) == t;
data(id,2) = 0.25;

t = MET2sedmextime([2021 9 17 11 30 0]);
id = data(:,1) == t;
data(id,2) = 0.21;

t = MET2sedmextime([2021 9 18 13 15 0]);
id = data(:,1) == t;
data(id,2) = 0.22;

t = MET2sedmextime([2021 9 23 16 45 0]);
id = data(:,1) == t;
data(id,2) = 0.25;

t = MET2sedmextime([2021 9 28 17 30 0]);
id = data(:,1) == t;
data(id,2) = 0.22;

%% October 2021
t = MET2sedmextime([2021 10 3 12 15 0]);
id = data(:,1) == t;
data(id,2) = 0.24;

t = MET2sedmextime([2021 10 6 16 45 0]);
id = data(:,1) == t;
data(id,2) = 0.24;

t = MET2sedmextime([2021 10 11 18 0 0]);
id = data(:,1) == t;
data(id,2) = 0.23;

t = MET2sedmextime([2021 10 13 18 30 0]);
id = data(:,1) == t;
data(id,2) = 0.24;

t = MET2sedmextime([2021 10 18 15 0 0]);
id = data(:,1) == t;
data(id,2) = 0.26;

%%
% prepare output
fileName = makeFileName(data(1,1),'PHZ','manualHeight_L6C2_OSSI');
save([basePath, 'data', filesep, 'misc', filesep, fileName],'data');

% prepare 
manualHeight_L6C2_OSSI.fileName = fileName;
manualHeight_L6C2_OSSI.timeIN = data(1,1);
manualHeight_L6C2_OSSI.timeOUT = data(end,1);
manualHeight_L6C2_OSSI.dt = dt;
manualHeight_L6C2_OSSI.source = 'measured in the field around low tide';
manualHeight_L6C2_OSSI.error = NaN;
manualHeight_L6C2_OSSI.pos = 2;

save([basePath, 'DB' filesep 'instruments.mat'],'manualHeight_L6C2_OSSI','-append')
