% process manual bed-level observations L2C5_SON3
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
data(id,2) = 0.67;

t = MET2sedmextime([2021 9 13 9 15 0]); % second observation
id = data(:,1) == t;
data(id,2) = 0.68;

t = MET2sedmextime([2021 9 14 20 15 0]); % etc...
id = data(:,1) == t;
data(id,2) = 0.69;

t = MET2sedmextime([2021 9 15 9 30 0]);
id = data(:,1) == t;
data(id,2) = 0.69;

t = MET2sedmextime([2021 9 16 11 0 0]);
id = data(:,1) == t;
data(id,2) = 0.52;

t = MET2sedmextime([2021 9 17 12 30 0]);
id = data(:,1) == t;
data(id,2) = 0.69;

t = MET2sedmextime([2021 9 18 14 0 0]);
id = data(:,1) == t;
data(id,2) = 0.69;

t = MET2sedmextime([2021 9 19 14 0 0]);
id = data(:,1) == t;
data(id,2) = 0.71;

t = MET2sedmextime([2021 9 20 16 30 0]);
id = data(:,1) == t;
data(id,2) = 0.68;

t = MET2sedmextime([2021 9 23 17 15 0]);
id = data(:,1) == t;
data(id,2) = 0.67;

t = MET2sedmextime([2021 9 26 19 0 0]);
id = data(:,1) == t;
data(id,2) = 0.78;

t = MET2sedmextime([2021 9 28 20 0 0]);
id = data(:,1) == t;
data(id,2) = 0.77;

t = MET2sedmextime([2021 9 30 9 15 0]);
id = data(:,1) == t;
data(id,2) = 0.78;

%% October 2021
t = MET2sedmextime([2021 10 2 11 30 0]);
id = data(:,1) == t;
data(id,2) = 0.65;

t = MET2sedmextime([2021 10 6 15 30 0]);
id = data(:,1) == t;
data(id,2) = 0.47;

t = MET2sedmextime([2021 10 7 18 30 0]);
id = data(:,1) == t;
data(id,2) = 0.39;

t = MET2sedmextime([2021 10 11 19 0 0]);
id = data(:,1) == t;
data(id,2) = 0.41;

t = MET2sedmextime([2021 10 13 19 30 0]);
id = data(:,1) == t;
data(id,2) = 0.46;

t = MET2sedmextime([2021 10 15 11 0 0]);
id = data(:,1) == t;
data(id,2) = 0.47;

t = MET2sedmextime([2021 10 18 13 0 0]);
id = data(:,1) == t;
data(id,2) = 0.44;

%%
% prepare output
fileName = makeFileName(data(1,1),'PHZ','manualHeight_L2C5_SON3');
save([basePath 'data' filesep 'misc' filesep fileName],'data');

% prepare 
manualHeight_L2C5_SON3.fileName = fileName;
manualHeight_L2C5_SON3.timeIN = data(1,1);
manualHeight_L2C5_SON3.timeOUT = data(end,1);
manualHeight_L2C5_SON3.dt = dt;
manualHeight_L2C5_SON3.source = 'measured in the field around low tide';
manualHeight_L2C5_SON3.error = NaN;
manualHeight_L2C5_SON3.pos = 2;

save([basePath 'DB' filesep 'instruments.mat'],'manualHeight_L2C5_SON3','-append')
