close all
clear

sedmexInit
global basePath

PHZ.timeIN = MET2sedmextime([2021 9 10 0 0 0]);      % prior to first deployment
PHZ.timeOUT = MET2sedmextime([2021 10 19 0 0 0]);    % after last deployment
PHZ.rho = 1025;                                       % water density
PHZ.g = 9.81;                                         % Earth's gravitation
PHZ.declination =  1.55; % degrees west are negative; M-frame, 01 Oct. 2021 (http://www.ngdc.noaa.gov/geomag-web/#declination)
PHZ.shorelineTrueN = 51; % perpendicular to measurement transect, determined from line drawn along spit in GE Pro 

save([basePath, 'DB' filesep 'site.mat'], 'PHZ')