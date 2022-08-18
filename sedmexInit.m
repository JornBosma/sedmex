function sedmexInit
% function [xl, yl, xt, yt, fontsize] = sedmexInit

% define global variables
global basePath

% set base path. All subdirectories are branches from the base path.
basePath = strrep(which('sedmexInit'),'sedmexInit.m','');

% add paths
addpath(basePath)
addpath(genpath([basePath 'code']))
addpath(genpath([basePath 'DB']))
addpath(genpath([basePath 'data']))
addpath(genpath([basePath 'results']))

% set default settings
set(groot, 'DefaultAxesFontSize', 22)
set(groot, 'DefaultTextInterpreter', 'latex')
set(groot, 'DefaultAxesTickLabelInterpreter', 'latex')
set(groot, 'DefaultLegendInterpreter', 'latex')
set(groot, 'DefaultLegendLocation', 'northwest')
set(groot, 'DefaultLegendBox', 'off')
set(groot, 'DefaultAxesBox', 'off')

% % initialise Open Earth Tools
% addpath(['C:' filesep 'Users' filesep '4156366' filesep 'OET' filesep 'matlab'])
% oetsettings('quiet')

% % set parameters
% fontsize = 22;

% % axis limits and ticks
% xl = [1.148e+05, 1.1805e+05]; % PHZD
% yl = [5.5775e+05, 5.6065e+05];
% xt = 114000:1e3:118000;
% yt = 558000:1e3:561000;
% % xl = [1.1695e+05, 1.1765e+05]; % spit hook zoom-in
% % yl = [5.5976e+05, 5.6040e+05];

% ready
return