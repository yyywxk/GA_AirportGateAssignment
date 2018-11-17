function chroms1 = selection(chroms,goal)
%选择
disp('selection executing...');
[~,n] = size(chroms);

fit = zeros(1,n);
fitPos = zeros(1,n);
fitnessSum = 0;
chroms1 = chroms;
switch(goal)
    case 1  %停在固定登机口的飞机数量
        for i=1:n
            fit(1,i) = chroms{1,i}.fitness1;
            fitnessSum = fitnessSum + fit(1,i);
        end
    case 2  %总体流程时间或总体紧张度
        for i=1:n
            fit(1,i) = chroms{1,i}.fitness2;
            fitnessSum = fitnessSum + fit(1,i);
        end
    case 3  %使用登机口的数量
        for i=1:n
            fit(1,i) = chroms{1,i}.fitness3;
            fitnessSum = fitnessSum + fit(1,i);
        end
    case 0  %综合目标
        for i=1:n
            fit(1,i) = chroms{1,i}.fitness;
            fitnessSum = fitnessSum + fit(1,i);
        end
    otherwise
        fprintf('ERROR！请检查目标参数设置\n' );
end

%轮盘赌选择
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



