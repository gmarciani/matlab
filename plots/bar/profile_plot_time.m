%==========================================================================
% RESPONSE TIME ANALYSIS
%==========================================================================
% DATA
t = readtable("../out/profile/timing_float_05.csv");

%blockDimensions = { '16', '32', '64' };
%timePerformance = [ 16 20; 32 36; 64 68 ];
%optimizationLevels = {'O0', 'O1'};

n_optimizationLevels = 4;
replications = 10;

timePerformance = mean(reshape(t{:,'time'}, replications, []));
timePerformance = reshape(timePerformance, n_optimizationLevels, []);
timePerformance = timePerformance.';
blockDimensions = reshape(t{:,'block_dim'}, n_optimizationLevels*replications, []);blockDimensions=blockDimensions(1,:);
optimizationLevels = {'O0', 'O1', 'O2', 'O3'};

maxTime = max(max(timePerformance));
minTime = min(min(timePerformance));

scaleMax = 1.05;
scaleMin = 0.992;

% PLOT
figure(1)
bar(timePerformance);

title({'Deep Learning (CUDA)';'Response Time Analysis'});

xlabel('Block Dimension');
xlim([0.5 7.5]);
set(gca, 'XTick', 1:7, 'XTickLabel', blockDimensions)

ylabel('Time (ms)');
ylim([minTime*scaleMin maxTime*scaleMax]);

yyaxis right
plot([ 0.5 1 2 3 4 5 6 7 7.5 ], [1 1 1 1 1 1 1 1 1] * minTime, '--r')
hold on
plot([ 0.5 1 2 3 4 5 6 7 7.5 ], [1 1 1 1 1 1 1 1 1] * maxTime, '--r')
hold off

ylim([minTime*scaleMin maxTime*scaleMax]);
set(gca, 'YTick', [round(minTime) round(maxTime)]);

hleg = legend(optimizationLevels, 'Location', 'northeast', 'Orientation', 'horizontal');
title(hleg, 'Optimization Level');
