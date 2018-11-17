function time = timeTransf(date, flag)


if flag == 1
    dt = datevec(date);           % ���봦��
    d = dt(:,3);   % ȡ������
    h = dt(:,4);   % ȡ��Сʱ��
    m = dt(:,5);   % ȡ��������
    time = (d-19)*1440+h*60+m;                      % ��ֵ�ϳɷ�����
elseif flag == 2
    time = datestr(datenum(num2str( floor(hms/60)*100 + rem(hms, 60)),'HHMM'),'HH:MM');
else
    dt = datevec(date);           % ���봦��
    d = dt(:,3);   % ȡ������
    time = (d-19)*1440;                      % ��ֵ�ϳɷ�����
end
end