% make OSSI instruments entry

close all
clear
clc

sedmexInit
global basePath

timeIN = MET2sedmextime([2021 9 10 0 0 0]); % summertime [UTC+2]
timeOUT = MET2sedmextime([2021 10 19 10 0 0]);

L1C2_OSSI(1).timeIN = timeIN;
L1C2_OSSI(1).timeOUT = timeOUT;
L1C2_OSSI(1).summerTime = 1; % instrument operates in summertime (= 1) OR wintertime (= 0)
L1C2_OSSI(1).type = 'OSSI-010-003C0-3';
L1C2_OSSI(1).serialNumber = '04.18.09.00.01';
L1C2_OSSI(1).pressureSensor = 'Paroscientific 745 S/N 97581';
L1C2_OSSI(1).slope = 1;
L1C2_OSSI(1).offset = 1022.2 - 28.0;
L1C2_OSSI(1).sampleFrequency = 10;
L1C2_OSSI(1).fieldOffset = 0;
L1C2_OSSI(1).sensorHeight = 0.23; % mean sensor height above the bed [m]
L1C2_OSSI(1).x = 117445.4; % averaged over measurement period
L1C2_OSSI(1).y = 560044.7; % averaged over measurement period
L1C2_OSSI(1).zb = -1.46;   % mean bed level [m +NAP] (averaged over measurement period)
L1C2_OSSI(1).zi = L1C2_OSSI(1).zb + L1C2_OSSI(1).sensorHeight; % mean instrument (sensor) level [m +NAP]
L1C2_OSSI(1).timeOffset(1,1) = MET2sedmextime([2021 8 24 15 20 0]);
L1C2_OSSI(1).timeOffset(1,2) = 0;
L1C2_OSSI(1).timeOffset(2,1) = MET2sedmextime([2021 10 28 11 20 0]);
L1C2_OSSI(1).timeOffset(2,2) = -136;

L2C5_OSSI(1).timeIN = MET2sedmextime([2021 9 19 0 0 0]);
L2C5_OSSI(1).timeOUT = timeOUT;
L2C5_OSSI(1).summerTime = 1; % instrument operates in summertime (= 1) OR wintertime (= 0)
L2C5_OSSI(1).type = 'OSSI-010-003C0-3';
L2C5_OSSI(1).serialNumber = '04.18.09.00.10';
L2C5_OSSI(1).pressureSensor = 'Paroscientific 745 S/N 97581';
L2C5_OSSI(1).slope = 1; % perhaps this one should be different, as this OSSI was on its side
L2C5_OSSI(1).offset = 1022.2 - 20.1;
L2C5_OSSI(1).sampleFrequency = 10;
L2C5_OSSI(1).fieldOffset = 0;
L2C5_OSSI(1).sensorHeight = 0.18;
L2C5_OSSI(1).x = 117197.9;
L2C5_OSSI(1).y = 559816.1;
L2C5_OSSI(1).zb = -0.61;
L2C5_OSSI(1).zi = L2C5_OSSI(1).zb + L2C5_OSSI(1).sensorHeight;
L2C5_OSSI(1).timeOffset(1,1) = MET2sedmextime([2021 8 24 15 30 0]);
L2C5_OSSI(1).timeOffset(1,2) = 0;
L2C5_OSSI(1).timeOffset(2,1) = MET2sedmextime([2021 10 28 11 20 0]);
L2C5_OSSI(1).timeOffset(2,2) = -71;

