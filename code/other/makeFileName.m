function fileName = makeFileName(t,site,instrument)

% MAKEFILENAME - construct filename given time t (in local time), site
% (string), and instrument (string). For example, t = MET2sedmextime([2021 10 12 0 0 0]),
% site = 'PHZ', instrument = 'OSSI01', results in:
% 2764800.Oct.12_00_00_00.MET.2021.PHZ.OSSI01.mat. All (calibrated) data
% files are in this specific format.
%
% v1, Gerben Ruessink, 09 October 2020
% v2, Jorn Bosma, 27 October 2021, sedmex version

sep = '.';
fileName = [num2str(t) sep sedmextime2METstring(t) sep site sep instrument sep 'mat'];