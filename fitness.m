% function chroms = fitness(chroms, positionData, time, hangbanData, oilCost, w1, w2, w3, goal)
function chroms = fitness(chroms, positionData, hangbanData, peopleData, w1, w2, w3, goal)
disp('fitness executing...');
[~,t] = size(chroms);%染色体的数量
[~,m] = size(chroms{1,1}.HangbanSeNum);%飞机数量
[n,~] = size(positionData);%登机口数量，包括虚拟登机口
chromsIndex = 1;
if goal~=1
    flightA=cell2mat(peopleData(:,7)');%获取乘客到达航班飞机序号
    flightD=cell2mat(peopleData(:,8)');%获取乘客出发航班飞机序号
    [~,k]=size(flightA);%乘客组数量
    num=cell2mat(peopleData(:,2)');%每组乘客的数量
    traveler=1;
end
while chromsIndex<=t
    HangbanIndex = 1;
%     kaoqiaohbNum = 0;
%     cost = 0;
    flightSum=0;
    gateSum=zeros(1,n);
    if goal~=1
        stress=zeros(1,k);
        CirtimeSum=zeros(1,k);%流程时间
        CirtimeSum1=zeros(1,k);%组流程时间
        PorttimeSum=zeros(1,k);%捷运时间
        WalktimeSum=zeros(1,k);%行走时间
        timeSum=zeros(1,k);%旅客换乘时间
        jiont_time=zeros(1,k);%航班连接时间
    end
   while HangbanIndex<=m        
        Pos = chroms{1,chromsIndex}.Position(HangbanIndex);%飞机对应的登机口
        %停在固定登机口的飞机数量
       if Pos< n
           flightSum=flightSum+1;
       end             
        %求解使用的登机口的数量
        if Pos< n
           gateSum(Pos)=1;
        end       
        HangbanIndex = HangbanIndex+1;
   end 
    
   if goal~=1
       %总体流程时间或总体紧张度
        while traveler<=k
            PosA=chroms{1,chromsIndex}.Position(flightA(1,traveler));%到达飞机对应的登机口
            PosD=chroms{1,chromsIndex}.Position(flightD(1,traveler));%出发飞机对应的登机口
            if strcmp(cell2mat(hangbanData(flightA(1,traveler),5)),'D')&& strcmp(cell2mat(hangbanData(flightD(1,traveler),6)),'D')
                if(( PosA<29 && PosD<29)||((28<PosA)&&(PosA<70) && (28<PosD)&&(PosD<70)))
                    CirtimeSum(1,traveler)=15;%均在航站楼T或均在卫星厅S
                    PorttimeSum(1,traveler)=0;
                elseif((PosA<70) &&(PosD<70))%停在临时停机的航班不考虑
                    CirtimeSum(1,traveler)=20;
                    PorttimeSum(1,traveler)=1*8;
                end
            elseif(strcmp(cell2mat(hangbanData(flightA(1,traveler),5)),'D')&& strcmp(cell2mat(hangbanData(flightD(1,traveler),6)),'I'))
                if(( PosA<29 && PosD<29)||((28<PosA)&&(PosA<70) && (28<PosD)&&(PosD<70)))
                    CirtimeSum(1,traveler)=35;%均在航站楼T或均在卫星厅S
                    PorttimeSum(1,traveler)=0;
                elseif((PosA<70) &&(PosD<70))
                    CirtimeSum(1,traveler)=40;
                    PorttimeSum(1,traveler)=1*8;
                end
            elseif(strcmp(cell2mat(hangbanData(flightA(1,traveler),5)),'I')&& strcmp(cell2mat(hangbanData(flightD(1,traveler),6)),'I'))
                if(( PosA<29 && PosD<29)||((28<PosA)&&(PosA<70) && (28<PosD)&&(PosD<70)))
                    CirtimeSum(1,traveler)=20;%均在航站楼T或均在卫星厅S
                    PorttimeSum(1,traveler)=0;
                elseif((PosA<70) &&(PosD<70))
                    CirtimeSum(1,traveler)=30;
                    PorttimeSum(1,traveler)=1*8;
                end
            elseif(strcmp(cell2mat(hangbanData(flightA(1,traveler),5)),'I')&& strcmp(cell2mat(hangbanData(flightD(1,traveler),6)),'D'))
                if(( PosA<29 && PosD<29))
                    CirtimeSum(1,traveler)=35;%均在航站楼T
                    PorttimeSum(1,traveler)=0;
                elseif((28<PosA)&&(PosA<70) && (28<PosD)&&(PosD<70))
                    CirtimeSum(1,traveler)=45;%均在卫星厅S
                    PorttimeSum(1,traveler)=2*8;
                elseif((PosA<70) &&(PosD<70))
                    CirtimeSum(1,traveler)=40;
                    PorttimeSum(1,traveler)=1*8;
                end
            end

            if (PosA<=9&&PosD<=9)%行走时间
                WalktimeSum(1,traveler)=10;       
            elseif ((PosA<=9)&&(PosD>=10&&PosD<=19))||((PosD<=9)&&(PosA>=10&&PosA<=19))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA<=9)&&(PosD>=20&&PosD<=28))||((PosD<=9)&&(PosA>=20&&PosA<=28))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA<=9)&&(PosD>=29&&PosD<=38))||((PosD<=9)&&(PosA>=29&&PosA<=38)) 
                WalktimeSum(1,traveler)=25;
            elseif ((PosA<=9)&&(PosD>=39&&PosD<=48))||((PosD<=9)&&(PosA>=39&&PosA<=48))     
                WalktimeSum(1,traveler)=20;
            elseif ((PosA<=9)&&(PosD>=49&&PosD<=58))||((PosD<=9)&&(PosA>=49&&PosA<=58))
                WalktimeSum(1,traveler)=25;
            elseif ((PosA<=9)&&(PosD>=59&&PosD<=69))||((PosD<=9)&&(PosA>=59&&PosA<=69))    
                WalktimeSum(1,traveler)=25;
            elseif (PosA>=10&&PosA<=19)&&(PosD>=10&&PosD<=19)
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=20&&PosD<=28))||((PosD>=10&&PosD<=19)&&((PosA>=20&&PosA<=28)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=29&&PosD<=38))||((PosD>=10&&PosD<=19)&&((PosA>=29&&PosA<=38)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=39&&PosD<=48))||((PosD>=10&&PosD<=19)&&((PosA>=39&&PosA<=48)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=49&&PosD<=58))||((PosD>=10&&PosD<=19)&&((PosA>=49&&PosA<=58)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=10&&PosA<=19)&&(PosD>=59&&PosD<=69))||((PosD>=10&&PosD<=19)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=20&&PosD<=28))
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=29&&PosD<=38))||((PosD>=20&&PosD<=28)&&((PosA>=29&&PosA<=38)))
                WalktimeSum(1,traveler)=25;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=39&&PosD<=48))||((PosD>=20&&PosD<=28)&&((PosA>=39&&PosA<=48)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=49&&PosD<=58))||((PosD>=20&&PosD<=28)&&((PosA>=49&&PosA<=58)))
                WalktimeSum(1,traveler)=25;
            elseif ((PosA>=20&&PosA<=28)&&(PosD>=59&&PosD<=69))||((PosD>=20&&PosD<=28)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=25;
            elseif ((PosA>=29&&PosA<=38)&&(PosD>=29&&PosD<=38))
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=29&&PosA<=38)&&(PosD>=39&&PosD<=48))||((PosD>=29&&PosD<=38)&&((PosA>=39&&PosA<=48)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=29&&PosA<=38)&&(PosD>=49&&PosD<=58))||((PosD>=29&&PosD<=38)&&((PosA>=49&&PosA<=58)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=29&&PosA<=38)&&(PosD>=59&&PosD<=69))||((PosD>=29&&PosD<=38)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=20;
            elseif ((PosA>=39&&PosA<=48)&&(PosD>=39&&PosD<=48))
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=39&&PosA<=48)&&(PosD>=49&&PosD<=58))||((PosD>=39&&PosD<=48)&&((PosA>=49&&PosA<=58)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=39&&PosA<=48)&&(PosD>=59&&PosD<=69))||((PosD>=39&&PosD<=48)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=15;
            elseif ((PosA>=49&&PosA<=58)&&(PosD>=49&&PosD<=58))
                WalktimeSum(1,traveler)=10;
            elseif ((PosA>=49&&PosA<=58)&&(PosD>=59&&PosD<=69))||((PosD>=49&&PosD<=58)&&((PosA>=59&&PosA<=69)))
                WalktimeSum(1,traveler)=20;    
            elseif ((PosA>=59&&PosA<=69)&&(PosD>=59&&PosD<=69))
                WalktimeSum(1,traveler)=10;        
            end
            CirtimeSum1(1,traveler)=num(1,traveler)*CirtimeSum(1,traveler);%组流程时间
            timeSum(1,traveler)=CirtimeSum(1,traveler)+PorttimeSum(1,traveler)+WalktimeSum(1,traveler);%计算一个旅客的换乘时间
            jiont_time(1,traveler)=cell2mat(hangbanData(flightD(1,traveler),9))-cell2mat(hangbanData(flightA(1,traveler),8));
            stress(1,traveler)=num(1,traveler)*timeSum(1,traveler)/jiont_time(1,traveler);%计算一组旅客的换乘紧张度
            %考虑换乘失败的惩罚机制
            if(stress(1,traveler)>1)
                timeSum(1,traveler)=6*60;
                stress(1,traveler)=num(1,traveler)*timeSum(1,traveler)/jiont_time(1,traveler);
            end

            traveler=traveler+1;    
        end
   end
    
    
    switch (goal)
        case 1
            %停在固定登机口的飞机数量
            chroms{1,chromsIndex}.fitness1 = 1/flightSum;
        case 2
            %总体流程时间
            chroms{1,chromsIndex}.fitness2 = sum(CirtimeSum1);
            %总体紧张度
%             chroms{1,chromsIndex}.fitness2 = sum(stress);
        case 3
            %使用的登机口的数量
            chroms{1,chromsIndex}.fitness3 = sum(gateSum);
        case 0
            %停在固定登机口的飞机数量
            chroms{1,chromsIndex}.fitness1 = 1/flightSum;
            %总体流程时间
            chroms{1,chromsIndex}.fitness2 = sum(CirtimeSum1);
            %总体紧张度
            %chroms{1,chromsIndex}.fitness2 = sum(stress);
            %使用的登机口的数量
            chroms{1,chromsIndex}.fitness3 = sum(gateSum);
            %多目标===================
            fitness1 = 1/flightSum;
            fitness2 = chroms{1,chromsIndex}.fitness2;%最大化变最小化；取倒数
            fitness3 = sum(gateSum);
            %%归一化=====================
            fit0 = max([fitness1, fitness2,fitness3]);  %求最大的作分母
            chroms{1,chromsIndex}.fitness = w1*fitness1/fit0 + w2*fitness2/fit0+ + w3*fitness3/fit0;%总目标函数公式
        otherwise
            fprintf('ERROR！请检查目标参数设置\n' );
    end  
    chromsIndex = chromsIndex + 1;
end
end