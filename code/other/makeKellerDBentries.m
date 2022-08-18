% make Keller instrument entry
% C5 Keller DCX-22 #149592

close all
clear
clc

sedmexInit
global basePath

L2C1_Keller(1).timeIN = MET2sedmextime([2021 9 10 0 0 0]);
L2C1_Keller(1).timeOUT = MET2sedmextime([2021 10 19 10 0 0]);
L2C1_Keller(1).type = 'DCX-22';
L2C1_Keller(1).serialNumber = '149592';
L2C1_Keller(1).slope = 1;
L2C1_Keller(1).Intercept = 0;
L2C1_Keller(1).sampleFrequency = 1/300;   % in Hz, so every 5 minutes
L2C1_Keller(1).fieldIntercept = -2.5;     % sensor reads too low, thus 2.5 mbar needs to be added: data = data - fieldIntercept
L2C1_Keller(1).x = 117157.618; % xRD
L2C1_Keller(1).y = 559855.384; % yRD
L2C1_Keller(1).z = 1.862;      % bed level [m +nap] on 16/09

save([basePath 'DB' filesep 'instruments.mat'], '*Keller', '-append')