L2C6_OSSI(1).timeIN = timeIN;
L2C6_OSSI(1).timeOUT = timeOUT;
L2C6_OSSI(1).summerTime = 1; % instrument operates in summertime (= 1) OR wintertime (= 0)
L2C6_OSSI(1).type = 'OSSI-010-003C0-3';
L2C6_OSSI(1).serialNumber = '04.18.09.00.03';
L2C6_OSSI(1).pressureSensor = 'Paroscientific 745 S/N 97581';
L2C6_OSSI(1).slope = 1;
L2C6_OSSI(1).offset = 1022.2 - 17.6;
L2C6_OSSI(1).sampleFrequency = 10;
L2C6_OSSI(1).fieldOffset = 0;
L2C6_OSSI(1).sensorHeight = 0.15;
L2C6_OSSI(1).x = 117201.9;
L2C6_OSSI(1).y = 559812.5;
L2C6_OSSI(1).zb = -1.17;
L2C6_OSSI(1).zi = L2C6_OSSI(1).zb + L2C6_OSSI(1).sensorHeight;
L2C6_OSSI(1).timeOffset(1,1) = MET2sedmextime([2021 8 24 15 20 0]);
L2C6_OSSI(1).timeOffset(1,2) = 0;
L2C6_OSSI(1).timeOffset(2,1) = MET2sedmextime([2021 10 28 11 20 0]);
L2C6_OSSI(1).timeOffset(2,2) = -19;

L2C8_OSSI(1).timeIN = timeIN;
L2C8_OSSI(1).timeOUT = timeOUT;
L2C8_OSSI(1).summerTime = 1; % instrument operates in summertime (= 1) OR wintertime (= 0)
L2C8_OSSI(1).type = 'OSSI-010-003C0-3';
L2C8_OSSI(1).serialNumber = '04.18.09.00.09';
L2C8_OSSI(1).pressureSensor = 'Paroscientific 745 S/N 97581';
L2C8_OSSI(1).slope = 1;
L2C8_OSSI(1).offset = 1022.2 - 32.4;
L2C8_OSSI(1).sampleFrequency = 10;
L2C8_OSSI(1).fieldOffset = 0;
L2C8_OSSI(1).sensorHeight = 0.21;
L2C8_OSSI(1).x = 117208.6;
L2C8_OSSI(1).y = 559805.9;
L2C8_OSSI(1).zb = -1.33;
L2C8_OSSI(1).zi = L2C8_OSSI(1).zb + L2C8_OSSI(1).sensorHeight;
L2C8_OSSI(1).timeOffset(1,1) = MET2sedmextime([2021 8 24 15 30 0]);
L2C8_OSSI(1).timeOffset(1,2) = 0;
L2C8_OSSI(1).timeOffset(2,1) = MET2sedmextime([2021 10 28 11 20 0]);
L2C8_OSSI(1).timeOffset(2,2) = -27;

L2C9_OSSI(1).timeIN = timeIN;
L2C9_OSSI(1).timeOUT = timeOUT;
L2C9_OSSI(1).summerTime = 1; % instrument operates in summertime (= 1) OR wintertime (= 0)
L2C9_OSSI(1).type = 'OSSI-010-003C0-3';
L2C9_OSSI(1).serialNumber = '04.18.09.00.08';
L2C9_OSSI(1).pressureSensor = 'Paroscientific 745 S/N 97581';
L2C9_OSSI(1).slope = 1;
L2C9_OSSI(1).offset = 1022.2 - 22.8;
L2C9_OSSI(1).sampleFrequency = 10;
L2C9_OSSI(1).fieldOffset = 0;
L2C9_OSSI(1).sensorHeight = 0.16;
L2C9_OSSI(1).x = 117221.8;
L2C9_OSSI(1).y = 559793.1;
L2C9_OSSI(1).zb = -1.46;
L2C9_OSSI(1).zi = L2C9_OSSI(1).zb + L2C9_OSSI(1).sensorHeight;
L2C9_OSSI(1).timeOffset(1,1) = MET2sedmextime([2021 8 24 15 30 0]);
L2C9_OSSI(1).timeOffset(1,2) = 0;
L2C9_OSSI(1).timeOffset(2,1) = MET2sedmextime([2021 10 28 11 20 0]);
L2C9_OSSI(1).timeOffset(2,2) = -63;

