function T = getWBIndicator(indicator,country)
% GETWBINDICATOR Download from WOrldBank and indicator for a country.
% indicator: indicator code (i.e. NY.GDP.MKTP.KD.ZG, SL.UEM.TOTL.NE.ZS)
% country: Country code in ISO3 format (i.e. ITA, DEU)
% T: the data table.
url = sprintf('http://api.worldbank.org/v2/countries/%s/indicators/%s?format=json', country, indicator);
rawData = webread(url);
tblData = struct2table(rawData{2,1});
tblData = tblData(~cellfun(@isempty, tblData.value), :);
dates = cellfun(@str2num, tblData.date);
values = cell2mat(tblData.value);
T = table(dates, values, 'VariableNames', {'Date', 'Value'});
T = sortrows(T, {'Date'});
end

