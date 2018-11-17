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

disp('����ͻ�')
kuanNum
kuanSum
kuanPer = kuanNum/kuanSum
disp('խ��ͻ�')
zhaiNum
zhaiSum
zhaiPer = zhaiNum/zhaiSum
disp('����ͻ�')
totalNum = kuanNum+zhaiNum
totalSum = kuanSum+zhaiSum
totalPer = (kuanNum+zhaiNum)/(kuanSum+zhaiSum)

y = [kuanNum kuanSum; zhaiNum zhaiSum; totalNum totalSum];
bar(y,1);
title('�ɹ����䵽�ǻ��ڵķɻ�����״ͼ');
xlabel('�ɻ�����');
ylabel('�ɻ�����');
axis([0 4 0 310]);
legend('�ɹ�����ķɻ�','�ܷɻ���');
set(gca,'XTickLabel',{'����ͻ�','խ��ͻ�','����ͻ�'});