close all; clear variables; clc;

load('result_31.mat');
load('Pucks.mat');
load('Gates.mat');

gate_used_num = zeros(p,1);
for i=1:m
        gate_used_num(result(i,2),1) = gate_used_num(result(i,2),1) + 1;
end
plot(gate_used_num(1:69,1));
title('各登机口接收飞机数');
xlabel('登机口序号');
ylabel('接收飞机数量');

gate_used = (gate_used_num > 0);
t_used_num = sum(gate_used(1:28,1))
s_used_num = sum(gate_used(29:69,1))

gate_used_time = zeros(p,1);
for i=1:m
    arrival_time = cell2mat(Pucks(i,8));
    departure_time = cell2mat(Pucks(i,9));
    if arrival_time<1440
        arrival_time = 1440;
    end
    if departure_time>2880
        departure_time = 2880;
    end
    gate_used_time(result(i,2),1) = gate_used_time(result(i,2),1) + departure_time - arrival_time;
end
gate_used_time = gate_used_time./1440;
figure;
plot(gate_used_time(1:69,1));
title('各登机口使用率');
xlabel('登机口序号');
ylabel('登机口使用率');

shiyong = sum(gate_used_time(1:69,1));
pingjun = shiyong/sum(gate_used(1:69,1))