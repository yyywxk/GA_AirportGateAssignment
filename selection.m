function chroms1 = selection(chroms,goal)
%ѡ��
disp('selection executing...');
[~,n] = size(chroms);

fit = zeros(1,n);
fitPos = zeros(1,n);
fitnessSum = 0;
chroms1 = chroms;
switch(goal)
    case 1  %ͣ�ڹ̶��ǻ��ڵķɻ�����
        for i=1:n
            fit(1,i) = chroms{1,i}.fitness1;
            fitnessSum = fitnessSum + fit(1,i);
        end
    case 2  %��������ʱ���������Ŷ�
        for i=1:n
            fit(1,i) = chroms{1,i}.fitness2;
            fitnessSum = fitnessSum + fit(1,i);
        end
    case 3  %ʹ�õǻ��ڵ�����
        for i=1:n
            fit(1,i) = chroms{1,i}.fitness3;
            fitnessSum = fitnessSum + fit(1,i);
        end
    case 0  %�ۺ�Ŀ��
        for i=1:n
            fit(1,i) = chroms{1,i}.fitness;
            fitnessSum = fitnessSum + fit(1,i);
        end
    otherwise
        fprintf('ERROR������Ŀ���������\n' );
end

%���̶�ѡ��
for i = 1:n
    fitPos(1,i) = fit(1,i)/fitnessSum;
end
index =1;
while index<=n
    r=ceil(rand * n);
    if rand<fitPos(1,r)
        chroms1{1,index}=chroms{1,r};
        index = index + 1;
    end
end
end



