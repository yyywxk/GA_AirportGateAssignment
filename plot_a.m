close all; clear variables; clc;

load('result_3.mat');
load('Pucks.mat');

kuanSum = 0;
zhaiSum = 0;
kuanNum = 0;
zhaiNum = 0;

for i=1:303
    if cell2mat(Pucks(i,7))==1
        kuanSum = kuanSum + 1;
        if result(i,2)~=70
            kuanNum = kuanNum + 1;
        end
    else
        zhaiSum = zhaiSum + 1;
        if result(i,2)~=70
            zhaiNum = zhaiNum + 1;
        end
    end
end

disp('宽体客机')
kuanNum
kuanSum
kuanPer = kuanNum/kuanSum
disp('窄体客机')
zhaiNum
zhaiSum
zhaiPer = zhaiNum/zhaiSum
disp('总体客机')
totalNum = kuanNum+zhaiNum
totalSum = kuanSum+zhaiSum
totalPer = (kuanNum+zhaiNum)/(kuanSum+zhaiSum)

y = [kuanNum kuanSum; zhaiNum zhaiSum; totalNum totalSum];
bar(y,1);
title('成功分配到登机口的飞机数柱状图');
xlabel('飞机类型');
ylabel('飞机数量');
axis([0 4 0 310]);
legend('成功分配的飞机','总飞机数');
set(gca,'XTickLabel',{'宽体客机','窄体客机','总体客机'});