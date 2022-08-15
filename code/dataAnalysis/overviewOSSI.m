% Overview of all OSSI-derived stats

close all
clear
clc

sedmexInit

load baseParameters_L1C2_OSSI.mat
load baseParameters_L2C5_OSSI.mat
load baseParameters_L2C6_OSSI.mat
load baseParameters_L2C8_OSSI.mat
load baseParameters_L2C9_OSSI.mat
load baseParameters_L4C3_OSSI.mat
load baseParameters_L5C2_OSSI.mat
load baseParameters_L6C2_OSSI.mat

% data = DBGetData('L1C2_OSSI', [MET2sedmextime([2021 09 18 1 0 0]), MET2sedmextime([2021 10 18 13 0 0])], {'all'});
% first_non_NaN_index_of_data = find(~isnan(data(:,2)), 1);
% last_non_NaN_index_of_data = find(~isnan(ans(:,2)), 1, 'last');

OSSI = {L1C2_OSSI_par, L2C5_OSSI_par, L2C6_OSSI_par, L2C8_OSSI_par, ...
    L2C9_OSSI_par, L4C3_OSSI_par, L5C2_OSSI_par, L6C2_OSSI_par};
labels = {'L1C2 OSSI', 'L2C5 OSSI', 'L2C6 OSSI', 'L2C8 OSSI', ...
    'L2C9 OSSI', 'L4C3 OSSI', 'L5C2 OSSI', 'L6C2 OSSI'};
ylabels = {'h (m)', ['sensor height' newline 'a.b. (m)'], 'H$_{m0,hf}$ (m)', 'T$_p$ (s)', ...
    'Sk (-)', 'As (-)', 'H$_{m0,lf}$ (m)', 'T$_{m10}$ (s)'};

%% Visualisation
figure2('Name', 'OSSI results (1/2)')
t = tiledlayout(4,1);

for n = 1:4
    ax(n) = nexttile;

    for m = 1:numel(OSSI)
        s(m) = scatter(OSSI{m}(:,1), OSSI{m}(:,n+1), 'filled'); hold on
    end
    
    set(s, 'LineWidth', 0.1)
    ylabel(ylabels(n))
end

legend(ax(2), labels, 'Location', 'eastoutside')
xticks(ax(1:end), OSSI{1}(:,1):3600*24:OSSI{1}(end,1))
xticklabels(ax(end), datestr(sedmex2METtime((OSSI{1}(:,1):3600*24:OSSI{1}(end,1))'), 'dd mmm'))
xticklabels(ax(1:end-1), [])
linkaxes(ax(1:end), 'x')
box(ax(1:end), 'off')

%% Visualisation
figure2('Name', 'OSSI results (2/2)')
t = tiledlayout(4,1);

for n = 5:8
    ax(n) = nexttile;

    for m = 1:numel(OSSI)
        s(m) = scatter(OSSI{m}(:,1), OSSI{m}(:,n+1), 'filled'); hold on
    end
    
    set(s, 'LineWidth', 0.1)
    ylabel(ylabels(n))
end

legend(ax(6), labels, 'Location', 'eastoutside')
xticks(ax(5:end), OSSI{1}(:,1):3600*24:OSSI{1}(end,1))
xticklabels(ax(end), datestr(sedmex2METtime((OSSI{1}(:,1):3600*24:OSSI{1}(end,1))'), 'dd mmm'))
xticklabels(ax(5:end-1), [])
linkaxes(ax(5:end), 'x')
box(ax(5:end), 'off')
