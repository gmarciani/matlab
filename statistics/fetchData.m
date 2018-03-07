function T = fetchData(source, currency, change, startDate, endDate, period)
% FETCHDATA Download historical data about a cryptocurrency.
% source: the data source (e.g. cryptocompare, coinapi).
% currency: cryptocurrency code (e.g. BTC, ETH, XRP).
% change: real currency code (e.g. EUR, USD, GBP).
% startDate: the start datetime of the historical data.
% endDate: the end datetime of the historical data.
% period: the datetime sampling period (e.g. caldays(1), calmonths(1)).
% T: the data table.
switch source
    case "cryptocompare"
        T = fetchDataCryptocompare(currency, change, startDate, endDate, period);
    case "coinapi"
        T = fetchDataCoinAPI(currency, change, startDate, endDate, period);
    otherwise
        error("Unrecognized data source: %s", source);
end
end

function T = fetchDataCryptocompare(currency, change, startDate, endDate, period)
% FETCHDATA Download historical data about a cryptocurrency from Cryptocompare.
% currency: cryptocurrency code (e.g. BTC, ETH, XRP)
% change: real currency code (e.g. EUR, USD, GBP)
% startDate: the start datetime of the historical data.
% endDate: the end datetime of the historical data.
% period: the datetime pace for the sampling (e.g. caldays(1), calmonths(1)).
% T: the data table.
interval = startDate:period:endDate;
rows = cell(length(interval), 2);

i = 1;
for dt = interval
    ts = posixtime(dt);
    url = sprintf('https://min-api.cryptocompare.com/data/pricehistorical?fsym=%s&tsyms=%s&ts=%d', currency, change, ts);
    rawData = webread(url);
    value = rawData.(currency).(change);
    rows(i,:) = {dt, value};
    i = i+1;
end

T = cell2table(rows, 'VariableNames', {'Time','Value'});
T = sortrows(T, {'Time'});
end

function T = fetchDataCoinAPI(currency, change, startDate, endDate, period)
% FETCHDATA Download historical data about a cryptocurrency from CoinAPI.
% currency: cryptocurrency code (e.g. BTC, ETH, XRP)
% change: real currency code (e.g. EUR, USD, GBP)
% startDate: the start datetime of the historical data.
% endDate: the end datetime of the historical data.
% period: the datetime pace for the sampling (e.g. caldays(1), calmonths(1)).
% T: the data table.
%global rawData
apiKey = "B2EFCBEF-BB91-441E-8491-C06F880EC5EC";
symbolId=sprintf("BITSTAMP_SPOT_%s_%s", currency, change);
periodId = sprintf("%s", period);
periodId=strrep(periodId, 'y', 'YRS');
periodId=strrep(periodId, 'mo', 'MTH');
periodId=strrep(periodId, 'd', 'DAY');
startId = datestr(startDate, 'yyyy-mm-ddTHH:MM:SS');
endId = datestr(endDate, 'yyyy-mm-ddTHH:MM:SS');

url = sprintf('https://rest.coinapi.io/v1/ohlcv/%s/history?period_id=%s&time_start=%s&time_end=%s', symbolId, periodId, startId, endId);
wopts = weboptions('HeaderFields', {'X-CoinAPI-Key' char(apiKey)}, 'Timeout', 20);
rawData = webread(url, wopts);

times = datetime({rawData.time_open}.', 'InputFormat', 'yyy-MM-dd''T''HH:mm:ss.SSS''Z');
values = [rawData.price_open].';
T = table(times, values, 'VariableNames', {'Time', 'Value'});
T = sortrows(T, {'Time'});
end