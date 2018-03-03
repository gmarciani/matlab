function [Max,Min,YMax,YMin,Mean,Std] = getDescriptors(T)
% GETDESCRIPTORS Compute the notable values of a WB table.
% T: the WB table.
% Max: the maximum value in the series.
% Min: the minimum value in the series.
% YMax: the year of the maximum value of the series.
% YMin: the year of the minimum value of the series.
% Mean: the mean value of the series.
% Std: the standard deviation of the series.
yrs = T.Date;
vls = T.Value;
[Max,iMax] = max(vls);
[Min,iMin] = min(vls);
YMax = yrs(iMax);
YMin = yrs(iMin);
Mean = mean(vls);
Std = std(vls);
end

