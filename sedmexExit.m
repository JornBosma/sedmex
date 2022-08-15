function sedmexExit

% define global variables
global basePath

% set base path. All subdirectories are branches from the base path.
basePath = strrep(which('sedmexExit'),'sedmexExit.m','');

% add paths
rmpath(basePath)
rmpath(genpath([basePath 'code']))
rmpath(genpath([basePath 'db']))
rmpath(genpath([basePath 'data']))
rmpath(genpath([basePath 'results']))

% remove variable basePath
clear basePath

% ready
return