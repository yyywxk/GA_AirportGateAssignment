function time = timeTransf(date, flag)


if flag == 1
    dt = datevec(date);           % 分离处理
    d = dt(:,3);   % 取出天数
    h = dt(:,4);   % 取出小时数
    m = dt(:,5);   % 取出分钟数
    time = (d-19)*1440+h*60+m;                      % 差值合成分钟数
elseif flag == 2
    time = datestr(datenum(num2str( floor(hms/60)*100 + rem(hms, 60)),'HHMM'),'HH:MM');
else
    dt = datevec(date);           % 分离处理
    d = dt(:,3);   % 取出天数
    time = (d-19)*1440;                      % 差值合成分钟数
end
end