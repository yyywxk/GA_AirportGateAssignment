close all; clear variables; clc;
%{
%%Pucks.xlsx
%{
cols
1：  turn_no
2：  turn_recording
3：  arrival_no
4：  departure_no
5：  arrival_type
6：  departure_type
7：  plane_size
8:   arrival_time
9:   departure_time
10:  arrival_date
11:  departure_date
%}
[~, ~, Pucks] = xlsread("./Pucks.xlsx");
Pucks = Pucks(2:end,1:9);
Pucks(:,10) = Pucks(:,8);
Pucks(:,11) = Pucks(:,9);
Pucks(:,8) = num2cell(timeTransf(Pucks(:,8),1));
Pucks(:,9) = num2cell(timeTransf(Pucks(:,9),1));
[m,n] = size(Pucks);
save Pucks
disp('Pucks.xlsx');

%%Gates.xlsx
%{
cols
1：  gate
2：  terminal
3：  area
4：  arrival_type
5：  departure_type
6：  gate_size
7:   idle_start_time
8:   gate_no
%}
[~, ~, Gates] = xlsread("./Gates.xlsx");
Gates = Gates(2:end,1:end);
[p,~] = size(Gates);
Gates = [Gates num2cell(zeros(p,1)) num2cell((1:p)')];
[p,q] = size(Gates);
save Gates
disp('Gates.xlsx');

%%Tickets.xlsx
%{
cols
1：  passenger_recording
2：  passenger_no
3：  arrival_no
4：  departure_no
%}
[~, ~, Tickets] = xlsread("./Tickets.xlsx");
Tickets = Tickets(2:end,1:end);
[u,v] = size(Tickets);
delete = [];
for i=1:u
    arrPucks = Pucks(find(timeTransf(Pucks(:,10),3)==timeTransf(Tickets(i,4),3)),:);
    tmparr = findInCell(Tickets(i,3),arrPucks(:,3));
    depPucks = Pucks(find(timeTransf(Pucks(:,11),3)==timeTransf(Tickets(i,6),3)),:);
    tmpdep = findInCell(Tickets(i,5),depPucks(:,4));
    if isempty(tmparr)||isempty(tmpdep)
        delete = [delete i];
        continue
    end
    Tickets(i,7) = arrPucks(tmparr,1);
    Tickets(i,8) = depPucks(tmpdep,1);
end
Tickets(delete,:)=[];
[u,v] = size(Tickets);
save Tickets
disp('Tickets.xlsx');
%}

load Pucks
[m,n] = size(Pucks);
load Gates
[p,q] = size(Gates);
load Tickets
[u,v] = size(Tickets);

%相邻两航班之间的最小安全时间间隔(min)
timeInter = 45;

%%解结构，参数设定 =======================================

%种群，染色体组成
config = load('config.txt');
%最大迭代次数
Maxgen = config(1,1);
%种群大小
Y = config(1,2);
%交叉算子
croPos = config(1,3);
%变异算子
mutPos = config(1,4);
%权重
w1 = config(1,5);
w2 = config(1,6);
w3 = config(1,7);
%单目标or多目标
goal = config(1,8);
chroms = cell(1,Y);
%============================================
%计时开始
tic;
%初始化，构建初始方案/种群
for i=1:Y
    structchroms.HangbanSeNum = cell2mat(Pucks(1:m, 1)');             %turn_no
    structchroms.Position = zeros(1,m);
    structchroms.unappropriated = cell2mat(Pucks(1:m, 1)');
    structchroms.fitness1 = 0;
    structchroms.fitness2 = 0;
    structchroms.fitness3 = 0;
    structchroms.fitness = 0;
    chroms{1,i} = structchroms;
    
end
disp('分配登机口');
%登机口
chroms = position(chroms,'first',Pucks,Gates,timeInter);

chroms{1,1}.Position
chroms = fitness(chroms, Gates, Pucks, Tickets, w1, w2, w3, goal);
chroms{1,1}.Position
%{%}
%适应度值排序

chroms = sortByFitness(chroms,goal);

%每代精英策略
chromBest = chroms{1,1};
%历史记录
trace=zeros(4,Maxgen);
disp('迭代开始');
%迭代开始
k=1;


while(k<=Maxgen)
    STR=sprintf('%s%d','进化代数',k);
    disp(STR);
    
    %选择
    chroms = selection(chroms,goal);
    %交叉
    chroms = crossover(chroms, croPos);%%%%%%%%%%%%%%
    %变异
    chroms = mutation(chroms, Gates, mutPos);
    %计算fitness
    chroms = position(chroms,'else',Pucks,Gates,timeInter);
    chroms = fitness(chroms, Gates, Pucks, Tickets, w1, w2, w3, goal);
    %适应度值排序
    chroms = sortByFitness(chroms,chromBest,goal);
    %统计，取出精英
    chromBest = chroms{1,1};
    trace(1,k) = chroms{1,1}.fitness1;
    trace(2,k) = chroms{1,1}.fitness2;
    trace(3,k) = chroms{1,1}.fitness3;
    trace(4,k) = chroms{1,1}.fitness;
    k = k + 1;
    %迭代结束
end
%计时结束
toc;

%输出结果
%格式：最优个体行1：飞机序列号 2：登机口号 3适应度1 4：适应度2  5: 适应度值3  6：综合适应度
disp('飞机序列号');
chroms{1,1}.HangbanSeNum
disp('登机口号');
chroms{1,1}.Position

%甘特图
%ganttest(chroms{1,1},hangbanData,Gates,time);