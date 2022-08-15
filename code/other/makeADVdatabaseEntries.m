% make ADV instruments entry

close all
clear
clc

sedmexInit
global basePath

timeIN = MET2sedmextime([2021 9 10 0 0 0]); % summertime [UTC+2]
timeOUT = MET2sedmextime([2021 10 19 10 0 0]);

%% L2C5_SON1
output = adr2mat([basePath, 'dataRaw' filesep 'ADV' filesep 'L2C5 SonTek Hydra #B329' filesep 'raw' filesep '1ADV027.adr']);

L2C5_ADV1(1).timeIN = timeIN;              % starting time in MET (summertime)
L2C5_ADV1(1).timeOUT = timeOUT;            % end time of this deployment in MET (summertime)
L2C5_ADV1(1).summerTime = 0;               % instrument operates in summertime (= 1) OR summertime (= 0)
L2C5_ADV1(1).type = output.metadata.probetype; % instrument type
L2C5_ADV1(1).serialNumber = output.metadata.serialnum; % serial number of instrument
L2C5_ADV1(1).sensorOrientation = output.metadata.sensororientation; % orientation of transducer ('up', 'side' or 'down')
L2C5_ADV1(1).transformationMatrix = output.metadata.xfercoeff; % transformation matrix: beam -> XYZ or ENU
L2C5_ADV1(1).x = 117197.7;                 % RD x-coordinate [m]
L2C5_ADV1(1).y = 559814.9;                 % RD y-coordinate [m]
L2C5_ADV1(1).z = -0.76;                    % zBed [m +NAP] at start of measurement period
L2C5_ADV1(1).zAboveBed = 0.18;             % height of measurement volume above the bed [m] at start of measurement period
L2C5_ADV1(1).xRef = 118590.013;            % RD x-coordinate reference point (= white church @Oudeschild)
L2C5_ADV1(1).yRef = 561003.04;             % RD y-coordinate reference point (= white church @Oudeschild)
L2C5_ADV1(1).xOrientation = atan2d(L2C5_ADV1(1).xRef-L2C5_ADV1(1).x, L2C5_ADV1(1).yRef-L2C5_ADV1(1).y); % direction of x-axis relative to true north [deg]
% L2C5_ADV1(1).pressureOffset = 0;         % [dbar]
% L2C5_ADV1(1).pressureScale = 1;          % [dbar/count]
% L2C5_ADV1(1).fieldOffset = 0;
L2C5_ADV1(1).sampleFrequency = output.samprate(1); % sampling frequency [Hz]
L2C5_ADV1(1).Frequency = 5e6;              % head frequency [Hz]

%% L2C3_VEC(1)
L2C3_VEC(1).timeIN = timeIN;               % starting time in MET (summertime)
L2C3_VEC(1).timeOUT = timeOUT;             % end time of this deployment in MET (summertime)
L2C3_VEC(1).summerTime = 0;                % instrument operates in summertime (= 1) OR summertime (= 0)
L2C3_VEC(1).type = 'Nortek Vector';        % instrument type
L2C3_VEC(1).serialNumber = '';             % serial number (from sticker on instrument)
L2C3_VEC(1).x = 117194.2;                  % RD x-coordinate [m]
L2C3_VEC(1).y = 559820;                    % RD y-coordinate [m]
L2C3_VEC(1).z = -0.12;                     % zBed [m +NAP] at start of measurement period
L2C3_VEC(1).zAboveBed = 0.175;             % height of transducer above the bed at start of measurement period [m]
L2C3_VEC(1).xRef = 118590.013;             % RD x-coordinate reference point (= white church @Oudeschild)
L2C3_VEC(1).yRef = 561003.04;              % RD y-coordinate reference point (= white church @Oudeschild)
L2C3_VEC(1).xOrientation = 90-atan2d(L2C3_VEC(1).xRef-L2C3_VEC(1).x, L2C3_VEC(1).yRef-L2C3_VEC(1).y); % angle of x-axis wrt north [deg]
L2C3_VEC(1).sensorOrientation = 'down';    % orientation of transducer ('up', 'side' or 'down')
L2C3_VEC(1).transformationMatrix = [2.7986 -1.4060 -1.3965; 0.0056 -2.3894 2.3848; -0.3486 -0.3416 -0.3394]'; % transformation matrix: beam -> XYZ or ENU
% L2C3_VEC(1).pressureOffset = 865.5;
% L2C3_VEC(1).pressureScale = 0.016827;
% L2C3_VEC(1).fieldOffset = 0;
L2C3_VEC(1).timeOffset = -4.148;           % difference between computer and instrument time at end of deployment [s]
L2C3_VEC(1).sampleFrequency = 16;          % sampling frequency [Hz]
L2C3_VEC(1).Frequency = 6e6;               % head frequency [Hz]

%% save
% save([basePath 'DB' filesep 'instruments.mat'], '*ADV*', '*VEC', '-append');
fprintf(2, 'Saved to instruments.mat\n')
