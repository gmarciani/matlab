%==========================================================================
% KERNEL WORKLOAD DISTRIBUTION
%==========================================================================
% DATA
kernelNames = { 'FWD-1'; 'BCK-2'; 'FWD-2'; 'FWD-3'; 'OTH'};
timePerformance = [ 62 22 6 9 1 ];

% PLOT
figure(2)
h = pie(timePerformance);

hText = findobj(h,'Type','text'); % text object handles
percentValues = get(hText,'String'); % percent values
txt = strcat(kernelNames, repmat({': '}, length(kernelNames), 1));
combinedtxt = strcat(txt, percentValues); % strings and percent values

oldExtents_cell = get(hText,'Extent'); % cell array
oldExtents = cell2mat(oldExtents_cell); % numeric array

for i = 1:size(combinedtxt)
    hText(i).String = combinedtxt(i);
end

newExtents_cell = get(hText,'Extent'); % cell array
newExtents = cell2mat(newExtents_cell); % numeric array

width_change = newExtents(:,3)-oldExtents(:,3);
signValues = sign(oldExtents(:,1));
offset = signValues.*(width_change/2);

textPositions_cell = get(hText,{'Position'}); % cell array
textPositions = cell2mat(textPositions_cell); % numeric array
textPositions(:,1) = textPositions(:,1) + offset; % add offset

for i = 1:size(combinedtxt)
    hText(i).Position = textPositions(i,:);
end

title({'Deep Learning (CUDA)';'Kernel Workload Distribution'});