L4C3_OSSI(1).timeIN = timeIN;
L4C3_OSSI(1).timeOUT = timeOUT;
L4C3_OSSI(1).summerTime = 1; % instrument operates in summertime (= 1) OR wintertime (= 0)
L4C3_OSSI(1).type = 'OSSI-010-003C0-3';
L4C3_OSSI(1).serialNumber = '04.18.09.00.04';
L4C3_OSSI(1).pressureSensor = 'Paroscientific 745 S/N 97581';
L4C3_OSSI(1).slope = 1;
L4C3_OSSI(1).offset = 1022.2 - 22.1;
L4C3_OSSI(1).sampleFrequency = 10;
L4C3_OSSI(1).fieldOffset = 0;
L4C3_OSSI(1).sensorHeight = 0.22;
L4C3_OSSI(1).x = 116125;
L4C3_OSSI(1).y = 558917.3;
L4C3_OSSI(1).zb = -1.43;
L4C3_OSSI(1).zi = L4C3_OSSI(1).zb + L4C3_OSSI(1).sensorHeight;
L4C3_OSSI(1).timeOffset(1,1) = MET2sedmextime([2021 8 24 15 20 0]);
L4C3_OSSI(1).timeOffset(1,2) = 0;
L4C3_OSSI(1).timeOffset(2,1) = MET2sedmextime([2021 10 28 11 20 0]);
L4C3_OSSI(1).timeOffset(2,2) = -73;

L5C2_OSSI(1).timeIN = timeIN;
L5C2_OSSI(1).timeOUT = timeOUT;
L5C2_OSSI(1).summerTime = 1; % instrument operates in summertime (= 1) OR wintertime (= 0)
L5C2_OSSI(1).type = 'OSSI-010-003C0-3';
L5C2_OSSI(1).serialNumber = '04.18.09.00.05';
L5C2_OSSI(1).pressureSensor = 'Paroscientific 745 S/N 97581';
L5C2_OSSI(1).slope = 1;
L5C2_OSSI(1).offset = 1022.2 - 21.7;
L5C2_OSSI(1).sampleFrequency = 10;
L5C2_OSSI(1).fieldOffset = 0;
L5C2_OSSI(1).sensorHeight = 0.23;
L5C2_OSSI(1).x = 115715.8;
L5C2_OSSI(1).y = 558560.3;
L5C2_OSSI(1).zb = -1.45;
L5C2_OSSI(1).zi = L5C2_OSSI(1).zb + L5C2_OSSI(1).sensorHeight;
L5C2_OSSI(1).timeOffset(1,1) = MET2sedmextime([2021 8 24 15 20 0]);
L5C2_OSSI(1).timeOffset(1,2) = 0;
L5C2_OSSI(1).timeOffset(2,1) = MET2sedmextime([2021 10 28 11 20 0]);
L5C2_OSSI(1).timeOffset(2,2) = -37;

L6C2_OSSI(1).timeIN = timeIN;
L6C2_OSSI(1).timeOUT = timeOUT;
L6C2_OSSI(1).summerTime = 1; % instrument operates in summertime (= 1) OR wintertime (= 0)
L6C2_OSSI(1).type = 'OSSI-010-003C0-3';
L6C2_OSSI(1).serialNumber = '04.18.09.00.06';
L6C2_OSSI(1).pressureSensor = 'Paroscientific 745 S/N 97581';
L6C2_OSSI(1).slope = 1;
L6C2_OSSI(1).offset = 1022.2 - 25.9;
L6C2_OSSI(1).sampleFrequency = 10;
L6C2_OSSI(1).fieldOffset = 0;
L6C2_OSSI(1).sensorHeight = 0.23;
L6C2_OSSI(1).x = 115469.4;
L6C2_OSSI(1).y = 558176.2;
L6C2_OSSI(1).zb = -1.45;
L6C2_OSSI(1).zi = L6C2_OSSI(1).zb + L6C2_OSSI(1).sensorHeight;
L6C2_OSSI(1).timeOffset(1,1) = MET2sedmextime([2021 8 24 15 20 0]);
L6C2_OSSI(1).timeOffset(1,2) = 0;
L6C2_OSSI(1).timeOffset(2,1) = MET2sedmextime([2021 10 28 11 30 0]);
L6C2_OSSI(1).timeOffset(2,2) = -38;

save([basePath 'DB' filesep 'instruments.mat'],'*OSSI','-append');
fprintf(2, 'Saved to instruments.mat\n')

